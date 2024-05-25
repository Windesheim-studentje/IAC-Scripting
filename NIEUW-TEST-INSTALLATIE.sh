#!/bin/bash

## S1192689 - Sten Weierink - Windesheim Zwolle ##
## Leerjaar 2 - Vak IAC ##

## Welkom tekst met daarna de vraag welke klant het betreft. ##
function welkom {
    echo "Welkom bij deployment script voor het uitrollen van virtuele machines binnen de Productieomgeving."
    echo "Voer uw klantnaam in (geen spaties):"
    read klantnaam
    klantdir="./${klantnaam}-test"  # Aangepast pad naar klantmap
    mkdir -p "${klantdir}"
}

## Functie voor OS selectie ##
function selecteer_os {
    echo "Maak een keuze voor het OS dat gebruikt moet worden."
    select boxtype in "ubuntu/bionic64" "centos/7"; do
        case $boxtype in
            "ubuntu/bionic64") echo "Ubuntu geselecteerd"; return;;
            "centos/7") echo "CentOS geselecteerd"; return;;
            *) echo "Ongeldige selectie";;
        esac
    done
}

## Functie voor server type selectie ##
function selecteer_server_type {
    echo "Maak een keuze voor het type server dat uitgerold moet worden."
    select servertype in "Webserver" "Databaseserver" "Loadbalancer"; do
        case $servertype in
            "Webserver") playbook="PLAYBOOK-WEBSERVER.yml"; return;;
            "Databaseserver") playbook="PLAYBOOK-DATABASESERVER.yml"; return;;
            "Loadbalancer") playbook="PLAYBOOK-LOADBALANCER.yml"; return;;
            *) echo "Ongeldige selectie";;
        esac
    done
}

## Functie voor het vragen naar RAM toewijzing ##
function vraag_ram {
    echo "Hoeveel RAM moet de machine toegewezen krijgen? (MB)"
    read vm_ram
}

## Functie voor het vragen naar aantal VM's ##
function vraag_aantal_machines {
    echo "Hoeveel VM's moeten er uitgerold worden?"
    read aantal_machines
}

## Functie om Vagrantfile te genereren ##
function genereer_vagrantfile {
    local klantnaam="$1"  # Voeg deze regel toe om de klantnaam als argument door te geven
    cp "${playbook}" "${klantdir}/${playbook}"

    cat > "${klantdir}/Vagrantfile" <<EOF
Vagrant.configure("2") do |config|
  config.vm.box = "$boxtype"
EOF

    for (( i=1; i<=$aantal_machines; i++ )); do
        vm_name="${klantnaam}-${servertype,,}-test$i"
        vm_ip="192.168.56.1$((i))"
        
        cat >> "${klantdir}/Vagrantfile" <<EOF
  config.vm.define "$vm_name" do |server|
    server.vm.hostname = "$vm_name"
    server.vm.network "private_network", ip: "$vm_ip"
    server.vm.provider "virtualbox" do |vb|
      vb.name = "$vm_name"
      vb.memory = "$vm_ram"
    end
    server.vm.provision "ansible" do |ansible|
      ansible.playbook = "${playbook}"
    end
  end
EOF
    done
    
    cat >> "${klantdir}/Vagrantfile" <<EOF
end
EOF

    # Toon de gegenereerde Vagrantfile
    echo "Gegenereerde Vagrantfile:"
    cat "${klantdir}/Vagrantfile"
}

## Functie om de deployment uit te voeren ##
function start_deployment {
    echo "Vagrantfile + Ansible Playbook voor type $servertype zijn in de map ${klantnaam}-test voor $aantal_machines machines gedeployed."
    echo "Deployment uitvoeren..."
    cd "${klantdir}"
    vagrant up
    echo "Deployment succesvol. $aantal_machines VM(s) voor $klantnaam met als type $servertype dat $vm_ram MB RAM toegewezen heeft zijn nu actief."
}

## Hoofdprogramma ##
welkom
selecteer_os
selecteer_server_type
vraag_ram
vraag_aantal_machines
genereer_vagrantfile "$klantnaam"
start_deployment
