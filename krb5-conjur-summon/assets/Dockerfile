FROM alpine
RUN apk add --no-cache krb5-server krb5 supervisor tini
ADD supervisord.conf /etc/supervisord.conf
ADD config_krb5.sh /
VOLUME /var/lib/krb5kdc
EXPOSE 749 464 88
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/config_krb5.sh"]
