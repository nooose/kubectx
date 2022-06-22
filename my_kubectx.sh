#!/bin/bash

CONTEXT_HOLDER=`kubectl config get-contexts \
                                        | grep '*' \
                                        | awk '{print $2}'`

kubectl config get-contexts \
                                | awk '{if (NR > 1) print $2}' \
                                | awk -v context="$CONTEXT_HOLDER" \
                                                        '{if ($1 == context) {
                                                                print "\033[34m[" NR "] " $1 "\033[0m"
                                                        } else {
                                                                print "[" NR "] " $1
                                                        }}'

read -p "Select context > " INPUT_CTX_NUMBER

if [ $INPUT_CTX_NUMBER -eq 0 ]; then
        exit 0
fi

for kubectx in `kubectl config get-contexts | awk '{if (NR > 1) print NR - 1 "," $2}'`
do
        context_number=${kubectx%,*}
        context_name=${kubectx#*,}

        if [ $context_number -eq $INPUT_CTX_NUMBER ] && [ $context_name != $CONTEXT_HOLDER ]; then
                kubectl config use-context $context_name
                exit 0
        fi
done
