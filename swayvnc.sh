#!/bin/sh

export RESOLUTION="1600x900"
export VNC=true
export VNC_ENABLE_AUTH=false
export VNC_PASSWORD="P@ssw0rd"
export VNC_ADDRESS="0.0.0.0"
export DOCKER_CMD="$@"
export SWAYSOCK="/tmp/sway-ipc.sock"
export WLR_BACKENDS="headless"
export WLR_LIBINPUT_NO_DEVICES=1
export XDG_RUNTIME_DIR="/tmp"
mkdir -p $HOME/.config/wayvnc
printf "
address=$VNC_ADDRESS
enable_auth=$VNC_ENABLE_AUTH
username=$USER
password=$VNC_PASSWORD
private_key_file=$HOME/key.pem
certificate_file=$HOME/cert.pem" > $HOME/.config/wayvnc/config
exec sway
