#!/bin/bash

cd /hddcoin-blockchain

. ./activate

if [[ $(hddcoin keys show | wc -l) -lt 5 ]]; then
    if [[ ${keys} == "generate" ]]; then
      echo "to use your own keys pass them as a text file -v /path/to/keyfile:/path/in/container and -e keys=\"/path/in/container\""
      hddcoin init && hddcoin keys generate
    elif [[ ${keys} == "copy" ]]; then
      if [[ -z ${ca} ]]; then
        echo "A path to a copy of the farmer peer's ssl/ca required."
        exit
      else
      hddcoin init -c ${ca}
      fi
    elif [[ ${keys} == "type" ]]; then
      hddcoin init
      echo "Call from docker shell: hddcoin keys add"
      echo "Restart the container after mnemonic input"
    else
      hddcoin init && hddcoin keys add -f ${keys}
    fi
else
    for p in ${plots_dir//:/ }; do
        mkdir -p ${p}
        if [[ ! "$(ls -A $p)" ]]; then
            echo "Plots directory '${p}' appears to be empty, try mounting a plot directory with the docker -v command"
        fi
        hddcoin plots add -d ${p}
    done

    sed -i 's/localhost/127.0.0.1/g' ~/.hddcoin/mainnet/config/config.yaml

    if [[ ${farmer} == 'true' ]]; then
      hddcoin start farmer-only
    elif [[ ${harvester} == 'true' ]]; then
      if [[ -z ${farmer_address} || -z ${farmer_port} || -z ${ca} ]]; then
        echo "A farmer peer address, port, and ca path are required."
        exit
      else
        hddcoin configure --set-farmer-peer ${farmer_address}:${farmer_port}
        hddcoin start harvester
      fi
    else
      hddcoin start farmer
    fi
fi

while true; do sleep 30; done;
