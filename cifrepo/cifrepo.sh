#!/bin/bash
#
#
#
cd /home/v2pc/
echo "extracting cif.repo.tgz to /home/v2pc/cif/"
tar xzvf cif.repo.tgz
echo "creating link in v2pc repo"
ln -s /home/v2pc/cif /var/www/html/cisco/cif
echo "checking yum repo image"
curl localhost:/cisco/cif/|grep fuse-convmvfs && echo "image posted" || echo "Check link"

