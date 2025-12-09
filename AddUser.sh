#!/bin/bash
# commande nomAddUser qui permet de créer des utilisateurs

# Vérifie qu'il y a exactement un argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <fichier_config>"
    exit 1
fi

# Vérifie que l'arguement est bien un fichier valide
if [ ! -f "$1" ]; then
    echo "Erreur : $1 n'est pas un fichier valide"
    exit 2
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
    rephome=$(cut -d ',' -f3 <<< "$Lines")
    repskel=$(cut -d ',' -f4 <<< "$Lines")
    if [ $(awk -F',' '{print NF}' <<< $Lines) = 4 ] && [ -d "$repskel" ]; then
        # le -f permet de ne rien faire si le group existe déjà
        groupadd -f "$group"
        # le > /dev/null 2>&1 sert à redirigé le message d'erreur "le répertoire personnel /home existe déjà." (il se produit car l'utilisateur auras définit /home comme home pour l'utilisateur)
        useradd -m -k "$repskel" -d "$rephome" -g "$group" "$user" > /dev/null 2>&1
        if [ $? = 0 ]; then
            echo "====== L'utilisateur $user à bien était créé dans le groupe $group ======"
            # mkdir -p pour créer les fichiers Downloads et Documents si ils ne sont pas encore créer
            mkdir -p "$rephome/$user/Downloads" "$rephome/$user/Documents"
            if [ ! -f "$rephome/$user/.bashrc" ]; then
                touch "$rephome/$user/.bashrc"
            fi

            echo -e "alias e='emacs'\nalias w='wireshark'" >> $rephome/$user/.bashrc
            # Rendre les dossiers à l'utilisateur (sinon ils sont à root)
            chown -R "$user:$group" "$rephome/$user"
        else
            echo -e "\033[31m====== L'utilisateur $user n'as pas pu être ajouter (il existe peut-être déjà) ======\033[0m"
        fi
    else
        # \033[31m et \033[0m avec le -e permet de mettre le texte en rouge
        echo -e "\033[31m====== La ligne $i est défaillante ======\033[0m"
    fi
done
