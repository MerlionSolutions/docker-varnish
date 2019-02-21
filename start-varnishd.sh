#!/bin/bash

/usr/local/bin/run_script.sh && cat /etc/varnish/default.vcl && varnishd -n /var/varnish -f /etc/varnish/default.vcl -s malloc,${VARNISH_MEMORY} -a 0.0.0.0:${VARNISH_PORT} -F
