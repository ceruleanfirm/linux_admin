
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
connor	users 	/bin/bash
john	users 	/bin/ksh

Le password de chaque utilisateur est son nom, il apparaît "en clair" dans /etc/shadow pour le moment ... C'est la commande passwd username qui le cryptera.

Si UID "65530 et quelques" n'existe pas dans /etc/passwd 
alors la variable :
BIG_UID=`cat /etc/passwd |cut -d: -f3 |sort -n |tail -2 |sed 'q'`
dans la fonction User_list_crea, 
doit être :
BIG_UID=`cat /etc/passwd |cut -d: -f3 |sort -n |tail -1`









##
appendfstab.sh
##

root@saturn:/home/blue/GIT/linux_admin-# ./appendfstab.sh

Partitions Table on saturn :

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb      8:16   0 465,8G  0 disk 
├─sdb4   8:20   0     1K  0 part 
├─sdb2   8:18   0  11,7G  0 part [SWAP]
├─sdb5   8:21   0 196,4G  0 part /data2
├─sdb3   8:19   0  34,4G  0 part 
├─sdb1   8:17   0  34,5G  0 part /home
└─sdb6   8:22   0 188,7G  0 part /backup
sr0     11:0    1  1024M  0 rom  
sdc      8:32   1     2G  0 disk 
└─sdc1   8:33   1     2G  0 part /data
sda      8:0    0  59,6G  0 disk 
├─sda2   8:2    0   5,1G  0 part [SWAP]
├─sda5   8:5    0  25,5G  0 part /altcoin
├─sda3   8:3    0     1K  0 part 
├─sda1   8:1    0    26G  0 part /
└─sda6   8:6    0   3,1G  0 part 

Partition Name (sdXn) : cbr900
cbr900 not a partition ...
Partition Name (sdXn) : hda3
hda3 not found
root@saturn:/home/blue/GIT/linux_admin-# ./appendfstab.sh

Partitions Table on saturn :

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb      8:16   0 465,8G  0 disk 
├─sdb4   8:20   0     1K  0 part 
├─sdb2   8:18   0  11,7G  0 part [SWAP]
├─sdb5   8:21   0 196,4G  0 part /data2
├─sdb3   8:19   0  34,4G  0 part 
├─sdb1   8:17   0  34,5G  0 part /home
└─sdb6   8:22   0 188,7G  0 part /backup
sr0     11:0    1  1024M  0 rom  
sdc      8:32   1     2G  0 disk 
└─sdc1   8:33   1     2G  0 part /data
sda      8:0    0  59,6G  0 disk 
├─sda2   8:2    0   5,1G  0 part [SWAP]
├─sda5   8:5    0  25,5G  0 part /altcoin
├─sda3   8:3    0     1K  0 part 
├─sda1   8:1    0    26G  0 part /
└─sda6   8:6    0   3,1G  0 part 

Partition Name (sdXn) : sdb3
MountPoint : /
/ is already a MOUNTPOINT in /etc/fstab
Abandon
root@saturn:/home/blue/GIT/linux_admin-# ./appendfstab.sh

Partitions Table on saturn :

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb      8:16   0 465,8G  0 disk 
├─sdb4   8:20   0     1K  0 part 
├─sdb2   8:18   0  11,7G  0 part [SWAP]
├─sdb5   8:21   0 196,4G  0 part /data2
├─sdb3   8:19   0  34,4G  0 part 
├─sdb1   8:17   0  34,5G  0 part /home
└─sdb6   8:22   0 188,7G  0 part /backup
sr0     11:0    1  1024M  0 rom  
sdc      8:32   1     2G  0 disk 
└─sdc1   8:33   1     2G  0 part /data
sda      8:0    0  59,6G  0 disk 
├─sda2   8:2    0   5,1G  0 part [SWAP]
├─sda5   8:5    0  25,5G  0 part /altcoin
├─sda3   8:3    0     1K  0 part 
├─sda1   8:1    0    26G  0 part /
└─sda6   8:6    0   3,1G  0 part 

Partition Name (sdXn) : sda5
MountPoint : /altcoin

#
# /etc/fstab
# Created by anaconda on Fri Feb 12 00:26:45 2016
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#

# sda1
UUID=266ea493-66db-4e96-81fd-5119eb038512 /             ext4    defaults        1 1
# sdb1
UUID=72d0e6a2-8f36-45a4-88a2-1f9bd0ec9d0b /home         ext4    defaults        1 2
# sda2
UUID=11d01534-6661-40fc-8b9c-c9137943fa21 none		swap	sw,pri=1	0 0
# sdb2
UUID=1c6cd2b9-9bad-42df-809b-cfc144147c89 none 		swap	sw,pri=0	0 0
# sdb5
UUID=4c13fdfd-453d-454f-96e6-dc3f739eba2f /data2	ext4	defaults	1 2
# sdb6
UUID=a3d08a89-f9a0-4ea2-b01e-d3192ad76fe5 /backup	ext4	defaults	1 2
# sda5
UUID=87793090-366d-437f-b95c-c012a6206f71 /altcoin ext4 defaults 1 2

File is correct (N/y) ? : y
Overwrite /etc/fstab (N/y) ? : n
Abandon
root@saturn:/home/blue/GIT/linux_admin-# ./appendfstab.sh

Partitions Table on saturn :

NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdb      8:16   0 465,8G  0 disk 
├─sdb4   8:20   0     1K  0 part 
├─sdb2   8:18   0  11,7G  0 part [SWAP]
├─sdb5   8:21   0 196,4G  0 part /data2
├─sdb3   8:19   0  34,4G  0 part 
├─sdb1   8:17   0  34,5G  0 part /home
└─sdb6   8:22   0 188,7G  0 part /backup
sr0     11:0    1  1024M  0 rom  
sdc      8:32   1     2G  0 disk 
└─sdc1   8:33   1     2G  0 part /data
sda      8:0    0  59,6G  0 disk 
├─sda2   8:2    0   5,1G  0 part [SWAP]
├─sda5   8:5    0  25,5G  0 part /altcoin
├─sda3   8:3    0     1K  0 part 
├─sda1   8:1    0    26G  0 part /
└─sda6   8:6    0   3,1G  0 part 

Partition Name (sdXn) : sda5
MountPoint : /altcoin

#
# /etc/fstab
# Created by anaconda on Fri Feb 12 00:26:45 2016
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#

# sda1
UUID=266ea493-66db-4e96-81fd-5119eb038512 /             ext4    defaults        1 1
# sdb1
UUID=72d0e6a2-8f36-45a4-88a2-1f9bd0ec9d0b /home         ext4    defaults        1 2
# sda2
UUID=11d01534-6661-40fc-8b9c-c9137943fa21 none		swap	sw,pri=1	0 0
# sdb2
UUID=1c6cd2b9-9bad-42df-809b-cfc144147c89 none 		swap	sw,pri=0	0 0
# sdb5
UUID=4c13fdfd-453d-454f-96e6-dc3f739eba2f /data2	ext4	defaults	1 2
# sdb6
UUID=a3d08a89-f9a0-4ea2-b01e-d3192ad76fe5 /backup	ext4	defaults	1 2
# sda5
UUID=87793090-366d-437f-b95c-c012a6206f71 /altcoin ext4 defaults 1 2

File is correct (N/y) ? : y
Overwrite /etc/fstab (N/y) ? : y
root@saturn:/home/blue/GIT/linux_admin-# 


