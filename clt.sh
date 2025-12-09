#!/bin/bash
# commande srm qui déplace le fichier dans une poubelle nommée trash

# Vérifie qu'il y a exactement un argument
if [ $# -ne 0 ]; then
    echo "Usage: $0"
    exit 1
fi

rm -iR ~/Bureau/trash/*
