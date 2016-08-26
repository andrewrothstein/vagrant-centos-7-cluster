#!/usr/bin/env bash
vagrant destroy -f
rm -rf .ansible-roles
rm -rf pki-dir/*.{pem,csr}
