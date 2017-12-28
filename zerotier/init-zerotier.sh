#!/bin/bash
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/

export ZEROTIER_SDK_PATH=/var/lib/zerotier-sdk

## Network Parameters
#
if [ -z "$ZEROTIER_NETWORK_ID" ]; then
    echo "Need to set \$ZEROTIER_NETWORK_ID"
    exit 1
fi

## Init ZeroTier SDK
#
mkdir -p $ZEROTIER_SDK_PATH/networks.d
$ZEROTIER_SDK_PATH/zerotier-sdk-service -d -U -p9993 $ZEROTIER_SDK_PATH &

virtip4=""
ZEROTIER_ADDRESS=""

echo "*** ZeroTier waiting for node address ..."
while [ -z "$ZEROTIER_ADDRESS" ]; do
	sleep 0.2
	ZEROTIER_ADDRESS=$($ZEROTIER_SDK_PATH/zerotier-cli -D$ZEROTIER_SDK_PATH info | awk '{print $3}')
done
echo "*** ZeroTier node address:  $ZEROTIER_ADDRESS"

echo '*** ZeroTier Connect Network: '"$ZEROTIER_NETWORK_ID"
$ZEROTIER_SDK_PATH/zerotier-cli -D$ZEROTIER_SDK_PATH join $ZEROTIER_NETWORK_ID > /dev/null
sleep 0.2

while [ -z "$virtip4" ]; do
	sleep 0.2
	virtip4=`$ZEROTIER_SDK_PATH/zerotier-cli -D$ZEROTIER_SDK_PATH listnetworks | grep -F $ZEROTIER_NETWORK_ID | cut -d ' ' -f 9 | sed 's/,/\n/g' | grep -F '.' | cut -d / -f 1`
	dev=`$ZEROTIER_SDK_PATH/zerotier-cli -D$ZEROTIER_SDK_PATH listnetworks | grep -F "" | cut -d ' ' -f 8 | cut -d "_" -f 2 | sed "s/^<dev>//" | tr '\n' '\0'`
done
echo "*** ZeroTier Address: $virtip4"
echo "*** ZeroTier Device: $dev"

# --- Test section ---
sleep 0.5
#export ZT_NC_NETWORK=/var/lib/zerotier-one/nc_"$dev"
#export LD_PRELOAD=/libztintercept.so
