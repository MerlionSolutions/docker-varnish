#!/bin/bash
set -e

exec varnishd -n /var/varnish \
        -f /etc/varnish/default.vcl \
        -s malloc,${VARNISH_MEMORY} \
        -a :${VARNISH_PORT}  -F
