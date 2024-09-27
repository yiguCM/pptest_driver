#!/bin/bash
readonly PROGPID=$(pwd)

sudo /usr/bin/nvidia-uninstall --ui=none --no-questions --accept-license
apt-get --purge remove nvidia-* -y
apt-get purge nvidia* -y 
apt-get purge libnvidia* -y

wget https://cn.download.nvidia.com/XFree86/Linux-x86_64/550.90.07/NVIDIA-Linux-x86_64-550.90.07.run
chmod 777 *
unzip ${PROGPID}/open-gpu-kernel-modules-550.90.07.zip
unzip ${PROGPID}/open-gpu-kernel-modules-550.90.07-p2p.zip

cd ${PROGPID}/open-gpu-kernel-modules-550.90.07
make modules -j$(nproc)
make modules_install -j$(nproc)
sleep 10

cd ${PROGPID}/
sh ./NVIDIA-Linux-x86_64-550.90.07.run --no-kernel-modules --no-questions --ui=none --accept-license --disable-nouveau --no-cc-version-check --install-libglvnd
sleep 10

cd ${PROGPID}/open-gpu-kernel-modules-550.90.07-p2p
bash install.sh
sleep 10
nvidia-smi -pm 1
cd ${PROGPID}/
bash dotest.sh

