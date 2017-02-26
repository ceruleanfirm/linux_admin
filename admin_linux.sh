#!/bin/bash
# admin_linux.sh
# Menu administration

#set -o xtrace

PSWD="/etc/passwd"
GRP="/etc/group"

# Déclaration des fonctions

# Fonction qui crée un compte utilisateur

Creer_user() {
	while ((1)) ; do
		echo -e "\n\tCRÉATION D'UN NOUVEAU COMPTE\n"
		read -p "Nom de l'utilisateur : " user
	# vérif si le compte existe déjà 
		grep -q "^$user:" $PSWD 
		if [ $? != 0 ] ; then		
			while(true) ; do
				printf "\nN° UID : "  # création de l'uid
				read uid
				expr ":$uid:" : ':[0-9]\{3,5\}:' >/dev/null
				if [ $? != 0 ] ; then
					printf "Numéro UID incorrect"
				else
				# vérif	que l'UID n'existe pas déjà dans /etc/passwd
					grep "^.*:x:$uid:" $PSWD >/dev/null
					[ $? = 0 ] && echo -e "$uid existe déjà dans $PSWD\nSaisissez un autre numéro" || break
				fi
			done

			while ((1)) ; do
				printf "\nN° GID : "
				read gid
				expr ":$gid:" : ':[0-9]\{3,5\}:$' >/dev/null
				if [ $? != 0 ] ; then
					print "Numéro GID incorrect"
				else
				# vérif si le GID n'existe pas déjà dans /etc/group
				# sinon on le crée
					grep -q "^.*:x:$gid:$" $GRP
					if [[ $? != 0 ]] ; then
						printf "$gid n'existe pas dans $GRP"
					# appel de la fonction Creer_groupe
						Creer_groupe
					fi
					break
				fi
			done
			
		# nom du répertoire de connexion
			rep="/home/$user"
		# choix du shell 
			while : ; do
					echo -e "\nShells disponibles sur `hostname` : "
					PS3="Faites votre choix : "
					select shl in `sed -e '/^#/d' -e '/^$/d' /etc/shells`
					do
						break	
					done

					echo $shl
				#printf "\nNom du shell parmi les suivants : " 
				#cat /etc/shells
				#read -p "Votre choix : " shl
				grep -q "^$shl$" /etc/shells && break
				echo "Shell inexistant sur ce system" 
			done
			printf "\nMot de passe $user : "
			read mdp
		# Création du nouvel utlisateur
		 # su -l root -s /bin/bash -c "cmd"   lance un shell root, donc charge (à nouveau, si on est déjà root) son .bash_profile
			[[ $UID != 0 ]] && echo "Got root ?"
			su -l root -s /bin/bash -c "\
			useradd -u $uid -g $gid -d $rep -m -s $shl -p $mdp $user"
			[ $? = 0 ] && echo -e "$user est maintenant dans le system\n" || echo "\nÉchec création $user\n"
			break
		else  
			echo -e "$user existe déjà\n"
			return 1
		fi
	done
}

# Appel de la fonction
# Creer_user

# fonction de modif des infos d'un compte

Modif_user() {
	while true ; do
		echo -e "\n\tMODIFICATION D'UN COMPTE\n"
		read -p "Nom de l'utilisateur : " user
		grep -i "^$user:" $PSWD >/dev/null
		if [[ $? != 0 ]] ; then
			printf "\n$user n'est pas dans le system ...\n" && return 1
		else
			lig=`grep -i "^$user:" $PSWD`
			IFS=:
			set -- $lig
			printf "\nChamps à modifier : \
			\n\t1) Nom de connexion : $1 \
			\n\t2) N° UID : $3 \
			\n\t3) N° GID : $4 \
			\n\t4) Shell de connexion : $7 \
			\n\t5) Répertoire de connexion : $6 \
			\n\t6) Commentaires : $5 \
			\n\t0) Retour au menu principal\n\n"
			echo "Faites votre choix : "
			read chx
			while [[ "$chx" < 0 || "$chx" > 6 ]]
			do
				printf "Choix : "
				read chx
			done
			case $chx in
				1) 
					read -p "Nouveau nom : " new_name
					usermod -l $new_name $user -m -d /home/$new_name >/dev/null  # --login 	   -d /home/new_name  creer 	 -m  move contenu
					if [[ $? == 0 ]] ; then
						# mv /home/$user /home/$new_name # remplacé par -d et -m de usermod
						echo -e "\nModifications enregistrées\nLe nouveau login de \"$user\" est \"$new_name\""
						echo -e "Son répertoire de connexion est transféré sous \"/home/$new_name\"\n"
						return 0
					else
						echo "Echec modification"
						return 1
					fi
				   ;;
				 2) 
				 	printf "\nNouveau n° UID  : "
					read uid
					usermod -u $uid $user >/dev/null  # --uid
					if [[ $? == 0 ]] ; then
						printf "\nModification UID enregistrée\n"
					else
						printf "\nEchec modification\n"
					fi
				    
				    ;;
				 3)
				 	printf "\nNouveau n° GID : "
					read gid
					usermod -g $gid $user >/dev/null  # --gid
					if (( $? == 0 )) ; then
						printf "\nModification GID enregistrée\n"
						break
					else
						printf "\nEchec modification\n"
					fi
				    
				    ;;
				 4) 
				 	echo -e "\nShells disponibles sur `hostname` :"
					cat /etc/shells
					read -p "Votre choix : " shl
					#while : ; do
					#echo -e "\nShells disponibles : "
					#PS3="Faites votre choix : "
					#select shl in `sed -e '/^#/d' -e '/^$/d' /etc/shells`
					#do
					#	break	
					#done
					#echo $shl
					grep -q "^$shl$" /etc/shells || \
					echo "Shell inexistant sur ce system" 
					usermod -s $shl $user >/dev/null  # --shell	
					if (( $? == 0 )) ; then
						printf "\nModification shell de connexion enregistrée\n"
						break
					else
						printf "\nEchec modification\n"
					fi
				    ;;
				 5) 
				 	printf "\nNouveau répertoire de connexion : \n"
					read rep
					usermod -d $rep $user >/dev/null  # --home # -m --move-home effectué au chgt de login	
					if [[ $? == 0 ]] ; then
						printf "\nModification enregistrée\n"
					else
						printf "\nEchec modification\n"
					fi
				    
				    ;;
				6) 
					read -p "Commentaire : " comm
					usermod -c $comm $user 2>/dev/null  # --comment # Nom de login au gdm
				    ;;
				0)
					break ;;
			esac
		fi 
	done 
}

# Modif_user

# fonction qui affiche infos sur un compte

Affiche_user() {
	echo -e "\n\tINFORMATIONS DU COMPTE\n"
	read -p "Nom de l'utilisateur : " user
	grep -i "^$user:" $PSWD >/dev/null
	if [ $? != 0 ] ; then
		printf "\n$user n'est pas dans $PSWD\n\n"
	else
		lig=`grep -i "^$user:" $PSWD`
		IFS=":"
		set -- $lig
		printf "Nom de connexion : $1\n"
		printf "N° UID : $3\n"
		printf "N° GID : $4\n"
		printf "Shell de connexion : $7\n"
		printf "Répertoire de connexion : $6\n"
		printf "Commentaire : $5" 
			[[ $5 == "" ]] && echo -e "Aucun"
	fi
echo
}

# Affiche_user

# fonction supprime un compte

Delete_user() {
	while ((1)) ; do
		echo -e "\n\tSUPPRESSION DU COMPTE\n"
		read -p "Nom de l'utilisateur à supprimer : " user
		grep "^$user:" $PSWD >/dev/null
		if [ $? != 0 ] ; then 
			printf "$user n'est pas dans le system\n\n" && return 1
		else
			# userdel -r  # suppression du compte, du rep de connexion et de tous les fichiers dans ce rép
			userdel --remove $user >/dev/null 2>&1
			if [[ $? == 0 ]] ; then
				printf "\nCompte et répertoire de connexion de $user SUPPRIMÉS\n\n"
			else
				printf "\nÉchec suppression\n" 
			fi
			break
		fi
	done
}

# Delete_user

# fonction qui crée comptes users dans une liste

User_list_crea() {
	BIG_UID=`cat /etc/passwd |cut -d: -f3 |sort -n |tail -2 |sed 'q'`
	# on prend le + gros UID (sauf 65530 et qq) ds /etc/passwd et on incrémente à chaque création, pas d'erreur possible 
# si UID "65530 et quelques" n'existe pas ==> tail -1 dans la commande précédente
	((NEW_UID=BIG_UID+1)) 2>/dev/null
# echo $BIG_UID $NEW_UID
	read -p "Fichier contenant les noms de comptes à créer : " fic
	
	# vérif si le fichier existe et s'il n'est pas vide
	if [[ ! -f $fic ]] ; then
		echo "Fichier inexistant"
	elif [[ ! -s $fic ]] ; then   
		echo "$fic est vide !!!"
	else
		while read logn groupe shl
		do
			useradd -u $NEW_UID -g $groupe -d /home/$logn -m -s $shl -p $logn $logn
			if [ $? = 0 ] ; then
				printf "\n$logn vient d'être créé ... \nUID : $NEW_UID\nGID : `id -g $logn`\n\n" 
				((NEW_UID++))
			else
				printf "\nLa création du compte \"$logn\" a échoué\n\n"
			fi
		done <$fic
	fi
}

#User_list_crea

# fonction qui crée un groupe

Creer_groupe() {
	echo -e "\n\tCRÉATION DU GROUPE\n"
	while true
	do
		read -p "Nom du nouveau groupe : " groupe 
		grep -q "^$groupe:" $GRP 
		if [[ $? != 0 ]] ; then
			while((1)) ; do
				read -p "Numéro GID : " gid
				expr ":$gid:" : ':[0-9]\{2,5\}:' >/dev/null 2>&1
				if (( $? != 0 )) ; then
					printf "\nSaisie non valide\n"
				else
					# vérif si le groupe existe déjà
					grep -q ":$gid:$" $GRP
					if [ $? = 0 ] ; then
						echo -e "Le groupe $gid existe déjà\n" && continue
					else
						echo $groupe
						[[ $UID != 0 ]] && echo "Got root ?"
						su -l root -s /bin/bash -c \
						"groupadd -g $gid $groupe >/dev/null"
						[ $? = 0 ] && printf "\nLe groupe $groupe est enregistré\n" && return 0
						printf "\nÉchec création du groupe $groupe\n"
					fi
				fi
			done
		else
			printf "\nLe nom de groupe $groupe existe déjà\n"
		fi
	done
}

#Creer_groupe
		
# Modif_groupe

Modif_groupe() {
	echo -e "\n\tMODIFICATION D'UN GROUPE\n"
	unset groupe
	while true 
	do
		read -p "Nom du groupe : " groupe
		lig=`grep -q "^$groupe:" $GRP`
		if [ $? = 0 ] ; then
			IFS=:
			set -- $lig
			while ((1)) ; do
				echo -e "\nChamp à modifier :\
				\n\t1) Nom du groupe : $1 \
				\n\t2) GID : $3 \
				\n\t0) Quitter\n"
				read -p "Faites votre choix : " chx
				case $chx in
					1)	printf "\tModification du nom de groupe\n"
						read -p "Nouveau nom de groupe : " newname
						# expr ":$new_name:" : ':[0-9][0-9]*:' > /dev/null # ER délimitée par 2 points et ça fonctionne
						if [[ $newname != +([0-9]) ]] ; then  # si ce n'est pas que des chiffres
						# groupmod old_name -n (--new-name) new_name  
							groupmod $groupe -n $newname 
							[ $? = 0 ] && printf "\n$newname a pour GID $3\nModification enregitrée\n" && sleep 1 && return 0
							printf "\nÉchec modification\n"
						else 
							printf "\nNom invalide\n"
							continue
						fi 
						;;
						
					2)	printf "\tModification du GID\n"
						read -p "Nouveau GID du groupe $groupe : " gid
						expr ":$gid:" : ':[0-9]\{3,5\}:' >/dev/null 2>&1 # 0 à 9, 3 à 5 chiffres # CONDITION PAS PRISE COMPTE si tu n'encadres pas les expressions avec les : (2 points)
						if [ $? = 0 ] ; then
						# if [[ $gid -gt 500 && $gid -le 65535 ]] ; then # groupmod ... # fonctionne aussi ...
						# case $gid in 
						# [5-9][0-9][0-9]|[1-9][0-9][0-9][0-9]|[1-9][0-9][0-9][0-9][0-9]) # fonctionne aussi ...
							groupmod $groupe -g $gid 
							[ $? = 0 ] && printf "\nModification enregistrée\n" && sleep 1 && return 0
							printf "\nÉchec modification\n"
							continue # ;;							
						# *)
						else
							printf "\nNuméro GID non valide\n" 
							continue 
						# esac
						fi 
						;;

					*)	echo -e "Retour au menu principal\n" && return 80
						;;
				esac
			done
		else
			printf "Le groupe $groupe n'est pas dans ce system\n"
			return 11
		fi
	done
}

# Modif_groupe

# fonction qui affiche les infos d'un groupe

Affiche_groupe() {
	echo -e "\n\tCONSULTATION DES INFOS D'UN GROUPE\n"
	while true
	do
		read -p "Nom du groupe (0 pour sortir) : " groupe
		[[ $groupe == "q" || $groupe == "0" || -z $groupe ]] && printf "Retour au menu prinicipal\n" && return 60
		lig=`grep -i "^$groupe:" $GRP` >/dev/null 2>&1
		if [ $? = 0 ] ; then
			IFS=:
			set -- $lig
			printf "\nGID : $3\nMembre(s):\n"
			grep ":x:[0-9]*:$3:" $PSWD > membres
			awk -F: '{print NR"\t"$1}' membres
			echo
			rm membres			
		else
			printf "\n$groupe n'est pas sur le system\n" 
			read -p "Retour au menu principal ? [N/o] : " rep
			case $rep in		
				n*|N*) continue ;;
			esac
		fi
	done
}

# Affiche_groupe			  

# fonction qui supprime un groupe

Delete_groupe() {
	while true
	do
		printf "\n\tSUPPRESSION D'UN GROUPE\n\n"
		read -p "Nom du groupe : " groupe
		grep "^$groupe:" $GRP > /dev/null 2>&1
		if [ $? = 0 ] ; then
			groupdel $groupe
			[ $? = 0 ] && printf "\nLe groupe $groupe vient d'être supprimé\n" || printf "\nÉchec suppression\n"
			break
		else
			printf "\n$groupe n'est pas dans $GRP\n"
			break
		fi
	done
}

# Delete_groupe



			### SAUVEGARDE ET ARCHIVAGE ###


# fonction archive un répertoire

# --create
# --verbose
# -f, --file=ARCHIVE         Utiliser le fichier ou le périphérique ARCHIVE

Archive_rep() {
	echo -e "\n\tSauvegarde de répertoire"
	while true
	do
		printf "\nNom du répertoire : "
		read rep
		if [ ! -d $rep ] ; then
			echo "$rep n'existe pas"
		else
			archive=`basename $rep`
			cd $rep
			tar -cf $archive.tar . 
			[ $? = 0 ] && echo -e "Création archive ${rep}.tar ...\n... OK\n" \
			&& mv ${archive}.tar .. && break
			echo -e "Échec création archive\n"
		fi
	done
}

# Archive_rep

# fonction qui affiche une archive

# -t, --list                 Afficher le contenu de l'archive

Consulte_archive() {
	echo -e "\n\tConsultation d'une archive"
	while true
	do
		printf "\nNom de l'archive : "
		read archive
		if [ ! -f $archive ] ; then
			printf "\n$archive est introuvable\n"
		else
			tar -tvf $archive |less
			break
		fi
	done
}

# Consulte_archive

# fonction extraction d'une archive

Extraction_rep() {
	echo -e "\n\tExtraction d'une archive"
	while true
	do
		printf "\nNom de l'archive : "
		read archive
		[[ $archive == "q" ]] && break
		if [ ! -f $archive ] ; then
			printf "\n$archive est introuvable\n"
		else
			printf "\nRépertoire de restauration : "
			read rest
			[ ! -d $rest ] && mkdir $rest
			cd $rest
			printf "\nExtraction de $archive dans $rest ...\n"
			tar -xvf $archive > /dev/null 2>&1
			[[ $? == 0 ]] && printf "... OK\n\n" && break
			printf "Erreur !!!\n" && continue	
		fi
	done
}

# Extraction_rep	

# fonction compress archive avec gzip

Compress_archive() {
	while true 
	do
		printf "\nNom de l'archive à compresser : "
		read archive 
		[[ $archive == "q" || -z $archive ]] && echo -e "\nRetour au menu principal\n" && return 0
		if [ ! -f "$archive" ] ; then
			[[ -d $archive ]] && echo -e "\nImpossible $archive est un dossier" && continue
			printf "\n$archive est introuvable\n"
		else
			printf "\nCompression de $archive ...\n"
			gzip $archive
			[ $? = 0 ] && echo -e "... OK\n" && break
			echo -e "...Erreur\n"
		fi
	done
}

# Compress_archive

# fonction decompression d'archive

Decompress_archive() {
	while true
	do
		printf "\nArchive à décompresser : "
		read archive
		[[ -z $archive || $archive == "q" ]] && echo -e "\nRetour au menu principal\n" && break
		if [ ! -f $archive ] ; then
			printf "\n$archive est introuvable\n"
		else
			printf "\n Décompression de $archive ...\n"
			gunzip $archive 2>/dev/null
			[ $? = 0 ] && echo -e "... OK\n" && break
			sleep 1 && echo -e "... Erreur\n"
		fi
	done
}

# Decompress_archive

# fonction d'affichage des fonctions

Prog_annexe() {
	printf "\nAffichage des fonctions du programme\n"
	PS3="Faites votre choix : "

	select item in \
		"Afficher le nom de toutes les fonctions" \
		"Consulter une fonction" \
		"Retour au menu principal" "Fin du programme"
	do
		case "$REPLY" in
			1) declare -F > bar 
			awk '{print $3}' bar ;;
			2) PS3="Fonction à afficher : " 
			   select fun in `awk '{print $3}' bar`
			   do
				   declare -f $fun
				   PS3="Faites votre choix : "
				   break
			   done ;;
			#read -p "Nom de la fonction à consulter : " nom
			#	 declare -f $nom || echo "Vérifiez le nom de la fonction" ;;
			0|3) printf "\n\tMenu principal\n\n" && return 0 ;;
			4|*) printf "\n\tPROGRAMME TERMINÉ\n\n" && exit 150
		esac
	done
	rm bar
}

function Pause {
	printf "\nAppuyer sur <ENTER> ...\n"
	read x
	echo
}


Admin()
{
	clear
	echo -e "\n\t\t\tMENU D'ADMINISTRATION\n\n"

	PS3=`echo -e "\nFaites votre choix : \n"`
	
	select chx in \
		"Créer un compte utilisateur" \
		"Modifier un compte" \
		"Afficher un compte" \
		"Supprimer un compte" \
		"Créer plusieurs utlisateurs" \
		"Afficher les informations d'un groupe" \
		"Créer un nouveau groupe" \
		"Modifier les informations d'un groupe" \
		"Supprimer un groupe" \
		"Archiver un répertoire" \
		"Consulter une archive" \
		"Extraction d'une archive" \
		"Compresser une archive" \
		"Décompression d'une archive" \
		"Programme annexe" \
		"Quitter"
	do
		case $REPLY in
			1) Creer_user ;;
			2) Modif_user ;;
			3) Affiche_user ;;
			4) Delete_user ;;
			5) User_list_crea ;;
			6) Affiche_groupe ;;
			7) Creer_groupe ;;
			8) Modif_groupe ;;
			9) Delete_groupe ;;
			10) Archive_rep ;;
			11) Consulte_archive ;;
			12) Extraction_rep ;;
			13) Compress_archive ;;
			14) Decompress_archive ;;
			15) Prog_annexe ;;
			0|16) printf "\n\tFIN DU PROGRAMME\n\n"
				return 0 ;;
		esac
	done
}

Admin
exit 0

# Écrit par cerulean  <ceruleanfirm@gmail.com>  0x71F86DC1B12845E9
# Jan. 2016
# Free For All

