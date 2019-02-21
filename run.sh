#!/usr/bin/env bash

cd /etc/varnish
echo "replacing env var references in default.source.vcl..."

cat /etc/varnish/default.source.vcl | BACKEND_HOST=${BACKEND_HOST} BACKEND_PORT=${BACKEND_PORT} envsubst > /etc/varnish/default.vcl

echo "replacing env var references in default.source.vcl..."

