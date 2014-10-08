#!/usr/bin/env bash

apt-get update

# Install git
apt-get install -y build-essential git-core

# Install Ruby
\curl -sSL https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm install 2.1