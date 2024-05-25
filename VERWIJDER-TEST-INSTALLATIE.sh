#!/bin/bash

## S1192689 - Sten Weierink - Windesheim Zwolle ##
## Leerjaar 2 - Vak IAC ##

## Functie voor welkomstbericht en het invoeren van de klantnaam ##
function welkom {
    echo "Welkom bij het script voor het verwijderen van klantomgevingen binnen de Testomgeving."
    echo "Voer de klantnaam in:"
    read klantnaam
    klantdir="./${klantnaam}-test"
}

## Functie voor het controleren van het bestaan van de klantmap ##
function controleer_klantmap {
    if [ ! -d "$klantdir" ]; then
        echo "De opgegeven klantomgeving bestaat niet."
        exit 1
    fi
}

## Functie voor het vragen om bevestiging van verwijdering ##
function vraag_bevestiging {
    echo "Klantomgeving ${klantnaam}-test verwijderen? Dit kan niet ongedaan worden gemaakt. ja/nee"
    read bevestiging
}

## Functie voor het daadwerkelijk uitvoeren van verwijdering ##
function voer_verwijdering_uit {
    if [[ "$bevestiging" == "ja" ]]; then
        cd "$klantdir" && vagrant destroy -f
        cd ..
        rm -rf "$klantdir"
        echo "Klantomgeving ${klantnaam}-test is succesvol verwijderd."
    else
        echo "Verwijdering geannuleerd."
    fi
}

## Hoofdprogramma ##
welkom
controleer_klantmap
vraag_bevestiging
voer_verwijdering_uit
