# InsRP

Reverse proxy in charge of authenticating users through [fédération d'identités Education-Recherche](https://federation.renater.fr/registry?action=get_all)


Application in charge of the insermbiblio reverse proxy. The embedded shibboleth federated  authentication feature will allow users to authenticate with their individual institutionnal account.

## Configuration

1) Put the private key and the certificate used to declare the service provider in the [fédération d'identités Education-Recherche](https://federation.renater.fr/registry?action=get_all) in ``ssl/server.key`` and ``ssl/server.crt`` files.
Notice: the servier.key is critical and should not be shared.

2) If necessary, edit parameters in ``*.env.sh`` files.
Parameters example:
```bash
   export APPLI_APACHE_SERVERNAME="https://insermbiblio.inserm.fr"
   export APPLI_APACHE_SERVERADMIN="insermbiblio@inist.fr"
   export APPLI_APACHE_LOGLEVEL="info ssl:warn"
```

## Start the application

To start https://insermbiblio.inserm.fr
```bash
make run-prod
```

To start https://insermbiblio-preprod.inist.fr
```bash
make run-dev
```

## MEMO

xmlstarlet sel -N sp="urn:mace:shibboleth:2.0:native:sp:config" -t -v "/sp:SPConfig/sp:ApplicationDefaults/@entityID" shibboleth2-tmp.xml

xmlstarlet ed -N sp="urn:mace:shibboleth:2.0:native:sp:config" -u "/sp:SPConfig/sp:ApplicationDefaults/@entityID" -v aze shibboleth2-tmp.xml

Création d'un certificat auto-signé :
http://doc.ubuntu-fr.org/tutoriel/comment_creer_un_certificat_ssl

```
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr
openssl x509 -req -days 7300 -in server.csr -signkey server.key -out server.crt
```
