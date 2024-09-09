# Use the latest version of Ubuntu as the base image
FROM ubuntu:latest

# Update the package list and install Samba and gettext-base
RUN apt-get update && \
    apt-get install -y samba gettext-base && \
    rm -rf /var/lib/apt/lists/*

# Copy the Samba configuration file to the appropriate directory
COPY ./config/smb.conf /etc/samba/smb.conf

# Expose the necessary ports for Samba
EXPOSE 137/udp 138/udp 139 445

# Create the directory for the Samba share, set ownership, and permissions
RUN mkdir -p /srv/samba/share && \
    chmod -R 0777 /srv/samba/share

# Copy the startup script to the appropriate directory and make it executable
COPY ./config/start.sh /usr/local/bin/start-samba.sh
RUN chmod +x /usr/local/bin/start-samba.sh

# Set the startup script as the container's entry point
CMD ["/usr/local/bin/start-samba.sh"]