#!/bin/bash

# Start the smbd service (Samba daemon)
/usr/sbin/smbd --foreground --no-process-group

# Keep the container running
tail -f /dev/null
