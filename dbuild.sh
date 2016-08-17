#!/bin/bash

set -e

### Setup the system
apt-get update
apt-get install -y build-essential automake autoconf libtool

cd /unixODBC

./build.sh


