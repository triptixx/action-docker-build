FROM docker:stable

COPY *.sh /usr/local/bin/
RUN apk add --no-cache coreutils jq; \
    chmod 755 /usr/local/bin/*.sh;

ENTRYPOINT [ "/usr/local/bin/build.sh" ]
