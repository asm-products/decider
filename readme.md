# Decisions

## Vagrant

Experimenting with using Vagrant. To get started:

  * download Vagrant: http://www.vagrantup.com/downloads.html
  * in this project's root directory, type `vagrant up` (can take 10 minutes when run the first time)

Notes:
  * to ssh to the Vagrant box, type `vagrant ssh`
  * the Vagrant box's IP address is 10.0.50.50
  * Vagrant is configured to forward port 3000 on the host machine (your Mac) to port 3000 on the guest machine (Vagrant)
  * the Vagrant box is configured with the `/vagrant.sh` and `/vagrant_privileged.sh` scripts in this repo

Limitations:
  * you current cannot connect directly to the database running on the Vagrant box

## Vagrant + RubyMine

To get Vagrant set up in RubyMine, make sure you get RubyMine 7 (the EAP version). Then:

  * Go to Settings > Languages and Frameworks > Ruby SDK and Gems
  * Click the "+" button and add a new remote SDK
  * Choose "Vagrant"
  * Use "/home/vagrant/.rbenv/versions/2.1.2/bin/ruby" for the Ruby interpreter path

You should be able to run tests as you normally do, plus you can run the server from the run configurations.

## What The Heck Are These Flows?

These are experiemntal. The jury is still out. The idea is that they encapsulate everything needed to support a
single workflow, such as proposing. Most of the logic that would otherwise be in a controller or model lives in
the flows.

## Heroku

  * git remote: `git@heroku.citizencode:cc-decisions.git`
  * site: `http://cc-decisions.herokuapp.com/`
