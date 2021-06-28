FROM alpine

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.
RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
 ALPINE_GLIBC_PACKAGE_VERSION="2.27-r0" && \
 ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
 ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
 ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
 apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
 wget \
 "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.27-r0/sgerrand.rsa.pub" \
 -O "/etc/apk/keys/sgerrand.rsa.pub" && \
 wget \
 "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
 "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
 "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
 apk add --no-cache \
 "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
 "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
 "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
 \
 rm "/etc/apk/keys/sgerrand.rsa.pub" && \
 /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 "$LANG" || true && \
 echo "export LANG=$LANG" > /etc/profile.d/locale.sh && \
 \
 apk del glibc-i18n && \
 \
 rm "/root/.wget-hsts" && \
 apk del .build-dependencies && \
 rm \
 "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
 "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
 "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

# install java
RUN apk update && apk upgrade && \
    apk add openjdk8 && \
    mkdir /tmp/tmprt && \
    cd /tmp/tmprt && \
    apk add zip && \
    unzip -q /usr/lib/jvm/default-jvm/jre/lib/rt.jar && \
    apk add zip && \
    zip -q -r /tmp/rt.zip . && \
    apk del zip && \
    cd /tmp && \
    mv rt.zip /usr/lib/jvm/default-jvm/jre/lib/rt.jar && \
    rm -rf /tmp/tmprt /var/cache/apk/* bin/jjs bin/keytool bin/orbd bin/pack200 bin/policytool \
          bin/rmid bin/rmiregistry bin/servertool bin/tnameserv bin/unpack200

RUN mkdir /root/packer
WORKDIR /root/packer
RUN wget https://releases.hashicorp.com/packer/1.2.4/packer_1.2.4_linux_amd64.zip
RUN wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip
RUN apk update
RUN unzip packer_1.2.4_linux_amd64.zip
RUN unzip terraform_0.11.7_linux_amd64.zip
RUN mv packer /usr/local/bin/packer
RUN mv terraform /usr/local/bin/terraform
RUN rm packer_1.2.4_linux_amd64.zip
RUN rm terraform_0.11.7_linux_amd64.zip
RUN apk update && apk upgrade && \
 apk add --no-cache bash git openssh
