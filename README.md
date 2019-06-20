# A simple DokuWiki container

[![Docker Repository on Quay](https://quay.io/repository/tag1consulting/dokuwiki/status?token=5cae1a99-7add-4449-83f5-cf1880507a64 "Docker Repository on Quay")](https://quay.io/repository/tag1consulting/dokuwiki)

A simple starting point for hosting DokuWiki in a container.

## Installation

Clone this repository, cd into the dokuwiki-container directory, and then run
the following commands:
```
docker-compose build && docker-compose up
```

Then visit the following URL to configure the wiki:
	http://localhost:8080/install.php

To ssh into the container, use the following command:
```
	docker exec -it dokuwiki ash
```

## DokuWiki

For full details, visit https://www.dokuwiki.org/dokuwiki

>  DokuWiki is a simple to use and highly versatile Open Source wiki software that doesn't require a database. It is loved by users for its clean and readable syntax. The ease of maintenance, backup and integration makes it an administrator's favorite. Built in access controls and authentication connectors make DokuWiki especially useful in the enterprise context and the large number of plugins contributed by its vibrant community allow for a broad range of use cases beyond a traditional wiki.

## Customizations

The base container starts with the Centos 7 distribution, adding Apache and
all PHP requirements along with DokuWiki.

### DokuWiki version

Edit the DOKUWIKI_INSTALL variable at the top of Dockerfile to install a
different version of DokuWiki.

### Extensions

You can comment out the line in Dockerfile that installs `php7-curl` and
`php7-openssl` if you do not want to install extensions through the DokuWiki
administrative Extension Manager. Extensions can still be installed manually.

### Listening port (default: 80)

To change which port Apache listens on, edit `app/apache.conf` changing:
```
	<VirtualHost *:80>
```
from `80` to your desired port. Then, also edit the `EXPOSE` toward the end of
Dockerfile, again changing `808 to your new port.

## TODO
 - install/enable some plugins
 - configure email
