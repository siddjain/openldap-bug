This document decribes a bug with OpenLDAP. Repro steps:
1. Clone the repository
2. Run `jnj-ldap-server.sh`
3. Run 
```
$ openssl s_client -connect localhost:636 -state -nbio -CAfile jnj-ca-chain.pem -showcerts
```

Expected:
no error

Observed:
Verify return code: 7 (certificate signature failure)

Reason:
The TLS certificate returned to the client is different from the one provided to the server. The TLS certificate returned to the client can be seen in output of `openssl s_client` and is saved as `cert_returned_by_openldap.pem`. It can be diff'ed against the original certificate to see the difference.

```
WITSC02X6385JGH:temp sjain68$ openssl x509 -in jnj-ldap-server-tls.pem -text -noout > jnj-ldap-server-tls.txt
WITSC02X6385JGH:temp sjain68$ openssl x509 -in cert_returned_by_openldap.pem -text -noout > cert_returned_by_openldap.txt
WITSC02X6385JGH:temp sjain68$ diff jnj-ldap-server-tls.txt cert_returned_by_openldap.txt
7c7
<         Issuer: C=US, ST=WA, L=Bellevue, O=Johnson & Johnson, OU=client, OU=jnj, CN=rca-jnj-admin
---
>         Issuer: C=US, ST=WA, L=Bellevue, O=Johnson & Johnson, OU=jnj, OU=client, CN=rca-jnj-admin
11c11
<         Subject: C=US, ST=WA, L=Bellevue, O=Johnson & Johnson, OU=client, OU=jnj, CN=jnj-ldap-server
---
>         Subject: C=US, ST=WA, L=Bellevue, O=Johnson & Johnson, OU=jnj, OU=client, CN=jnj-ldap-server
```
