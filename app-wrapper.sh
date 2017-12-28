#!/bin/sh
/var/lib/zerotier-sdk/init-zerotier.sh || exit 1
export ZT_NC_NETWORK=/var/lib/zerotier-sdk/nc_$ZEROTIER_NETWORK_ID
export LD_PRELOAD=/var/lib/zerotier-sdk/libztintercept.so

$@
