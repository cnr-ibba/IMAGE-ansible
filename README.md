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

### The inventory file

Currently there are two machines configured in inventory files (*production* and *testing*),
they are defined using *DNS*, so you need to update your *DNS* records if you
need to change the ip adresses of such machines. The default group
is `digitalocean`, but you could apply the configuration to a particoular
server providing `--limit` option and calling one of *production* and *testing*
host.

### Install role dependencies

You need [do agent](https://galaxy.ansible.com/andrewsomething/do-agent) 3rd party
module in order to install into the monitoring tools in your *droplet*

```
$ ansible-galaxy install andrewsomething.do-agent
$ ansible-galaxy install cleberjsantos.ansible-ssmtp
```

### Upgrade system

Upgrade package version and restart server using playboooks (they rely on
`digitalocean.yml` config file)

```
$ ansible-playbook --limit production playbooks/upgrade.yml
$ ansible-playbook --limit production playbooks/restart.yml
```

### Configure ssmtp

You can configure *ssmtp* to send mail using an external email address:

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
$ ansible-playbook --limit testing digitalocean.yml --skip-tags='letsencrypt'
```

### Install with certificates

The `letsencrypt` role relies on `image` role by adding *SSL* stuff to *NGINX*
configuration file. If you need to run the `image` role, you need to call also
the `letsencrypt` role (this is already defined in `digitalocean.yml` playbook by
setting the `image` tag on both roles). Configure the whole environment with:

```
$ ansible-playbook --limit production digitalocean.yml
```

### Other useful commands:

```
# check roles without modification
$ ansible-playbook --limit production digitalocean.yml --check
# list available tags (refer to digitalocean.yml)
$ ansible-playbook digitalocean.yml --list-tags
# install only a tag on both hosts
$ ansible-playbook digitalocean.yml --tags injecttool
# update image NGINX configuration on testing environment, without set SSL stuff
$ ansible-playbook digitalocean.yml --limit testing --skip-tags='letsencrypt' --tags='image-configure'
```

Configure and start WP5 services
--------------------------------

Please refer to [IMAGE-InjectTool](https://github.com/cnr-ibba/IMAGE-InjectTool),
[IMAGE-CommonDataPool](https://github.com/cnr-ibba/IMAGE-CommonDataPool) and
[IMAGE-Portal](https://github.com/cnr-ibba/IMAGE-Portal) documentation
