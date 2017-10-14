#!/usr/bin/env bash

cd /etc/varnish

BACKEND_HOST=$1 BACKEND_PORT=$2 eval "cat <<EOF
$(</etc/varnish/default.source.vcl)
EOF
" 2> /dev/null > /etc/varnish/default.vcl