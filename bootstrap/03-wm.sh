#!/bin/bash -eux

echo ">>>> bootstrap.sh: Installing Xorg.."
pacman -Sy --noconfirm xorg \
       xorg-server-xwayland xorg-server-common \
       xorg-server xorg-xinit \
       xf86-video-fbdev xf86-video-vesa \
       xorg-xrandr

echo ">>>> bootstrap.sh: Installing i3.."
pacman -Sy --noconfirm i3-wm

echo ">>>> bootstrap.sh: Installing i3 dependancy, dejavu font.."
pacman -S --noconfirm ttf-dejavu # i3 dependancy

echo ">>>> bootstrap.sh: Installing Fira Code font.."
pacman -Sy --noconfirm ttf-fira-code
fc-cache -f -v

echo ">>>> bootstrap.sh: Installing i3 utils.."
pacman -Sy --noconfirm i3blocks picom scrot imagemagick \
                       rxvt-unicode rofi ranger \

echo ">>>> bootstrap.sh: Installing i3 utils via yay.."
sudo -u $USER yay -S --noconfirm betterlockscreen-git
sudo -u $USER yay -S --noconfirm urxvt-font-size-git

echo ">>>> bootstrap.sh: Creating file /etc/X11/xorg.conf.d.."
XORG_DIR="/etc/X11/xorg.conf.d"
if [ -d "$XORG_DIR" ]; then
  echo "${XORG_DIR} found, setting screen resolution.."
else
  echo "${XORG_DIR} not found, creating, and setting screen resolution.."
  mkdir -p $XORG_DIR
fi

echo ">>>> bootstrap.sh: Creating file /etc/X11/10-set-screen.conf.."
cat > $XORG_DIR/10-set-screen.conf <<EOF
Section "Screen"
	Identifier	"DisplayPort-0"
	# Modeline        "3840x2160_60.00"  108.88  3840 1920 1280 1360 1496 1712  2160 1080 1024 1025 1028 1060  -HSync +Vsync
  # Option          "PreferredMode" "3840x2160_60.00"
	Option		"Primary" "true"
EndSection
EOF

echo ">>>> bootstrap.sh: Setting URXVT extension path.."
mkdir -p /home/$USER/.urxvt/ext
cp -r /usr/lib/urxvt/perl/* /home/$USER/.urxvt/ext/