FROM alpine
LABEL maintainer="Pavel Farkas <pavel.farkas@ezuce.com>"

RUN adduser -h /home/user -D user user

ENV PATH=$PATH:/home/user
USER user
WORKDIR "/home/user"
RUN mkdir "data-reach"
