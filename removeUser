#!/bin/bash
# commande removeUser permet de supprimer des utilisateurs

if [ $# -ne 1 ]; then
    echo -e "\033[33m====== Usage: $0 <fichier_config> ======\033[0m"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo -e "\033[31m====== Erreur : $1 n'est pas un fichier valide ======\033[0m"
    exit 2
fi

if [ $(id -u) -ne 0 ]; then
    echo -e "\033[31m====== Erreur : Le script doit être executé en mode administrateur (sudo) ======\033[0m"
    exit 3
fi

nbLines=$(wc -l < "$1")

for ((i = 1; i <= $nbLines+1; i++)); do
    Lines=$(sed -n "${i}p" "$1" | tr -d " ")
    user=$(cut -d ',' -f1 <<< "$Lines")
    group=$(cut -d ',' -f2 <<< "$Lines")
    rephome=$(cut -d ',' -f3 <<< "$Lines")
    if [ $(awk -F',' '{print NF}' <<< $Lines) = 4 ]; then
        deluser "$user" 2>/dev/null
        if [ $? -ne 0 ]; then
            userdel "$user" 2>/dev/null
        fi
        delgroup "$group" 2>/dev/null
        if [ $? -ne 0 ]; then
            groupdel "$group" 2>/dev/null
        fi

        full_path="$rephome/$user"

        if [ -d "$full_path" ] && [ "$full_path" != "/" ] && [ "$full_path" != "/home" ]; then
            rm -rd "$rephome/$user"
        fi
    fi
done
