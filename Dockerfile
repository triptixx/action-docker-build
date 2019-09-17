FROM docker:stable

ADD *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh; \
    apk add --no-cache jq;

ENTRYPOINT [ "/usr/local/bin/build.sh" ]
