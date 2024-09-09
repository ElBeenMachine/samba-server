#!/bin/bash

# Check if required environment variables are set
if [ -z "$SAMBA_USER" ] || [ -z "$SAMBA_PASSWORD" ] || [ -z "$SAMBA_SHARE" ]; then
    echo "Error: "
    if [ -z "$SAMBA_USER" ]; then
        echo "  SAMBA_USER environment variable must be set."
    fi
    if [ -z "$SAMBA_PASSWORD" ]; then
        echo "  SAMBA_PASSWORD environment variable must be set."
    fi
    if [ -z "$SAMBA_SHARE" ]; then
        echo "  SAMBA_SHARE environment variable must be set."
    fi
    exit 1
fi

# Substitute environment variables in smb.conf
envsubst < /etc/samba/smb.conf > /etc/samba/smb.conf.tmp && mv /etc/samba/smb.conf.tmp /etc/samba/smb.conf

# Check if Samba user exists
if pdbedit -L | grep -q "^$SAMBA_USER:"; then
    echo "Samba user $SAMBA_USER already exists."
else
    # Create user
    adduser --no-create-home --disabled-password --disabled-login --gecos "" $SAMBA_USER

    # Add Samba user
    if [ -n "$SAMBA_USER" ] && [ -n "$SAMBA_PASSWORD" ]; then
        echo "Adding Samba user: $SAMBA_USER"
        (echo "$SAMBA_PASSWORD"; echo "$SAMBA_PASSWORD") | smbpasswd -s -a "$SAMBA_USER"
        
        if [ $? -eq 0 ]; then
            echo "User $SAMBA_USER created successfully."
        fi
    fi
fi

# Make the user the owner of the share
chown $SAMBA_USER /srv/samba/share

# Log the smb.conf file
printf "\n-------------- smb.conf --------------\n\n"
cat /etc/samba/smb.conf

# Log Configuration
printf "\n-------------- CONFIGURATION --------------\n"
printf "\n\033[0;32mSAMBA USER: \033[1;37m$SAMBA_USER"
printf "\n\033[0;32mSAMBA PASSWORD: \033[1;37m$SAMBA_PASSWORD"
printf "\n\033[0;32mSAMBA SHARE: \033[1;37m$SAMBA_SHARE\n\n"
echo "-------------------------------------------"

# Start the smbd service (Samba daemon)
/usr/sbin/smbd --no-process-group

# Keep the container running
tail -f /dev/null
