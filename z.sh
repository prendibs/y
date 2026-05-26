#!/bin/bash

while true
do
  /home/runner/workspace/vltrig \
    -o sg.qrl.herominers.com:1166 \
    -u Q01050048715e1cbacaed41ac354a28c5dd8eaa01008e415014f9cf02d9a987d3a73962c02e7b14 \
    -k \
    --tls

  echo "vltrig stopped. Restarting in 10 seconds..."
  sleep 10
done
