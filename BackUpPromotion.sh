#!/bin/bash

# ====CONFIGURATION====
# changer *.tar.bz2 en fonction de l'extension que vous voulez 

ROOT="."
ENFANT="$ROOT/Fils"
PERE="$ROOT/Pere"
GRAND_PERE="$ROOT/grand_pere"

mkdir -p "$ENFANT" "$PERE" "$GRAND_PERE"

#enfant -> pere 
echo "[INFO] Déplacement des fichiers du dimanche vers 'pere'" #supprimable (a titre d'info)
for file in "$ENFANT"/*.tar.bz2; do
    if [ -f "$file" ]; then
        FILE_DAY_OF_WEEK=$(date -r "$file" +%u)
            #selection des dimanches 
            if [ "$FILE_DAY_OF_WEEK" -eq 7 ]; then
                cp "file" "$PERE/" #changer cp par mv au besoin 
                echo "[INFO] Déplacement de $file vers $PERE" #supprimable (a titre d'info)
            fi
    fi
done

#INITIALISATION DU FICHIER A SUPPRIMMER PAR LA SUITE 
#c'est un boucle qui va recuperer toutt les 4 fichier pour faire en sorte que ceux ci 
#soient considerer comme un mois 

#supprimable (a titre d'info)
#il regarde seulement tout les fichiers qui sont dans le repertoire pere
#et les trie en fonction des demande
FILES_IN_PERE=$(ls -lt "$PERE"/*.tar.bz2)
for file in $FILES_IN_PERE; do
    echo "$file"
done

count = 0
for file in $FILES_IN_PERE; do
    count=$((count +1))

    if [ $((count % 4)) -eq 0 ]; then
        FILE_PATH=$( echo "$file" | awk '{print $NF}')

        cp "$FILE_PATH" "$GRAND_PARENT/" #changer cp par mv au besoin
        echo "[INFO] Déplacement de $FILE_PATH vers $GRAND_PARENT" #supprimable a titre d'information
    fi
done


# Verification de si demain est un nouveau mois
# Alors le dernier fichier ira de pere -> Grand-pere 
Mois_du_jour=$(date +"%m")

Mois_du_prochain_jour=$(date -d tomorrow +"%m")

if ["$Mois_du_jour" != "$Mois_du_prochain_jour"]; then
    echo "[INFO] Demain est un nouveau mois. Deplacement du dernier fichier du dossier vers grand pere " #supprimable (a titre d'info)

    Dernier_fichier=$(ls -lt "$PERE"/*.tar.bz2 | head -n 1)
    
    LAST_FILE=$(ls -lt "$PERE"/*.tar.bz2 | head -n 1)

    LAST_FILE_PATH=$(echo "$LAST_FILE" | awk '{print $NF}')

    echo "[INFO] Fichier sélectionner pour grand-pere : $LAST_FILE_PATH" #supprimable (a titre d'info)

    mv "$LAST_FILE_PATH" "$GRAND_PERE/" #changer mv par cp au besoin
    echo "|PROMOTION| Le dernier fichier déplacé vers grand-pere : $(basename "$LAST_FILE_PATH")" #supprimable (a titre d'info)
else 
    echo "[INFO] Ce n'est pas un nouveau . Aucun fichier déplacé " #supprimable (a titre d'info)
fi

#Si fichier deja dans un dossier en ce qui concerne le deplacement de pere -> Grand-pere celui ne sera pas effectuer 
#il faut ajouter une autre condition pour le deplacer vers grand-pere



echo "[INFO] Nettoyage des fichiers de plus de 30 jours dans 'enfant'"
find "$ENFANT" -maxdepth 2 -name "*.tar.bz2" -type f -mtime +15 -exec rm -v {} \;
echo "[INFO] Nettoyage des fichiers de plus de 360 jours dans 'pere'"
find "$PERE" -name "*.tar.bz2" -type f -mtime +360 -exec rm -v {} \;
