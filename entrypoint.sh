#!/bin/sh


# Start DNS server in background right away
./dnscrypt-proxy &
pid=$!

while true
do
    echo "Fetching DAppNode domain"
    domain=$(curl -s my.dappnode/global-envs/DOMAIN)
    if [ ! -z $domain ]; then
        break
    fi
    sleep 1
done

while true
do
    echo "Fetching DAppNode local IP"
    internal_ip=$(curl -s my.dappnode/global-envs/INTERNAL_IP)
    if [ ! -z $internal_ip ]; then
        break
    fi
    sleep 1
done

echo "$domain $internal_ip" > cloaking-rules.txt

kill $pid

./dnscrypt-proxy