#!/bin/bash

## S1192689 - Sten Weierink - Windesheim Zwolle ##
## Leerjaar 2 - Vak IAC ##

## Welkom melding ##
echo "## Welkom bij het IAC-script het implementeren van Virtuele Machines. ##"
echo "## Dit script is gemaakt door Sten Weierink - S1192686 te Windesheim Zwolle. ##"

## Keuzemenu voor verschillende opties ##
echo "## Kies een optie: ##"
select optie in "Nieuwe Deployment" "Wijzigen Deployment" "Verwijderen Deployment" "EXIT"; do
    case $optie in
    
        ## Optie voor nieuwe deployment ##
        "Nieuwe Deployment")
            echo "## Kies tussen het opzetten van een nieuwe Testomgeving of Productieomgeving: ##"
            select omgevingstype in "Testomgeving" "Productieomgeving"; do
                case $omgevingstype in
                    "Testomgeving")
                        ./NIEUW-TEST-INSTALLATIE.sh
                        break 2
                        ;;
                    "Productieomgeving")
                        ./NIEUW-PRODUCTIE-INSTALLATIE.sh
                        break 2
                        ;;
                    *)
                        echo "## Ongeldige selectie! ##"
                        ;;
                esac
            done
            ;;
        
        ## Optie voor wijzigen van deployment ##
        "Wijzigen Deployment")
            echo "## Kies tussen het wijzigen van de Testomgeving of de Productieomgeving: ##"
            select omgevingstype in "Testomgeving" "Productieomgeving"; do
                case $omgevingstype in
                    "Testomgeving")
                        ./WIJZIG-TEST-DEPLOYMENT.sh
                        break 2
                        ;;
                    "Productieomgeving")
                        ./WIJZIG-PRODUCTIE-DEPLOYMENT.sh
                        break 2
                        ;;
                    *)
                        echo "## Ongeldige selectie! ##"
                        ;;
                esac
            done
            ;;
        
        ## Optie voor verwijderen van deployment ##
        "Verwijderen Deployment")
            echo "## Kies tussen het verwijderen van de Testomgeving of de Productieomgeving: ##"
            select omgevingstype in "Testomgeving" "Productieomgeving"; do
                case $omgevingstype in
                    "Testomgeving")
                        ./VERWIJDER-TEST-INSTALLATIE.sh
                        break 2
                        ;;
                    "Productieomgeving")
                        ./VERWIJDER-PRODUCTIE-INSTALLATIE.sh
                        break 2
                        ;;
                    *)
                        echo "## Ongeldige selectie! ##"
                        ;;
                esac
            done
            ;;
        
        ## Optie om het script te verlaten ##
        "EXIT")
            echo "## Het script wordt afgesloten! ##"
            exit 0
            ;;
        *)
            echo "## Ongeldige selectie! ##"
            ;;
    esac
done
