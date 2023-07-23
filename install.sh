#!/bin/sh

sudo true
cd $HOME
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    x11-xserver-utils \
    xauth \
    xinit && \
    apt-get install -y \
    curl \
    dbus-x11 \
    j4-dmenu-desktop \
    libxv1 \
    locales \
    mesa-utils \
    mesa-utils-extra \
    openssl \
    procps \
    psmisc \
    sway \
    wayvnc \
    xwayland

curl -L https://gitlab.com/bitspur/community/swayvnc/-/raw/main/swayvnc.sh | sudo tee /usr/local/bin/swayvnc
sudo chmod +x /usr/local/bin/swayvnc

sudo useradd -m admin
sudo passwd admin

openssl req -x509 -newkey rsa:4096 -sha256 -days 999999 -nodes \
    -keyout key.pem -out cert.pem -subj /CN=localhost \
    -addext subjectAltName=DNS:localhost,DNS:localhost,IP:127.0.0.1
