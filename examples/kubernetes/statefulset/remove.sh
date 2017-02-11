#!/usr/bin/env bash

sigil -p -f stolon-keeper.yaml  namespace=$NAMESPACE| kubectl delete  -f -
#sigil -p -f stolon-proxy.yaml  namespace=$NAMESPACE| kubectl delete  -f -
#sigil -p -f stolon-sentinel.yaml  namespace=$NAMESPACE| kubectl delete  -f -
