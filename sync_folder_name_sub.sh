#!/bin/sh

name=$(sed -nr 's/^.*"name": "([^"]+)".*$/\1/gp' info.json)
version=$(sed -nr 's/^.*"version": "([^"]+)".*$/\1/gp' info.json)
folder_name="$(basename $(pwd))"
new_folder_name="${name}_${version}"

if [[ "${folder_name}" == "${new_folder_name}" ]]; then
	echo "'${folder_name}' and '${new_folder_name}' are the same file"
	exit 0
fi

(
	cd ..
	if ! mv "${folder_name}" "${new_folder_name}" ; then
		echo "Trying to unlock the folder..."
		handle64 ${folder_name} > output.txt
		awk '{system("handle64 -c " substr($6, 1, length($6) - 1) " -y -p " $3)}' output.txt
		mv "${folder_name}" "${new_folder_name}"
	fi
)
