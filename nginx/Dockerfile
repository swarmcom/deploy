FROM nginx
LABEL author="Roman Galeev <jamhedd@gmail.com>"
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

EXPOSE 80
EXPOSE 443

RUN rm -rf /etc/nginx/conf.d
COPY conf.d /etc/nginx/conf.d
