#!/bin/bash

curl -s -u $SOLMGTUSR:$SOLMGTPASS -d "<rpc  semp-version=\"soltr/7_1_1\"><show><smrp><subscriptions><summary></summary></subscriptions></smrp></show></rpc>" http://$SOLMGT1:80/SEMP | grep "<total-subscriptions>" | grep -Po '<.*?>\K.*?(?=<.*?>)'
