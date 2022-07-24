#!/bin/sh
# Raokin Linux for shortcut command runit
# runit-link add [service_name]
# runit-link del [service_name]
# Copyright (c) 2022 Agung Wijaya
# Source: https://github.com/raokinlinux/runit-link/

SN="$2" # service name
DIR="/etc/runit/sv/$SN"
RUN="/run/runit/service/$SN"
BASE=$(basename "$0")

HELP="Usage: $BASE [service_name]
Shortcut command for runit

Options:
  add		symlink for runit service
  del		unlink for runit service
  list		list all service running
  --help	help this command
"

ERR="$BASE: invalid option -- '$1'
Try '$BASE --help' for more information."

is_root() {
	if [[ "root" != "$(whoami)" ]]; then
		# permission denied
		echo 'ERROR: Permission denied!'
		exit
	fi
}

runit_link() {
	if [[ -d "$RUN" ]]; then
		# service running
		echo 'service was running!'
	elif [[ -d "$DIR" ]]; then
		# if service exists
		is_root
		ln -s "$DIR" /run/runit/service/
		echo "service $SN has been linked!"
	else
		# service doesn't exists
		echo 'service not found!'
	fi
}

runit_unlink() {
	if [[ -d "$RUN" ]]; then
		# if service still running
		is_root
		unlink "$RUN"
		echo "service $SN has been unlinked!"
	else
		# service not running
		echo 'service has not running!'
	fi
}

runit_list() {
	# list service running
	ls /run/runit/service/
}

runit_help() {
	echo "$HELP"
}

runit_err() {
	echo "$ERR"
}

# Execute
case $1 in
	add)
		runit_link
		;;
	del)
		runit_unlink
		;;
	list)
		runit_list
		;;
	--help)
		runit_help
		;;
	*)
		runit_err
		;;
esac

exit
