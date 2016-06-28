#!/usr/bin/env bash

# Turn off wildcard expansion
set -f

USERNAME=$USER
# Project group is pg_<project-name>
PROJECT=$(groups $USER | sed -r 's/.*\bpg_([^\s]*)/\1/')

export OPENSHIFT_CA_CERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export OPENSHIFT_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
export OPENSHIFT_URL="https://KUBERNETES_SERVICE_HOST:443"

if [[ -t 0 ]]; then        
        if [ -z "$SSH_ORIGINAL_COMMAND" ]; then
	        /sshenv -i --tty $PROJECT $USERNAME bash
        else
                /sshenv -i --tty $PROJECT $USERNAME bash -c "$SSH_ORIGINAL_COMMAND"
        fi
else
        if [ -z "$SSH_ORIGINAL_COMMAND" ]; then
	        /sshenv -i $PROJECT $USERNAME bash
        else
                /sshenv -i $PROJECT $USERNAME bash -c "$SSH_ORIGINAL_COMMAND"
        fi  
fi
