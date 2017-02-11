#!/usr/bin/env bash

# Generate our keeper uid using the pod index
IFS='-' read -ra ADDR <<< "$(hostname)"
export STKEEPER_UID="keeper${ADDR[-1]}"
export POD_IP=$(hostname -i)
export STKEEPER_PG_LISTEN_ADDRESS=$POD_IP
export STOLON_DATA=/stolon-data
chown stolon:stolon $STOLON_DATA
cp $STKEEPER_PG_SU_PASSWORDFILE /etc/pgpass
export STKEEPER_PG_SU_PASSWORDFILE=/etc/pgpass
chown stolon:stolon $STKEEPER_PG_SU_PASSWORDFILE
chmod 400 $STKEEPER_PG_SU_PASSWORDFILE
gosu stolon stolon-keeper --data-dir $STOLON_DATA