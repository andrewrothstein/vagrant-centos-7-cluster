#!/usr/bin/env bash

PKI_DIR=pki-dir
PKI_KEY_SUFFIX=-key.pem
mkdir -p $PKI_DIR

if [ ! -e $PKI_DIR/ca$PKI_KEY_SUFFIX ]
then
   echo generating CA key, csr, and cert...;
   cfssl genkey -initca $PKI_DIR/ca.json | cfssljson -bare $PKI_DIR/ca;
   echo done building CA;
fi
echo CA files...
ls -l $PKI_DIR/ca*

DOMAIN=vagrant.test
CLUSTER=centos-7
function getkey
{
    WORKER_ID=$1
    WORKER_NO="0${WORKER_ID}"
    HOSTNAME=$CLUSTER-$WORKER_NO.$DOMAIN
    LB_NAME=$CLUSTER.$DOMAIN
    LB_SUBS="*.$CLUSTER.$DOMAIN"
    if [ ! -e $PKI_DIR/$HOSTNAME$PKI_KEY_SUFFIX ]
    then
	cfssl \
	    gencert \
	    -ca $PKI_DIR/ca.pem \
	    -ca-key $PKI_DIR/ca$PKI_KEY_SUFFIX \
	    -hostname=$HOSTNAME,$LB_NAME,$LB_SUBS,192.168.33.$(( WORKER_ID + 6 )) \
	    $PKI_DIR/host.json \
	    | cfssljson -bare $PKI_DIR/$HOSTNAME
    fi
    echo key, csr, and cert for $HOSTNAME
    ls -l $PKI_DIR/$HOSTNAME*
}

for hostid in 1 2 3
do
    getkey $hostid
done
