

apk add alpine-sdk

adduser -D builder \
&& echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

su builder

git config --global user.name "Israel Conesa Lerma"
git config --global user.email "israelconesa@gmail.com"

cd /home/builder

git clone git://git.alpinelinux.org/aports

sudo sed -i \
's/#PACKAGER="Your Name <your@email.address>"/PACKAGER="Israel Conesa Lerma <israelconesa@gmail.com>"/g' \
/etc/abuild.conf

sudo sed -i \
's/#MAINTAINER="$PACKAGER"/MAINTAINER="$PACKAGER"/g' \
/etc/abuild.conf

sudo addgroup builder abuild

sudo mkdir -p /var/cache/distfiles
sudo chmod a+w /var/cache/distfiles

abuild-keygen -a -i -n
