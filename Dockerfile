FROM golang:1.8

MAINTAINER Jan Schmidle <jan@cospired.com>

# Add ZT files
ADD zerotier /var/lib/zerotier-sdk
ADD app-wrapper.sh /usr/local/bin/app-wrapper.sh

ENTRYPOINT /usr/local/bin/app-wrapper.sh
