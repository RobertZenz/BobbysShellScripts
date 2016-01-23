#!/usr/bin/env sh

# Sets up a git repository with GitHub, BitBucket and Launchpad, with the main
# origin set to GitHub.

# Public Domain or CC0


# The project name.
project_name=$(dialog \
	--stdout \
	--trim \
	--inputbox \
	"Please enter the project name for \"$(basename "$PWD")\"." \
	7 \
	70 \
	"$(basename "$PWD")")


# Adds the repository to the local git repository.
#
# @param remote_name The name of the remote.
# @param remote_url The URL of the remote, with placeholders for the username
#                   and password.
# @param default Optional. Set to any value will trigger that this will be
#                the default remote that is used.
add_remote() {
	remote_name=$(echo "$1" | sed "s/\(.*\)/\L\1/g")
	remote_url="$2"
	default="$3"
	
	username=$(dialog --stdout --trim --inputbox "Please enter your $remote_name username." 7 70)
	remote_url=$(echo -n "$remote_url" | sed "s/USERNAME/$username/g" | sed "s/PROJECT_NAME/$project_name/g")
	
	# Remove the remote first if it already exists.
	$(git remote show | grep --quiet "$remote_name")
	if [ $? -eq 0 ]; then
		git remote remove "$remote_name"
	fi
	
	git remote add "$remote_name" "$remote_url"
	
	# Add the URL to the origin.
	if [ -z "$default" ]; then
		git remote set-url origin --add "$remote_url"
	else
		$(git remote show | grep --quiet "origin")
		if [ $? -eq 0 ]; then
			git remote remove origin
		fi
		
		git remote add origin "$remote_url"
	fi
}

# Tests the remote if it is working.
#
# param remote_name The name of the remote to test.
rest_remote() {
	remote_name=$(echo "$1" | sed "s/\(.*\)/\L\1/g")
	
	/bin/echo -n "Testing \"$remote_name\": "
	
	$(git ls-remote $remote_name > /dev/null 2>&1)
	if [ $? -ne 0 ]; then
		echo "FAILED"
	else
		echo "OK"
	fi
}


# Check if here is already a repository.
$(git rev-parse > /dev/null 2>&1)
if [ $? -ne 0 ]; then
	git init
fi

add_remote "GitHub" "git@github.com:USERNAME/PROJECT_NAME.git" "default"
add_remote "BitBucket" "git@bitbucket.org:USERNAME/PROJECT_NAME.git"
add_remote "Launchpad" "git+ssh://USERNAME@git.launchpad.net/PROJECT_NAME"

git remote -v

echo ""

rest_remote "GitHub"
rest_remote "BitBucket"
rest_remote "Launchpad"

echo ""
echo "Local copy initialized."

