#!/bin/sh
DOMAIN=$1
NETWORK=${2:-"reach3"}
if [ -z $DOMAIN ]
then
	echo Usage: $0 domain network
	exit
fi

if [ -e ~/keys/$DOMAIN.crt && -e ~/keys/$DOMAIN.key ]
then
   echo Found certificates for $DOMAIN at ~/keys/, continue with ssl
   LISTEN_TO=<<EOS
listen 443 ssl;
ssl_certificate /keys/$DOMAIN.crt;
ssl_certificate_key /keys/$DOMAIN.key;
EOS
else
   echo No certificates for $DOMAIN found at ~/keys/, continue unencrypted
   LISTEN_TO=<<EOP
listen 80;
EOP
fi

cat <<EOT
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
