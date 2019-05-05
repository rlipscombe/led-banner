#!/bin/bash -e

AGENT_URL=$1
FONT=$2
MESSAGE=$3

figlet -w 1000 -f $FONT "${MESSAGE}" | \
        awk 'flag {print} flag == 0 {if(NF) {flag=1; print}}' | tac | \
        awk 'flag {print} flag == 0 {if(NF) {flag=1; print}}' | tac | \
        head -n 8 | tee /dev/stderr | \
        curl -s -X POST ${AGENT_URL} --data-binary @-
