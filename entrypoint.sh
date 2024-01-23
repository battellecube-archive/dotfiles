#!/usr/bin/env bash


if [ ! $(id $USERNAME) ]; then
	adduser \
		--disabled-password \
		--gecos '' \
		--home /home/$USERNAME \
		--uid $USERID \
		"$USERNAME"

fi
export HOME=/home/$USERNAME
chown $USERNAME:$USERNAME $HOME
cd $HOME
su "$USERNAME"
