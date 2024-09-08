#!/bin/bash

# Check if required environment variables are set
if [ -z "$SAMBA_USER" ] || [ -z "$SAMBA_PASSWORD" ] || [ -z "$SAMBA_SHARE" ]; then
    echo "Error: SAMBA_USER, SAMBA_PASSWORD, and SAMBA_SHARE environment variables must be set."
    exit 1
fi

# Substitute environment variables in smb.conf
envsubst < /etc/samba/smb.conf > /etc/samba/smb.conf.tmp && mv /etc/samba/smb.conf.tmp /etc/samba/smb.conf

# Add Samba user
if [ -n "$SAMBA_USER" ] && [ -n "$SAMBA_PASSWORD" ]; then
    (echo "$SAMBA_PASSWORD"; echo "$SAMBA_PASSWORD") | smbpasswd -s -a "$SAMBA_USER"
fi

# Start the smbd service (Samba daemon)
/usr/sbin/smbd --foreground --no-process-group

# Keep the container running
tail -f /dev/null
