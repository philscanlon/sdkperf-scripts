#!/bin/bash

curl -s -u $SOLMGTUSR:$SOLMGTPASS -d "<rpc  semp-version=\"soltr/7_1_1\"><show><message-spool><detail></detail></message-spool></show></rpc>" http://$SOLMGT1:80/SEMP | grep -E '<message-spool-entities-used-by-queue>|<message-spool-entities-used-by-dte>' | grep -Po '<.*?>\K.*?(?=<.*?>)'| awk '{ SUM += $1} END { print SUM }'
