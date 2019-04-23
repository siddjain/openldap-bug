#!/bin/bash
NAME=jnj-ldap-server
LDAP_ADMIN_PASSWORD=superman
LDAP_DOMAIN=jnj.com
LDAP_TLS_CRT_FILENAME=jnj-ldap-server-tls.pem
LDAP_TLS_KEY_FILENAME=jnj-ldap-server-tls.key
LDAP_TLS_CA_CRT_FILENAME=jnj-ca-chain.pem
mkdir certs
cp $LDAP_TLS_CRT_FILENAME certs/.
cp $LDAP_TLS_KEY_FILENAME certs/.
cp $LDAP_TLS_CA_CRT_FILENAME certs/.
set -x
docker run -p 636:636 \
--name $NAME \
--volume ${PWD}/certs:/container/service/slapd/assets/certs \
--env LDAP_TLS_CRT_FILENAME=$LDAP_TLS_CRT_FILENAME \
--env LDAP_TLS_KEY_FILENAME=$LDAP_TLS_KEY_FILENAME \
--env LDAP_TLS_CA_CRT_FILENAME=$LDAP_TLS_CA_CRT_FILENAME \
--env LDAP_TLS_VERIFY_CLIENT=never \
--env LDAP_TLS_ENFORCE=true \
--env HOSTNAME=$NAME \
--env LDAP_DOMAIN=$LDAP_DOMAIN \
--env LDAP_ADMIN_PASSWORD=$LDAP_ADMIN_PASSWORD \
--env LDAP_LOG_LEVEL:1 \
--detach osixia/openldap:1.2.4 --loglevel debug --copy-service 
