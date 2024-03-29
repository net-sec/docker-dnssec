#!/bin/bash

podman build --rm -t net-sec/dnssec ./
podman rm -f dnssec

# https://blog.christophersmart.com/2021/01/26/user-ids-and-rootless-containers-with-podman/
sudo chown -R 100099 domainKeys

# a real salt can be derived from
# head -c 1000 /dev/random | sha1sum | cut -b 1-16
podman run -itd \
	-v $(pwd)/exampleDomains:/domains:ro \
	-v $(pwd)/domainKeys:/var/bind/keys:z \
	-p 5353:5353 \
	--name dnssec net-sec/dnssec
