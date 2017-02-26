
Exemple d'utilisation :

-$ ./admin_linux.sh 


			MENU D'ADMINISTRATION


 1) Créer un compte utilisateur
 2) Modifier un compte
 3) Afficher un compte
 4) Supprimer un compte
 5) Créer plusieurs utlisateurs
 6) Afficher les informations d'un groupe
 7) Créer un nouveau groupe
 8) Modifier les informations d'un groupe
 9) Supprimer un groupe
10) Archiver un répertoire
11) Consulter une archive
12) Extraction d'une archive
13) Compresser une archive
14) Décompression d'une archive
15) Programme annexe
16) Quitter

Faites votre choix : 15

Affichage des fonctions du programme
1) Afficher le nom de toutes les fonctions
2) Consulter une fonction
3) Retour au menu principal
4) Fin du programme
Faites votre choix : 1
Admin
Affiche_groupe
Affiche_user
Archive_rep
Compress_archive
Consulte_archive
Creer_groupe
Creer_user
Decompress_archive
Delete_groupe
Delete_user
Extraction_rep
Modif_groupe
Modif_user
Pause
Prog_annexe
User_list_crea
module
scl
Faites votre choix : 2
1) Admin		 8) Creer_user		15) Pause
2) Affiche_groupe	 9) Decompress_archive	16) Prog_annexe
3) Affiche_user		10) Delete_groupe	17) User_list_crea
4) Archive_rep		11) Delete_user		18) module
5) Compress_archive	12) Extraction_rep	19) scl
6) Consulte_archive	13) Modif_groupe
7) Creer_groupe		14) Modif_user
Fonction à afficher : 15
Pause () 
{ 
    printf "\nAppuyer sur <ENTER> ...\n";
    read x;
    echo
}
Faites votre choix : 
1) Afficher le nom de toutes les fonctions
2) Consulter une fonction
3) Retour au menu principal
4) Fin du programme
Faites votre choix : 3

	Menu principal

Faites votre choix : 
 1) Créer un compte utilisateur
 2) Modifier un compte
 3) Afficher un compte
 4) Supprimer un compte
 5) Créer plusieurs utlisateurs
 6) Afficher les informations d'un groupe
 7) Créer un nouveau groupe
 8) Modifier les informations d'un groupe
 9) Supprimer un groupe
10) Archiver un répertoire
11) Consulter une archive
12) Extraction d'une archive
13) Compresser une archive
14) Décompression d'une archive
15) Programme annexe
16) Quitter
Faites votre choix : 16

	FIN DU PROGRAMME

-$ 



Si vous vous retrouvez dans une "boucle" dont on ne peut pas sortir, notamment dans "Programme annexe", appuyer sur 0 (zero). Seul un fichier "bar" ne sera pas effacé directement.


	
Concernant la fonction User_list_crea()

Le fichier qui sert à la création de plusieurs utilisateurs doit être constitué de 3 colonnes :
USERNAME GROUPNAME SHELL	

Par exemple :
cain	users 	/bin/bash
john	users 	/bin/ksh

Le password de chaque utilisateur est son nom, il apparaît "en clair" dans /etc/shadow pour le moment ... C'est la commande passwd username qui le cryptera.

Si UID "65530 et quelques" n'existe pas dans /etc/passwd 
alors la variable :
BIG_UID=`cat /etc/passwd |cut -d: -f3 |sort -n |tail -2 |sed 'q'`
dans la fonction User_list_crea, 
doit être :
BIG_UID=`cat /etc/passwd |cut -d: -f3 |sort -n |tail -1`

