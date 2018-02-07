#!/bin/sh
DOMAIN=$1
NETWORK=$2
if [ -z $NETWORK ]
then
	echo Usage: $0 domain network
	exit
fi

cat <<EOT
server {
   listen 443 ssl;
   server_name $DOMAIN;

   ssl_certificate /keys/$DOMAIN.crt;
   ssl_certificate_key /keys/$DOMAIN.key;

   client_max_body_size 20M;

   location / {
      proxy_pass http://reach-ui.$NETWORK:8080;
      include /etc/nginx/conf.d/fwd;
   }

   location /reach/ {
      proxy_pass http://reach.$NETWORK:8937/;
      include /etc/nginx/conf.d/fwd;
   }

   location /rr/ {
      proxy_pass http://rr.$NETWORK:9090/;
      include /etc/nginx/conf.d/fwd;
   }
}
EOT
