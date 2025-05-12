#!/data/data/com.termux/files/bin/bash
echo "Bem-Vindo A Instalação do Ubuntu 25.04 Com XFCE"
pkg update
pkg install -y proot-distro
cat > $PREFIX/etc/proot-distro/ubuntu25.sh <<EOF
DISTRO_NAME="Ubuntu (25.04)"
TARBALL_URL['aarch64']="https://cdimage.ubuntu.com/ubuntu-base/releases/plucky/release/ubuntu-base-25.04-base-arm64.tar.gz"
TARBALL_SHA256['aarch64']="cb5c935ce84620a6c6df3e4dc93d9bf67324b03da7f0df89fd1794cc45193952"
TARBALL_STRIP_OPT=0
EOF
proot-distro install ubuntu25
proot-distro login ubuntu25  # Removido --isolated
apt update
apt --fix-broken install # Adicionado para corrigir dependências
apt install lightdm -y   # Adicionado display manager explicitamente
apt install xubuntu-desktop -y
apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.chromium.Chromium
apt install tigervnc-standalone-server
mkdir -p ~/.vnc
cat > ~/.vnc/config <<EOF
securitytypes=vncauth
passwordfile=$HOME/.vnc/passwd  # Alterado para $HOME
geometry=1280x720  # Defina a resolução desejada
localhost=no       # Permite conexões de fora do Termux
EOF
vncpasswd -file ~/.vnc/passwd
cat > ~/.vnc/xstartup <<EOF
#!/bin/sh
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
startxfce4  # Inicia o XFCE
EOF
chmod +x ~/.vnc/xstartup

echo "Para Iniciar o VNC, execute:"
echo "vncserver -rfbconfig ~/.vnc/config"
