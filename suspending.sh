#!/bin/bash

menu () {
select Action in "Exit" "choose a project"
do
	case $REPLY in
		2)
		       	Project
			;;
		*)
			confirm exit && exit
			;;
	esac
done
}

Project () {
	echo "Select a Project:"
	select OPTION in  "Exit" "test1" "eGlueWeb" "Gafoorji"
	do
		case $REPLY in
			2)
				PROJECT=test1_token
				break
				;;
			3)
				PROJECT=egluweb_token
				break
				;;
			4)
				PROJECT=Gafoorji_token
				break
				;;	
			*)
				confirm exit && exit
				;;
		esac
	done
	export HCLOUD_TOKEN=${PROJECT}
	[[ $HCLOUD_TOKEN ]] && Server
	
}	
	
Server () {
	echo "Select a Server:"
	SERVER_LIST=$(hcloud server list -o columns=name | tail +2)
	select OPTION in "Back" "Exit" $SERVER_LIST 
	do

		case $OPTION in
			Back)
				return
				;;
			Exit)
				confirm exit && exit
				;;
			"")
				echo "Invalid selection!"
				;;
			*)
				chooseAction $OPTION 
				;;
		esac
	done
}



confirm () {
	read -n 1 -p "Are you sure to $* [y/Y]: " yesno
	echo
	if [[ $yesno == "y" ]] || [[ $yesno == "Y" ]] 
		then true
	else
		false
	fi
}

chooseAction () {
	echo
	echo "Selected server is $1. Choose an action:"
        select OPTION in "Exit" "Block all traffic"
        do
          case $REPLY in
        
	          2) 
	                  confirm block all traffic? || continue
				echo "Blocking all traffic for the server $1"
			      hcloud firewall apply-to-resource --type server --server $1 Block-all-traffic
				;;

                  *) 
                  confirm exit && exit
				;;
				esac
	done
}	
menu
