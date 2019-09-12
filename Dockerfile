FROM docker:stable

LABEL "com.github.actions.name"="docker build"
LABEL "com.github.actions.description"="A Action CI plugin for building and labelling Docker images"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

ADD *.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh

ENTRYPOINT [ "/usr/local/bin/build.sh" ]
