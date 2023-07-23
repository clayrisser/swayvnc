#!/bin/sh

VERSION=${VERSION:-main}
USERNAME=${USERNAME:-swayvnc}
PASSWORD=${PASSWORD:-pass}

sudo true
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
    x11-xserver-utils \
    xauth \
    xinit
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

curl -L https://gitlab.com/bitspur/community/swayvnc/-/raw/${VERSION}/swayvnc.sh | sudo tee /usr/local/bin/swayvnc
sudo chmod +x /usr/local/bin/swayvnc

sudo useradd -m $USERNAME
(echo "$PASSWORD"; echo "$PASSWORD") | sudo passwd $USERNAME

WAYVNC_CONFIG=/home/$USERNAME/.config/wayvnc
sudo -u $USERNAME mkdir -p $WAYVNC_CONFIG
sudo -u $USERNAME openssl req -x509 -newkey rsa:4096 -sha256 -days 999999 -nodes \
    -keyout $WAYVNC_CONFIG/key.pem -out $WAYVNC_CONFIG/cert.pem -subj /CN=localhost \
    -addext subjectAltName=DNS:localhost,DNS:localhost,IP:127.0.0.1
cat <<EOF
exec sh -c "[ \"\$VNC\" != \"false\" ] && wayvnc -C $WAYVNC_CONFIG/config || true"
exec swaymsg output "HEADLESS-1" resolution "\$RESOLUTION"
EOF
