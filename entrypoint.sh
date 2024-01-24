#!/usr/bin/env bash


if [ ! $(id $USERNAME) ]; then
	adduser \
		--disabled-password \
		--gecos '' \
		--uid $USERID \
		"$USERNAME"

fi
exec gosu $USERNAME "$@"
