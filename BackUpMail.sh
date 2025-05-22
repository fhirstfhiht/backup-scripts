#!/bin/bash

#Aller dans le repertoire de sauvegarde
cd /home/UnDossier/backup

FINALFILE=UnFichier_$(date +%d-%m-%Y).sql.tar.bz2
SQLFILE=UnFichier.sql
SCPUSER=UnNom
SCPHOST=UnServeur
TEST_DB="Fichier_test"
SCPDIR=/home/UnDossier

#1. Générer le dump si nécessaire 
mysqldump -h 127.0.0.1 -uroot -p'VotreMotDePasse' > "$SQLFILE"

#Verifier si la commande mysqldump a reussi 
if [ $? -ne 0 ]; then
    echo "Erreur lors de la generation du dump de la BD"
    python3 envoi_mail.py "ALERTE: Erreur de dump" "Le dump de la base de données a échoué. Verifier les logs."
    exit 1
fi 

#2. Vérifier le dump en important dans une base de test 
TEST_DB="bd_test"

#Créer la base de donnée de test 
mysql -h 127.0.0.1 -uroot -p'VotreMotDePasse' --port 3307 -e "DROP DATABASE IF EXISTS $TEST_DB; CREATE DATABASE $TEST_DB;"

if mysql -h 127.0.0.1 -uroot -p'VotreMotDePasse' --port 3307 $TEST_DB < "$SQLFILE" ; then
    echo "importation du dump réussi."

    #compresser le dump en tar.bz2
    tar jcf "$FINALFILE" "$SQLFILE"
    chown $SCPUSER:$SCPUSER "$FINALFILE"
    rm "SQLFILE" #supprimer le fichier sql aprés compression

    #nettoyer la base de donnée test 
    mysql -h 127.0.0.1 -uroot -p'VotreMotDePasse' --port 3307 -e "DROP DATABASE IF EXISTS $TEST_DB;"

    #3. Appelle du script python 
    python3 envoie_mail.py "Sauvegarde OK" "le dump a été généré, vérifier et comprésser avec succés."

    scp -i /home/dossier/.ssh/id_rsa "$FINALFILE" "$SCPUSER@$SCPHOST:$SCPDIR"

    echo "Sauvegarde et transfert réussi."

else
    