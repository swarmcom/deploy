#!/bin/bash
DOMAIN=$1
NETWORK=${2:-"reach3"}
if [ -z $DOMAIN ]
then
	echo Usage: $0 domain network
	exit
fi

if [ -e ~/keys/$DOMAIN.crt ] && [ -e ~/keys/$DOMAIN.key ]
then
   echo Found certificates for domain:$DOMAIN at ~/keys/, continue with ssl >&2
   read -r -d '' LISTEN_TO <<EOS
   listen 443 ssl;
   ssl_certificate /keys/$DOMAIN.crt;
   ssl_certificate_key /keys/$DOMAIN.key;
EOS
	read -r -d '' REDIRECT <<EOS
server {
   server_name $DOMAIN;
   listen 80;
   location /.well-known/acme-challenge/ {
      root /challenge/;
   }
   location / {
      return 301 https://$host$request_uri;
   }
}
EOS
else
   echo No certificates for domain:$DOMAIN found at ~/keys/, continue unencrypted >&2
   read -r -d '' LISTEN_TO <<EOS
   listen 80;
EOS
fi

cat <<EOT
$REDIRECT

server {
   server_name $DOMAIN;

   $LISTEN_TO

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
