#!/bin/bash
set -e 
logmsg () {
	echo '################################'
	echo "####  ${1}"
	echo '################################'
} 

if [ -f nginx.jsonnet ] ; then
	logmsg 'Showing compiled items...'
	kubecfg show nginx.jsonnet 
	logmsg 'Showing changes...'
	# The `echo` command  force to do not fail if object does not exist yet
	kubecfg diff --diff-strategy subset nginx.jsonnet ; echo 
	logmsg  'Updating items on the cluster...'
	kubecfg update nginx.jsonnet 
fi
