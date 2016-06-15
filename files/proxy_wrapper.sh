#!/usr/bin/env bash

if [[ $# -eq 0 ]] ; then
        COMMAND=bash
else
        COMMAND="$@"
fi

USERNAME=$USER
# Project group is pg_<project-name>
PROJECT=$(groups $USER | sed -r 's/.*\bpg_([^\s]*)/\1/')

export OPENSHIFT_CA_CERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export OPENSHIFT_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
export OPENSHIFT_URL="https://KUBERNETES_SERVICE_HOST:443"

if [[ -t 0 ]]; then
        #echo "tty $COMMAND" >> /tmp/proxylog
	/sshenv -i --tty $PROJECT $USERNAME $COMMAND
else
        #echo "notty $COMMAND" >> /tmp/proxylog
	/sshenv -i $PROJECT $USERNAME $COMMAND      
fi
