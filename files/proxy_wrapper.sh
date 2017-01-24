#!/usr/bin/env bash

# Turn off wildcard expansion
set -f

SSHENV=/sshenv
# Project group is pg_<project-name>
# SSH group (if present) is ssh_<group-name>
PROJECT=$(groups $USER | sed -rn 's/.*\bpg_([^ \t]*).*/\1/p')
SSHGROUP=$(groups $USER | sed -rn 's/.*\b(ssh_[^ \t]*).*/\1/p')

if [ ! -z $SSHGROUP ]; then
        SSHENV="$SSHENV -sshgroup $SSHGROUP"
fi

export OPENSHIFT_CA_CERT=/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
export OPENSHIFT_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
export OPENSHIFT_URL="https://KUBERNETES_SERVICE_HOST:443"

if [[ -t 0 ]]; then
        SSHENV="$SSHENV --tty"
fi

if [ -z "$SSH_ORIGINAL_COMMAND" ]; then
        $SSHENV -i $PROJECT $USER bash
else
        $SSHENV -i $PROJECT $USER bash -c "$SSH_ORIGINAL_COMMAND"
fi  
