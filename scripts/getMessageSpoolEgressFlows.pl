#!/bin/bash

curl -s -u $SOLMGTUSR:$SOLMGTPASS -d "<rpc  semp-version=\"soltr/7_1_1\"><show><message-spool><detail></detail></message-spool></show></rpc>" http://$SOLMGT1:80/SEMP | grep -E '<active-flow-count>|<inactive-flow-count>|<browser-flow-count>' | grep -Po '<.*?>\K.*?(?=<.*?>)'| awk '{ SUM += $1} END { print SUM }'
