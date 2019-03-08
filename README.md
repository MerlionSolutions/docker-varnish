# Varnish
Use varnish reverse-proxy in docker for caching


## How to run it
```
docker build . -t kizzlebot/docker-varnish:latest
docker run -ti --rm -p 9000:6085 -e BACKEND_HOST="192.168.1.41" -e BACKEND_PORT="3000" -e VARNISH_PORT=6085 --name varnish kizzlebot/docker-varnish:latest

# or to use customized vcl file
docker run -ti --rm -p 9000:6085 -e BACKEND_HOST="192.168.1.41" -e BACKEND_PORT="3000" -e VARNISH_PORT=6085 -v ${PWD}/vcl/default.source.vcl:/etc/varnish/default.source.vcl --name varnish kizzlebot/docker-varnish:latest
```



