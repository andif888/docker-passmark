FROM ubuntu:focal
LABEL maintainer="andif888"
ENV DEBIAN_FRONTEND noninteractive

# ssh
ENV SSH_PASSWD "root:Docker!"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        dmidecode \
        libncurses5 \
        openssh-server \
        passwd \
        python3 \
        sudo \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean


RUN echo "$SSH_PASSWD" | chpasswd 

RUN curl -O https://www.passmark.com/downloads/pt_linux_x64.zip \
    && unzip pt_linux_x64.zip \    
    && rm -f pt_linux_x64.zip \
    && chmod +x ./PerformanceTest/pt_linux_x64 

COPY sshd_config /etc/ssh/
COPY init.sh /usr/local/bin/

RUN chmod u+x /usr/local/bin/init.sh

EXPOSE 80 2222
WORKDIR /PerformanceTest

ENTRYPOINT ["init.sh"]
