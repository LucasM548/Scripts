#!/bin/bash
# commande srm qui déplace le fichier dans une poubelle nommée trash

# Vérifie qu'il y a exactement un argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 fich_ou_rep"
    exit 1
fi

# Vérifie si le dossier ~/Bureau/trash existe
if [ ! -e ~/Bureau/trash ]; then
    echo "Création de ~/Bureau/trash"
    mkdir -p ~/Bureau/trash
    if [ $? -ne 0 ]; then
        echo "Problème pour créer le répertoire ~/Bureau/trash/"
        exit 1
    fi
fi

echo "Déplacement de $1 dans ~/Bureau/trash"
mv "$1" ~/Bureau/trash/  # pb éventuel si un fichier du même nom existe déjà
if [ $? -eq 0 ]; then
    echo "$1 déplacé dans la corbeille"
else
    echo "Problème avec $1 ou ~/Bureau/trash/"
    exit 1
fi
