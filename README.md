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

### Upgrade system

Upgrade package version and restart server using playboooks (they rely on
`digitalocean.yml` config file)

```
$ ansible-playbook playbooks/upgrade.yml
$ ansible-playbook playbooks/restart.yml
```

### Install role dependencies

You need [do agent](https://galaxy.ansible.com/andrewsomething/do-agent) 3rd party
module in order to install into the monitoring tools in your *droplet*

```
$ ansible-galaxy install andrewsomething.do-agent
```

Install all stuff
-----------------

You may want to install all stuff with or without SSL configuration provided
using [letsencrypt](https://letsencrypt.org/) (in such case you will need a
registered domain and DNS configured to your target machine)

### Install without certificates

```
$ ansible-playbook digitalocean.yml --skip-tags='letsencrypt'
```

### Install with certificates

```
$ ansible-playbook digitalocean.yml
```

### Other useful commands:

```
# check roles without modification
$ ansible-playbook digitalocean.yml --check
# list available tags (refer to digitalocean.yml)
$ ansible-playbook digitalocean.yml --list-tags
# install only a tag
$ ansible-playbook digitalocean.yml --tags injecttool
```

Configure and start WP5 services
--------------------------------

Please refer to [IMAGE-InjectTool](https://github.com/cnr-ibba/IMAGE-InjectTool),
[IMAGE-CommonDataPool](https://github.com/cnr-ibba/IMAGE-CommonDataPool) and
[IMAGE-Portal](https://github.com/cnr-ibba/IMAGE-Portal) documentation
