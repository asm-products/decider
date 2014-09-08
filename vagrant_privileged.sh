#!/bin/bash
set -e

echo '>>> UPDATE APT'
apt-get update

echo '>>> INSTALL USEFUL TOOLS'
apt-get -y install git curl

echo '>>> INSTALL LIBS FOR COMPILATION'
apt-get -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev qt4-qmake libqtwebkit-dev libcurl4-openssl-dev libpq-dev

echo '>>> INSTALL POSTGRES AND ADD "vagrant" USER IF IT DOES NOT ALREADY EXIST'
apt-get -y install postgresql-9.1
sudo -u postgres psql postgres -tAc "select rolname from pg_roles where rolname='vagrant'" | grep -c vagrant || sudo -u postgres createuser --superuser vagrant
