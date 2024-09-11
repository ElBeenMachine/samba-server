# SAMBA Server

This is a simple dockerised samba server, it is a quick and easy way to spin up a protected SMB share whether it be for testing purposes, or to use for a project. 

## Implementation

### Docker

To deploy the SMB server using Docker, you can use the following command: 

```
docker run -d \
  --name samba-server \
  --network host \
  --volume ./data:/srv/samba/share \
  --env SAMBA_USER=smbuser \
  --env SAMBA_PASSWORD=password \
  --env SAMBA_SHARE=share \
  beenhamo/samba-server:latest
```

### Docker Compose

You can achieve the same result from the following docker compose file:

```yaml
services:
  smb:
    image: beenhamo/samba-server:latest
    container_name: samba-server
    network_mode: host
    volumes:
      - ./data:/srv/samba/share
    environment:
      - SAMBA_USER=smbuser
      - SAMBA_PASSWORD=password
      - SAMBA_SHARE=share
    restart: unless-stopped

```

The above file can be found at [examples/docker-compose.yml](examples/docker-compose.yml).

## Usage

Regardless of how you spin up the container, it should become available fairly quickly, and you can access it from the host's ip address.