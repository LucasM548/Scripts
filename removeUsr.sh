#!/bin/bash
# commande removeusrqui permet de supprimer des utilisateurs

# Vérifie qu'il y a exactement un argument
if [ $# -ne 1 ]; then
    # \033[33m avec le -e permet de mettre le texte en jaune
    # et \033[0m permet de remettre la couleur blanche (sinon toutes les prochaines lignes serons en jaune)
    echo -e "\033[33m====== Usage: $0 <fichier_config> ======\033[0m"
    exit 1
fi

# Vérifie que l'arguement est bien un fichier valide
if [ ! -f "$1" ]; then
    # \033[31m avec le -e permet de mettre le texte en rouge
    # et \033[0m permet de remettre la couleur blanche (sinon toutes les prochaines lignes serons en rouge)
    echo -e "\033[31m====== Erreur : $1 n'est pas un fichier valide ======\033[0m"
    exit 2
fi

# Vérifie que l'utilisateur à bien lancer le script en mode administrateur (avec un sudo avant)
# Lorsque qu'on fait un sudo id -u, ça renvoie 0 car on à l'UID 0
# Evite le $(whoami) = "root" car si un utilisateur s'appelle root, le script va fonctionner
if [ $(id -u) -ne 0 ]; then
    echo -e "\033[31m====== Erreur : Le script doit être executé en mode administrateur (sudo) ======\033[0m"
    exit 3
fi

# Stock le nombre de ligne du fichier configuration
nbLines=$(wc -l < "$1") # Le < permet de retourner uniquement le nombre de ligne

# Analyse de chaque ligne du fichier
for ((i = 1; i <= $nbLines+1; i++)); do
    # Stock la ligne numéro i dans une variable
    Lines=$(sed -n "${i}p" "$1" | tr -d " ")
    # Le <<< permet d'envoyer une chaine de caractère sans utiliser un echo avec un pipe
    user=$(cut -d ',' -f1 <<< "$Lines")
    group=$(cut -d ',' -f2 <<< "$Lines")
    if [ $(awk -F',' '{print NF}' <<< $Lines) = 4 ]; then
        deluser "$user" 2>/dev/null
        if [ $? -ne 0]; then
            userdel "$user" 2>/del/null
        fi
        delgroup "$group"
        if [ $? -ne 0]; then
            groupdel "$group" 2>/del/null
        fi
    fi
done

rm -rd /home/RepUserSAE/*
