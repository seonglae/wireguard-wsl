FROM ghcr.io/linuxserver/wireguard

RUN apt update

RUN apt install build-essential libncurses5-dev libssl-dev bison flex libelf-dev -y

RUN git clone https://github.com/microsoft/WSL2-Linux-Kernel -b `uname -r` --single-branch

RUN cd WSL2-Linux-Kernel  && \
  zcat /proc/config.gz > .config

RUN cd WSL2-Linux-Kernel  && \
  make -j

RUN cd WSL2-Linux-Kernel  && \
  make modules_install

RUN cd /lib/modules  && \
  mv /lib/modules/`uname -r`+ /lib/modules/`uname -r`

RUN cd WSL2-Linux-Kernel  && \
  make bindeb-pkg  && \
  cd ..  && \
  dpkg -i linux-headers-`uname -r`+_`uname -r`+-1_amd64.deb -y
