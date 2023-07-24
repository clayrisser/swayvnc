# swayvnc

> install and run sway in the cloud and connect with a vnc client

## Install

```sh
curl -L https://gitlab.com/bitspur/community/swayvnc/-/raw/main/install.sh | sudo sh
```

## Usage

### Service

```sh
sudo systemctl status swayvnc
```

### CLI

```sh
sudo swayvnc # starts sway with a vnc server
```

Connect with a vnc client at <IP_ADDRESS>:5900

## Recommended Clients

### Linux

- [Gnome Connections](https://apps.gnome.org/app/org.gnome.Connections)
- [Remmina](https://remmina.org)

### Windows
- [TightVNC Client](https://www.tightvnc.com)
- [TigerVNC Client](https://tigervnc.org)

### OSX
- [TightVNC Client](https://www.tightvnc.com)
- [TigerVNC Client](https://tigervnc.org)
