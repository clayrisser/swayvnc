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

curl -L https://gitlab.com/bitspur/community/swayvnc/-/raw/${VERSION}/swayvnc.sh | sudo tee /usr/local/bin/swayvnc >/dev/null
sudo chmod +x /usr/local/bin/swayvnc

sudo useradd -m $USERNAME
(echo "$PASSWORD"; echo "$PASSWORD") | sudo passwd $USERNAME
sudo /sbin/usermod -aG sudo $USERNAME

WAYVNC_CONFIG=/home/$USERNAME/.config/wayvnc
SWAY_CONFIG=/home/$USERNAME/.config/sway
sudo -u $USERNAME mkdir -p $WAYVNC_CONFIG
sudo -u $USERNAME mkdir -p $SWAY_CONFIG
sudo -u $USERNAME openssl req -x509 -newkey rsa:4096 -sha256 -days 999999 -nodes \
    -keyout $WAYVNC_CONFIG/key.pem -out $WAYVNC_CONFIG/cert.pem -subj /CN=localhost \
    -addext subjectAltName=DNS:localhost,DNS:localhost,IP:127.0.0.1
cat /etc/sway/config > $SWAY_CONFIG/config
sudo touch /var/log/wayvnc.log
sudo chmod 666 /var/log/wayvnc.log
cat <<EOF >> $SWAY_CONFIG/config
exec sh -c "[ \"\$VNC\" != \"false\" ] && wayvnc -C \$HOME/.config/wayvnc/config -L debug 2>&1 >/var/log/wayvnc.log || true"
exec swaymsg output "HEADLESS-1" resolution "\$RESOLUTION"
EOF
chown -R $USERNAME:$USERNAME $WAYVNC_CONFIG
chown -R $USERNAME:$USERNAME $SWAY_CONFIG

cat <<EOF > /etc/systemd/system/swayvnc.service
[Unit]
Description=SwayVNC Service
After=network.target

[Service]
User=swayvnc
ExecStart=/usr/local/bin/swayvnc
Environment="RESOLUTION=${RESOLUTION:-1600x900}"
Environment="VNC_ENABLE_AUTH=${VNC_ENABLE_AUTH:-false}"
Environment="VNC_PASSWORD=${VNC_PASSWORD:-P@ssw0rd}"
Restart=always

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable swayvnc
sudo systemctl start swayvnc
