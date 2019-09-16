FROM docker:stable

ADD *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh; \
    ls -al /github/workspace;

ENTRYPOINT [ "/usr/local/bin/build.sh" ]
