#!/bin/bash
# commande rft qui drécupère un fichier mis dans la corbeile

if [ $# -ne 1 ] && [ $# -ne 2 ] ; then
    echo ""Usage: $0 fich_ou_rep rep""
    exit 1
fi

if [ $# -e 2 ] ; then
    rep=$2
    exit 1
else rep=$HOME
fi

echo "Déplacement de $1 dans $rep"
mv "$HOME/Bureau/trash/$1" $rep