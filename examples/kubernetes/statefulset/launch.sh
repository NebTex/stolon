#!/usr/bin/env bash

[ -z $NAMESPACE ] && { echo "Need to set NAMESPACE"; exit 1; }
[ -z $PGPASS ] && { echo "Need to set PG_PASS"; exit 1; }
[ -z $CONSUL_TOKEN ] && { echo "Need to set CONSUL_TOKEN"; exit 1; }

ct=$(printf $CONSUL_TOKEN|base64 -w 0)
ps=$(printf $PGPASS|base64 -w 0)

# create secret
if kubectl get secrets --namespace $NAMESPACE | grep -q "stolon-credentials"; then
    echo "stolon-credentials already exists"
else
    sigil -p -f secrets.yml  namespace=$NAMESPACE password=$ps CONSUL_HTTP_TOKEN=$ct | kubectl  apply --validate=false --overwrite -f -
fi

kubectl -n=$NAMESPACE create configmap stolon-keeper-init --from-file=init-keeper.sh

# sentinel
sigil -p -f stolon-sentinel.yaml namespace=$NAMESPACE| kubectl apply --validate --overwrite -f -


# launch keeper
sigil -p -f stolon-keeper.yaml  namespace=$NAMESPACE| kubectl apply --validate --overwrite -f -

# proxy
sigil -p -f stolon-proxy.yaml namespace=$NAMESPACE| kubectl apply --validate --overwrite -f -

# service
# kubectl apply -f service-proxy.yaml --validate --overwrite
sigil -p -f stolon-proxy-service.yaml namespace=$NAMESPACE| kubectl apply --validate=false --overwrite -f -
