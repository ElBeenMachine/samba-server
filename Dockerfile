FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y samba && \
    rm -rf /var/lib/apt/lists/*

COPY ./config/smb.conf /etc/samba/smb.conf

EXPOSE 137/udp 138/udp 139 445

RUN mkdir -p /srv/samba/share && \
    chown nobody:nogroup /srv/samba/share && \
    chmod -R 0777 /srv/samba/share

COPY ./config/start.sh /usr/local/bin/start-samba.sh
RUN chmod +x /usr/local/bin/start-samba.sh

CMD ["/usr/local/bin/start-samba.sh"]