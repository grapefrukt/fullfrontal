# making sure we're in the correct dir
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"; cd ${DIR}

assets=../assets/
bin=../bin/windows/cpp/bin/
dropbox=/c/files/dropbox/fullfrontal/

upload=false
download=false

if [[ ''$1'' == ''up'' ]]; then
	upload=true
elif [[ ''$1'' == ''down'' ]]; then
	download=true
else
	upload=true
	download=false
fi

# arguments are $1: direction, $2: path (no trailing slash), $3: pattern, $4 (optional) : silence warning about file counts
syncDir(){

	if [[ $1 == "up" ]]; then
		source=${bin}$2/$3
		target=${dropbox}$2/
	else
		source=${dropbox}$2/$3
		target=${assets}$2/
	fi

	# creates target directory if it does not exist
	test -d ${target} || mkdir -p ${target}

	# check if the source path matches any files
	if ls ${source} 1> /dev/null 2>&1; then
		# if it does, copy
		cp -u -v ${source} ${target} 2>&1 | grep -v 'omitting directory'
	else
		# if not, warning message
		echo -e "\033[31m$2 has no files to copy\033[0m"
	fi

	# counts the files in source directory
	sourceCount=(${source})
	sourceCount=${#sourceCount[@]}
	# counts the files in target directory
	targetCount=(${target}/$3)
	targetCount=${#targetCount[@]}

	# warns if the counts don't match (and the flag to silence this warning has not been set)
	if  [[ $sourceCount -ne $targetCount ]] && [[ $4 != "true" ]] ; then
		echo -e "\033[31mFile counts do not match in $2, source : $sourceCount, target: $targetCount\033[0m"
	fi
}

if [ ''$download'' = true ] ; then
	echo -e "\033[36mDownloading from Dropbox...\033[0m"
	syncDir "down"	"sounds"	"*.wav"
	syncDir "down"	"music"		"*"
	syncDir "down"	"config"	"sounds.cfg"
fi

if [ ''$upload'' = true ] ; then
	
	if test `find "${bin}manifest" -mmin +20`
	then
		echo -e "\033[31mBinary is more than 20 minutes old, rebuilding game.\033[0m"
		read -t 2 -p "Press Enter (or wait) to continue..."; 
		echo ""
		cd ..
		haxelib run openfl build cpp
		cd scripts
	else
		echo -e "\033[32mBinary is up to date.\033[0m"
	fi

	echo -e "\033[36mUploading to Dropbox...\033[0m"
	# generates a text file with all listed sound effects
	rm -f ${bin}sounds/sound_list.txt
	echo '!!! this file is generated and will be overwritten automatically !!!' >> ${bin}sounds/sound_list.txt
	echo ' ' >> ${bin}sounds/sound_list.txt
	sed -n '/enum Sfx {/,/}/{
	/{/d
	/}/d
	p
	}' < ../src/com/grapefrukt/games/spacematch/sound/SoundManager.hx | sed -e "s/\s//g" | sed -e "s/;//g" >> ${bin}sounds/sound_list.txt

	syncDir "up" 	"." 		"*"					"true"
	syncDir "up" 	"images"	"*"
	#syncDir "up" 	"config" 	"values.cfg"
	#syncDir "up" 	"sounds" 	"sound_list.txt"

fi

echo -e "\033[36mCompleted!\033[0m"