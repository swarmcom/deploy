Reach3 docker deployment
========================

Requirements
============

* A linux server with accessible IP address (public) able to run Docker version at least 1.9.0 (any modern would fit)
* A domain name resolving to this IP address that will serve as an UI entrance point and a SIP domain
* Installed git

Notes
=====

Setup procedure will try to automatically detect the external IP address.

Installation
============

Execute as root:

```sh
yum -y install curl
curl https://raw.githubusercontent.com/swarmcom/deploy/master/rhel-host-setup.sh > rhel-host-setup.sh
chmod +x rhel-host-setup.sh
./rhel-host-setup.sh
```

Then login as user ezuce (`su - ezuce`, for example), and do:

```sh
cd /home/ezuce/deploy
./run.sh DOMAIN
```

If you want to enable HTTPS with certificates from [LetsEncrypt](https://letsencrypt.org/):

```sh
cd /home/ezuce/deploy
USE_LE=your_le_email_address ./run.sh DOMAIN
```

If you want to provide certificates on your own, then you need to place them to /home/ezuce/keys folder named after domain (an example):

```sh
ls ~/keys/
my_fake_domain.crt
my_fake_domain.key
```

And then to use gen_conf_le.sh:
```sh
cd ~/deploy/nginx
./gen-conf-le.sh my_fake_domain > conf.d/my_fake_domain.conf
```

Upgrading
=========

To update login to server as root and then as user ezuce (`su - ezuce`, for example), and do:

```sh
cd /home/ezuce/deploy
./run.sh DOMAIN
```

