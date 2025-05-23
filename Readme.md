# README - Sauvegarde Automatisée et Envoi de Mail

## Table des matières
- [Présentation](#présentation)  
- [Prérequis](#prérequis)  
- [Description des scripts](#description-des-scripts)  
  - [BackUpPromotion.sh](#backuppromotionsh)  
  - [BackUpMail.sh](#backupmailsh)  
  - [EnvoieMail.py](#envoicemailpy)  
- [Installation et configuration](#installation-et-configuration)  
- [Automatisation avec cron](#automatisation-avec-cron)  
- [Organisation des sauvegardes](#organisation-des-sauvegardes)  
- [Notes importantes](#notes-importantes)  

---

## Présentation

Ce projet contient plusieurs scripts principalement conçus pour être exécutés sur des machines Linux. Ils permettent d’automatiser la sauvegarde de bases de données, organiser ces sauvegardes selon une stratégie de rotation "Fils/Père/Grand-Père", et envoyer des notifications par mail en cas d’erreur dans la base de donnée.
Tout les fichiers present dans les dossier sont des fichier vide et permettent de faire les test.
En ce qui concerne le fichier BackUpMail il est a tester avec vos propre parametre de votre base de donnée.

---

## Prérequis

- Système Linux (tests uniquement réalisés sous Linux).  
- Python installé (version compatible avec les scripts).  
- Serveur mail opérationnel (pour l’envoi des mails via `EnvoieMail.py`).  
- Droits d’exécution sur les scripts shell.  

---

## Description des scripts

### BackUpPromotion.sh

- Script shell qui organise la sauvegarde des données dans une arborescence en fonction du temps :  
  - **Fils** : sauvegardes hebdomadaires  
  - **Père** : sauvegardes mensuelles  
  - **Grand-Père** : sauvegardes annuelles  
- S’appuie sur `crontab` pour être exécuté automatiquement (une fois par semaine).  
- Déplace les fichiers de sauvegarde selon la règle suivante :  
  - Chaque jour, un fichier `.sql.tar.bz2` est généré (sauvegarde base de données).  
  - Si c’est un dimanche, le fichier est déplacé vers le dossier **Père**.  
  - Si demain est le début d’un nouveau mois, le fichier le plus récent du dossier **Père** est déplacé vers **Grand-Père**.  

---

### BackUpMail.sh

- Script shell qui :  
  - Effectue la sauvegarde de la base de données à un instant T.  
  - Vérifie la validité de la sauvegarde en tentant un redéploiement.  
  - En cas d’erreur lors du redéploiement, envoie un mail avec les détails de l’erreur.  
  - Si tout est correct, ne fait rien (optionnel : possibilité d’envoyer un mail de confirmation).  
- Est déclenché automatiquement tous les jours via `crontab`.  
- Lance le script Python `EnvoieMail.py` pour la gestion des mails.  

---

### EnvoieMail.py

- Script Python utilisé pour envoyer des mails.  
- Remplace les outils classiques Linux (postfix, mailutils) afin de simplifier la gestion des erreurs et des logs.  
- Paramètres à configurer :  
  - Adresse mail expéditeur  
  - Mot de passe  
  - Port et serveur SMTP  
  - Contenu du corps du mail (modifiable dans le script).  
- Est appelé par `BackUpMail.sh`.  

---

## Installation et configuration

1. Donner les droits d’exécution aux scripts :  
   ```bash
   chmod +x BackUpPromotion.sh BackUpMail.sh

2. Modifier les paramètres SMTP dans EnvoieMail.py selon votre configuration mail.

3. Vérifier que les chemins et dossiers des sauvegardes sont correctement configurés dans les scripts.

4. Ajouter les tâches dans la crontab (exemple) :
    # Exécuter BackUpMail.sh tous les jours à 2h du matin
    0 2 * * * /chemin/vers/BackUpMail.sh

    # Exécuter BackUpPromotion.sh tous les dimanches à 3h du matin
    0 3 * * 0 /chemin/vers/BackUpPromotion.sh
