#!/bin/bash

set -eu -o pipefail

# install build deps
add-apt-repository ppa:ethereum/ethereum
apt-get update
apt-get install -y build-essential unzip libdb-dev libsodium-dev zlib1g-dev libtinfo-dev solc sysvbanner wrk

# install constellation
wget -q https://github.com/jpmorganchase/constellation/releases/download/v0.0.1-alpha/ubuntu1604.zip
unzip ubuntu1604.zip
cp ubuntu1604/constellation-node /usr/local/bin && chmod 0755 /usr/local/bin/constellation-node
cp ubuntu1604/constellation-enclave-keygen /usr/local/bin && chmod 0755 /usr/local/bin/constellation-enclave-keygen
rm -rf ubuntu1604.zip ubuntu1604

# install golang
GOREL=go1.7.3.linux-amd64.tar.gz
wget -q https://storage.googleapis.com/golang/$GOREL
tar xfz $GOREL
mv go /usr/local/go
rm -f $GOREL
PATH=$PATH:/usr/local/go/bin
echo 'PATH=$PATH:/usr/local/go/bin' >> /home/ubuntu/.bashrc

# ZSL START
# During the development phase, there is no public access to the repository
# so we compile geth and bootnode locally and place them in the /vagrant
# shared folder which the VM can access.

# make/install quorum
# git clone https://github.com/getamis/quorum.git
# pushd quorum >/dev/null
# git checkout feature/istanbul
# make all
# cp build/bin/geth /usr/local/bin
# cp build/bin/bootnode /usr/local/bin
# popd >/dev/null

echo 'Copying geth and bootnode from /vagrant/zsl-tmp into the VM /usr/local/bin'
cp /vagrant/zsl-tmp/geth /usr/local/bin
cp /vagrant/zsl-tmp/bootnode /usr/local/bin
mkdir /home/ubuntu/quorum
#ZSL END

# install Porosity
wget -q https://github.com/jpmorganchase/quorum/releases/download/v1.2.0/porosity
mv porosity /usr/local/bin && chmod 0755 /usr/local/bin/porosity

# copy examples
cp -r /vagrant/examples /home/ubuntu/quorum-examples
chown -R ubuntu:ubuntu /home/ubuntu/quorum /home/ubuntu/quorum-examples

# done!
banner "Quorum"
echo
echo 'The Quorum vagrant instance has been provisioned. Examples are available in ~/quorum-examples inside the instance.'
echo "Use 'vagrant ssh' to open a terminal, 'vagrant suspend' to stop the instance, and 'vagrant destroy' to remove it."
