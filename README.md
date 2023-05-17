# rTorrent - Flood - RuTorrent -Wireguard

### rTorrent BitTorrent Client

rTorrent is a stable, high-performance and low resource consumption BitTorrent client. This project uses Jesec's fork due to its modern enhancements such as JSON-RPC. More information can be found at https://github.com/jesec/rtorrent.

### Flood

Flood is a modern web front-end for the rTorrent BitTorrent Client written in Node.js. More information can be found at https://github.com/jesec/flood.

### ruTorrent

ruTorrent is a popular web front-end for the rTorrent BitTorrent Client with a traditional interface. It allows for numerous plugins and scripts to be deployed for advanced situations. More information can be found at https://github.com/novik/rutorrent.

### Wireguard

This project is intended to run a rTorrent BitTorrent client behind a Wireguard vpn. It includes a kill switch to ensure that any traffic not encrypted via Wireguard is dropped.

## Usage

### Command Line

```bash
docker run --name rtorrent                                           \
    --cap-add NET_ADMIN                                              \
    --cap-add SYS_MODULE                                             \
    --sysctl net.ipv4.conf.all.src_valid_mark=1                      \
    -e PUID=1000                                                     \
    -e PGID=1000                                                     \
    -e TZ=Etc/UTC                                                    \
    -e LOCAL_SUBNETS=10.17.0.0/16,192.168.1.0/24                     \
    -v /path/to/config:/config                                       \
    -v /path/to/downloads:/downloads                                 \
    -v /path/to/wireguard/conf/wg0.conf:/etc/wireguard/wg0.conf      \
    -p 8080:8080                                                     \
    -p 3000:3000                                                     \
    --restart=unless-stopped
    theimmortal/rtorrent
```

### Docker Compose

Here is the same example as above, but using Docker Compose:

```yml
services:
  rtorrent:
    container_name: rtorrent
    image: theimmortal/rtorrent
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      net.ipv4.conf.all.src_valid_mark: 1
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - LOCAL_SUBNETS=10.17.0.0/16,192.168.1.0/24
    volumes:
      - /path/to/config:/config
      - /path/to/downloads:/downloads
      - /path/to/wireguard/conf/wg0.conf:/etc/wireguard/wg0.conf
    ports:
      - 8080:8080
      - 3000:3000
    restart: unless-stopped
```

## Instructions

### Environment Variables

* `TZ`: The timezone assigned to the container (default `UTC`)
* `PUID`: rTorrent user id (default `1000`)
* `PGID`: rTorrent group id (default `1000`)
* `LOCAL_SUBNETS`: Comma separated list of subnets that can access the web front-ends: Flood/ruTorrent (default is blocked).

### Volumes
* `/config`: Where rtorrent and flood store configuration and session files.
* `/downloads`: The default download location within the container.
* `/etc/wireguard/wg0.conf`: The wireguard configuration file supplied by the vpn provider.

### Ports
* `8080`: Default port for the ruTorrent web front-end.
* `3000`: Default port for the Flood web front-end.

NOTE: For podman, you must add --cap_add=NET_RAW to give the container sufficient privileges to manage the wireguard network.
