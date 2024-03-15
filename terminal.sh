#! /usr/bin/bash
grub="/etc/default/grub"									# grub config for kernalsettings
instru="/home/lhl/Documents/bash/tools/startup.sh" 			# folder in which instructions afer reboot are stored
mcc=true													# for repeating while loop

while ($mcc); do
	mcc=false
	read terminal_in 										# bash read user input
		
	case $terminal_in in									# switch case 
		ide)												# if userinput is ide do the below
			#tmux send-keys "clear" "Enter"
			tmux splitw -v -p 10 -t 0
			tmux send-keys "htop" "Enter" "P" "Enter"
			tmux splitw -h -p 80 -t 0
			tmux send-keys "nvim" "Enter"
			#selectw -t 0	
		;;													# exit caase
		nvim2)
			tmux send-keys "clear" "Enter"
			tmux send-keys "nvim" "Enter"
			tmux splitw -h
			tmux send-keys "nvim" "Enter"
		;;
		nvimv)
			tmux send-keys "python3 /home/lhl/Documents/bash/python/animation.py" "Enter"
			tmux splitw -h
			tmux send-keys "nvim" "Enter"
		;;
		backup)
			python3 /home/lhl/Documents/bash/tools/backup.py
		;;
		CAD)
			paste='"$(readlink -e /etc/grub2.cfg)"'							# for passing commands ito new script
			echo "$paste"													# debugging
			sudo sed -i '9 s/^#//' $grub									# removes "#" from: GRUB_CMDLINE_LINUX_DEFAULT="nohz_full=3 isolcpus=domain,managed_irq,3"
			sudo grub2-mkconfig -o "$(readlink -e /etc/grub2.cfg)" 			# updates grub
			echo "taskset -c 3 FreeCAD &" >> $instru						# makes so that FreeCAD starts afer reboot
			echo "sudo sed -i '9 s/./#&/' $grub" >> $instru					# out comments line in grub which isolates cpu cores
			echo "sudo grub2-mkconfig -o $paste" >> $instru					# updates grub
			
			echo "this pc is abaut to reboot in one Minute in order for changes to take affect"
			echo "please save al current files"
			sleep 1m # waits one min bevore rebooting
			reboot
		;;
		cc)
			cat /dev/null > ~/.bash_history
		;;
		music)
			# wmctrl -s 4 # apparently not installed
			easyeffects	&
			firefox --new-window https://open.spotify.com/ &
		;;
		git)
			firefox --new-window https://github.com/login &
		;;
		help)
			echo "options terminal.sh:"
			echo "	CAD 		isolates CPU-cores restarts opens CAD"
			echo "	backup 		runs backup.py"
			echo "	cc			delets bash historry"
			echo " 	music 		opens spotify "
			echo ""
			echo "tmux needs to be already open fore those to work:"
			echo "	ide 		terminal, htop, nvim"
			echo "	nvim2 		2×nvim"
			echo "	nvimv 		nvim + nvim ascii animation"	echo "	"
			mcc=true															# sets mcc to true in order to redo while loop
		;;
		*)													# default 
			$terminal_in									# pass the userinput to terminal
		;;													# exit case
	esac													# exit switch case
done
