#!/bin/sh

USERNAME=${USERNAME:-swayvnc}
export RESOLUTION=${RESOLUTION:-1600x900}
export VNC_ENABLE_AUTH=${VNC_ENABLE_AUTH:-true}
export VNC_PASSWORD=${VNC_PASSWORD:-P@ssw0rd}
export VNC_PORT=${VNC_PORT:-5900}
export VNC_ADDRESS="0.0.0.0"
export SWAYSOCK="/tmp/sway-ipc.sock"
export WLR_BACKENDS="headless"
export WLR_LIBINPUT_NO_DEVICES=1
export XDG_RUNTIME_DIR="/tmp"

if [ "$USER" != "$USERNAME" ]; then
  echo "The current user ($USER) does not match the target user ($USERNAME). Re-running with sudo -u $USERNAME..."
  sudo -u $USERNAME -E -u HOME "$0" "$@"
  exit $?
fi

WAYVNC_CONFIG=$HOME/.config/wayvnc
mkdir -p $WAYVNC_CONFIG
cat <<EOF > $WAYVNC_CONFIG/config
address=$VNC_ADDRESS
port=$VNC_PORT
enable_auth=$VNC_ENABLE_AUTH
username=$USER
password=$VNC_PASSWORD
private_key_file=\$HOME/.config/wayvnc/key.pem
certificate_file=\$HOME/.config/wayvnc/cert.pem
EOF
exec sway
