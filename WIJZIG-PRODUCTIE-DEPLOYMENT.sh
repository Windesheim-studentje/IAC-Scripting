#!/bin/bash

## S1192689 - Sten Weierink - Windesheim Zwolle ##
## Leerjaar 2 - Vak IAC ##

## Declaratie van globale variabelen ##
klantnaam=

## Functie voor welkomstbericht en het invoeren van de klantnaam ##
function welkom {
    echo "Welkom bij het script voor het wijzigen van virtuele machines die al zijn deployed in Productie."
    echo "Voer de klantnaam in:"
    read klantnaam
    klantdir="./${klantnaam}-productie"  # Volledig pad naar klantmap
}

## Functie voor het controleren van het bestaan van de klantmap ##
function controleer_klantmap {
    if [ ! -d "$klantdir" ]; then
        echo "De opgegeven omgeving bestaat niet."
        exit 1
    fi
}

## Functie voor het wijzigen van RAM-geheugen in de Vagrantfile ##
function wijzig_ram {
    echo "Hoeveel RAM moet de machine toegewezen krijgen? (MB)"
    read new_ram
    sed -i "/vb.memory =/c\      vb.memory = \"$new_ram\"" "${klantdir}/Vagrantfile"
    echo "Wijziging in RAM-geheugen is doorgevoerd. Nieuwe RAM geheugen is nu $new_ram MB."
}

## Functie voor het toepassen van de wijzigingen via vagrant reload ##
function pas_wijzigingen_toe {
    cd "${klantdir}"
    vagrant reload
    echo "De omgeving voor ${klantnaam}-prod is bijgewerkt."
}

## Hoofdprogramma ##
welkom
controleer_klantmap
wijzig_ram
pas_wijzigingen_toe
