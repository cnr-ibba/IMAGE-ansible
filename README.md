IMAGE-ansible
=============

Instructions on how to setUp the wp5image web server

Set Up
------

You require a `vault_pass` in order to decrypt encrypetd information tracked in
git repository. You need also to set up a machine a provide it remote access
through SSH server (using SSH keys is strongly recommended). This project can't
handle it for you, you need to provide this requirements by your self

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
to configure ssmtp and sending mail from the server:

```
$ ansible-galaxy install andrewsomething.do-agent
$ ansible-galaxy install cleberjsantos.ansible-ssmtp
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

You may want to install all stuff with or without SSL configuration provided
using [letsencrypt](https://letsencrypt.org/) (in such case you will need a
registered domain and DNS configured to your target machine).

### Install without certificates

```
$ ansible-playbook wp5image.yml --limit production --skip-tags='letsencrypt'
```

### Install with certificates

The `letsencrypt` role relies on `image` role by adding *SSL* stuff to *NGINX*
configuration file. If you need to run the `image` role, you need to call also
the `letsencrypt` role (this is already defined in `digitalocean.yml` playbook by
setting the `image` tag on both roles). Configure the whole environment with:

```
$ ansible-playbook wp5image.yml --limit production
```

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
