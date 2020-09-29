#!/bin/bash

# echo $mydate

cat /dev/null > /tmp/logfile.dat

level="debug"
ts=`date -d '20200220' +%s`
conn_id=0
state="closed"

for i in {0..1440}
do
conn_id=$i
ts=$((ts+1))
tx=$((0 + RANDOM % 10000))
rx=$((0 + RANDOM % 10000))
data="{
    \"level\":\"${level}\",
    \"ts\":${ts},
    \"conn_id\":${conn_id},
    \"state\":\"${state}\",
    \"Tx\":${tx},
    \"Rx\":${rx}
    }"
echo $data >> /tmp/logfile.dat
done

docker build -t myexporter -f custom-prometheus-exporter/Dockerfile .

docker run --rm \
    --name custom-prometheus-exporter -p 12345:12345 \
    -v $(pwd)/code-challenge.yaml:/tmp/test-exporter.yaml \
    -v /tmp/logfile.dat:/tmp/logfile.dat \
    myexporter -f /tmp/test-exporter.yaml

