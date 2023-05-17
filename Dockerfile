FROM php:8.1.19-fpm-alpine3.18

# Install container dependencies
RUN apk --update --no-cache add \
    apache2-utils \
    bash \
    bind-tools\
    curl \
    doas \
    ffmpeg \
    findutils \
    geoip \
    git \
    ipcalc \
    iproute2 \
    iptables \
    ip6tables \
    openresolv \
    mediainfo \
    micro \
    nginx \
    nginx-mod-http-dav-ext \
    nginx-mod-http-geoip2 \
    openssl \
    python3 \
    py3-pip \
    sox \
    tar \
    tini \
    tzdata \
    unzip \
    util-linux \
    wireguard-tools \
    zip

# Install unrar from Alpine 3.14 repositories 
RUN echo "@314 http://dl-cdn.alpinelinux.org/alpine/v3.14/main" >> /etc/apk/repositories && \
    apk --update --no-cache add unrar@314

# Update pip3 and install Cloudscraper
RUN pip3 install --upgrade pip && \
    pip3 install cfscrape cloudscraper

# Install rTorrent and Flood from Jesec's GitHub
RUN curl -sSL https://github.com/jesec/rtorrent/releases/latest/download/rtorrent-linux-amd64 -o /usr/local/bin/rtorrent && \
    curl -sSL https://github.com/jesec/flood/releases/latest/download/flood-linux-x64 -o /usr/local/bin/flood && \
    chmod +x /usr/local/bin/*

# Install ruTorrent from Novik's GitHub
RUN git clone https://github.com/novik/rutorrent /var/www/rutorrent && \
    chown www-data:www-data -R /var/www

# Initialize container environment variables
ENV PUID="1000" \
    PGID="1000" \
    TZ="Etc/UTC"

# Add default user and group
RUN addgroup -g ${PGID} abc && \
    adduser -D -h /config -u ${PUID} -G abc -s /bin/bash abc && \
    echo 'permit nopass abc as root' >> /etc/doas.d/doas.conf && \
    echo 'permit nopass root as abc' >> /etc/doas.d/doas.conf

# Copy config files and scripts
COPY rootfs /

# Fix permissions
RUN chown ${PUID}:${PGID} -R /downloads /config

# Expose ports
EXPOSE 8080
EXPOSE 3000

# Expose volumes
VOLUME ["/config", "/downloads"]

# Start init system and startup script
ENTRYPOINT ["tini", "--"]
CMD ["/start.sh"]
