########################################################################################################################
## NECONOMICON - https://github.com/viduc/neconomicon                                                                 ##
## This file is a part of NECONOMICON application                                                                     ##
########################################################################################################################
FROM alpine:latest

RUN apk add --update nginx
RUN rm -rf /var/cache/apk/* && rm -rf /tmp/*

ADD nginx.conf /etc/nginx/
ADD symfony.conf /etc/nginx/conf.d/
ADD upstream.conf /etc/nginx/conf.d/

RUN adduser -D -g '' -G www-data www-data

CMD ["nginx"]

EXPOSE 80
