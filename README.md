IMAGE-ansible
=============

Instructions on how to set up the wp5image web server

Set Up
------

You require a `vault_pass` in order to decrypt encrypetd information tracked in
git repository. You need also to set up a machine and provide a remote access
through SSH server (using SSH keys is strongly recommended). This project can't
handle it for you, you need to provide this requirements by yourself

All these instructions are referred to a [digitalocean](https://cloud.digitalocean.com)
docker image instance and they are optimized in such environment

Instantiate the testing machine
-------------------------------

To set up the testing machine, you need to export your DigitalOcan token in the
`DIGITALOCEAN_ACCESS_TOKEN`. Then call

```
$ python scripts/create_droplet.py
```

You need to configure your `DNS` and set up those domains to point to the created droplet:

```
test.wp5image.eu
injecttest.wp5image.eu
apitest.image2020genebank.eu
test.image2020genebank.eu
injecttest.image2020genebank.eu
```

### The inventory file

Currently there are two groups configured in inventory files (*production* and *testing*),
they are defined using *DNS*, so you need to update your *DNS* records if you
need to change the ip adresses of such machines. `production.yml` and `testing.yml`
are the two playbook that are applied respectively to the two groups

### Install role dependencies

You need [do agent](https://galaxy.ansible.com/andrewsomething/do-agent) 3rd party
module in order to install into the monitoring tools in your *droplet*. You need also
a [ssmtp](https://galaxy.ansible.com/cleberjsantos/ansible-ssmtp) role in order
to configure ssmtp and sending mail from the server and
[geerlingguy.nodejs](https://galaxy.ansible.com/geerlingguy/nodejs). Those
modules are already in the local `./galaxy_roles` path and are configure already
in `ansible.cfg`. If you need to install a new role, please add it into `./galaxy_roles`
path and then track it into git

```
$ ansible-galaxy install --roles-path ./galaxy_roles/ <a new role>
```

### test connection to host

To execute a generic command, call `ansible` + `<pattern>` + `-m <module>`, for
example, in order to testing hosts:

```
$ ansible all -m ping
$ ansible testing -m ping
```

You can also pass additional arguments to modules, if they support them:

```
$ ansible all -m command -a "hostname"
```

The `-m command` is a default option, so the following syntax have the same effects
of the previous:

```
$ ansible all -a "hostname"
```

### Upgrade system

Upgrade package version and restart server using playboooks (they rely on
`digitalocean.yml` config file)

```
$ ansible-playbook --limit production playbooks/upgrade.yml
$ ansible-playbook --limit production playbooks/restart.yml
```

### Configure ssmtp

You can configure *ssmtp* to send mail using an external email address. This is
configured for the production servers:

```
$ ansible-playbook --limit production playbooks/ssmtp.yml
```

Install all stuff
-----------------

You may want to install all stuff with self-signed certificates or with SSL configuration provided
by [letsencrypt](https://letsencrypt.org/) (in such case you will need a
registered domain and DNS configured to your target machine).

### Install with custom certificates

Override the default `image` vars by setting your certificate location paths, for example
in `group_vars/all/vars` file:

```
# letsencrypt certificate files
ssl_certificate: /etc/letsencrypt/live/image2020genebank.eu/fullchain.pem
ssl_certificate_key: /etc/letsencrypt/live/image2020genebank.eu/privkey.pem
ssl_options: /etc/letsencrypt/options-ssl-nginx.conf
ssl_dhparam: /etc/letsencrypt/ssl-dhparams.pem
old_domain_ssl_certificate: /etc/letsencrypt/live/wp5image.eu/fullchain.pem
old_domain_ssl_certificate_key: /etc/letsencrypt/live/wp5image.eu/privkey.pem
```

These files are not provided by ansible, you will need to set up letsencrypt before.

### Other useful commands:

```
# check roles without modification
$ ansible-playbook wp5image.yml --limit production --check
# list available tags (refer to digitalocean.yml)
$ ansible-playbook wp5image.yml --limit production --list-tags
# install only a tag
$ ansible-playbook wp5image.yml --limit production --tags injecttool
# update image NGINX configuration on testing environment, without set SSL stuff
$ ansible-playbook wp5image.yml --limit testing --tags='image-configure'
```

# Manage certificates

Please follow this [tutorial](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-18-04)
to configure certbot. Then follow this [guide](https://certbot-dns-digitalocean.readthedocs.io/en/stable/)
to uptain a wildcard certificate with digitalocean. Ideally there should be only
a master server that renew the certificate. If you have subdomains in other machines,
you will need to copy certificates in order to not hit the letsencrypt limit when
renewing certificates from all machines

Configure and start WP5 services
--------------------------------

Please refer to [IMAGE-InjectTool](https://github.com/cnr-ibba/IMAGE-InjectTool),
[IMAGE-CommonDataPool](https://github.com/cnr-ibba/IMAGE-CommonDataPool) and
[IMAGE-Portal](https://github.com/cnr-ibba/IMAGE-Portal) documentation
