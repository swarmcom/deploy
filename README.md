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

Clone this repo to the target host, and execute as root:

```sh
./rhel-host-setup.sh
```

Then login as user ezuce, and do:

```sh
cd deploy
./run.sh DOMAIN
```
