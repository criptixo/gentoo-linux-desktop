<h1 align="center">criptixo/dotfiles</h1>

<img src="/screenshots/screenshot1.png" width="100%" />
<img src="/screenshots/screenshot2.png" width="100%" />
<img src="/screenshots/screenshot3.png" width="100%" />


This is where I keep all of my system dotfiles.




## Theme & Colorscheme

- GTK Theme: [placeholder](placeholder)
- Colorscheme: [placeholder](placeholder)
- Icons :[placeholder](placeholder)
- Font: [Terminus](https://terminus-font.sourceforge.net/)
- I don't use any QT theme because the only qt6 build software that i currently use is qutebrowser and OBS-Studio.
- I don't use any custom curosr.


## Software

- Operating System: [Arch Linux](https://archlinux.org/)
- Window Manager: [Sway](https://github.com/swaywm/sway)
- Status Bar: [sway-bar](https://github.com/swaywm/sway)
- Terminal: [foot](https://codeberg.org/dnkl/foot)
- Launcher: [tofi](https://github.com/philj56/tofi)
- Browser: [qutebrowser](https://github.com/qutebrowser/qutebrowser)
- File Manager: [ranger](https://github.com/gokcehan/lf)
- Notifications: [mako](https://github.com/emersion/mako)
- Video Player: [mpv](https://github.com/mpv-player/mpv)
- Music Player: [rhythmbox](https://gitlab.gnome.org/GNOME/rhythmbox)
- BitTorrent: [transmission](https://github.com/transmission/transmission)
- Video Editor: [Pitivi](https://github.com/pitivi/pitivi)

## My Arch Linux System

## paritioning
lsblk
cfidsk /dev/sda
<img src="/screenshots/lsblk.png" width="100%" />

## setup lvm 
pvcreate /dev/sda2
vgcreate vg0 /dev/sda2
lvcreate -l 100%FREE -n cryptroot vg0

## setup luks
cryptsetup luksFormat /dev/vg0/cryptroot
cryptsetup open /dev/vg0/cryptroot root
        
## formatting
mkfs.fat -F32 /dev/sda1                    
mkfs.ext4 /dev/mapper/root

## mounting
mount /dev/mapper/root /mnt
mount /dev/sda1 /mnt/boot
                    
## setting up the chroot
pacstrap -K /mnt base linux linux-firmware intel-ucode lvm2 dhcpcd neovim man bash
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

## basic system setup
ln -sf /usr/share/Africa/Algeries
hwclock --systohc
locale-gen
nvim /etc/locale.conf
nvim /etc/hostname
passwd

## setup mkinitcpio
nvim /etc/mkinitcpio.conf
```
...
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block lvm2 encrypt filesystems fsck)
...
COMPRESSION=cat       
...
```
mkinitcpio -P

## bootloader setup
bootctl install
nvim /boot/loader/loader.conf
```
default arch.conf
timeout 0
```

nvim /boot/loader/entries/arch.conf
```
title arch
linux /vmlinuz-linux
initrd /initramfs-linux.img
options cryptdevice=/dev/vg0/root:root root=/dev/mapper/root rw quiet loglevel=3 vt.global_cursor_default=0 mitigations=off
```
                
nvim /boot/loader/entries/arch-fallback.conf
```
title arch
linux /vmlinuz-linux
initrd /initramfs-linux.img
options cryptdevice=/dev/vg0/root:root root=/dev/mapper/root rw quiet loglevel=3 vt.global_cursor_default=0 mitigations=off
```

nvim /etc/fstab
```
/dev/mapper/root				/         	ext4      	rw,relatime						0 1
UUID=UUID      				/boot      	vfat      	rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro	0 2
#/swapfile 					none 		swap 		defaults						      0 0
```
            
## reboot
login as root

## enble dhcpcd to get internet                    
systemctl enable --now dhcpcd.service

## create a user
useradd -m -G wheel video audio -s bash criptixo
passwd criptixo

## configure pacman.conf
nvim /etc/pacman.conf
```
...
Color
...
ParallelDownloads = 5
...
[multilib]
Include = /etc/pacman.d/mirrorlist
...
```
## login as user
exit

## install the software
run0 pacman -S sway polkit swaybg grim mako foot terminus-font slurp playerctl xdg-desktop-portal xdg-portal-wlr mate-polkit cliphist gnome-themes-extra xdg-user-dirs xorg-xwayland

## starting sway                    
run0 nvim /usr/local/start-sway
```
#!/bin/sh
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=sway
export XDG_CURRENT_DESKTOP=sway
                    
# Wayland stuff
export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
                    
# Dark mode
GTK_THEME=Adwaita:dark
GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc 
QT_STYLE_OVERRIDE=Adwaita-Dark
                    
exec sway "$@"
```
## configuring auto-start
run0 chmod +x /usr/local/bin/start-sway 
pacman -S greetd
run0 sudo nvim /etc/greetd/config.toml
```
...
[initial_session]
command = "/usr/local/bin/start-sway"
user = "criptixo"
```
## adding the user dotfiles
run0 pacman -S git
git clone https://github.com/criptixo/dotfiles
mkdir .config
mv dotfiles/.config/* ~/.config/
                    
## application launcher
run0 pacman -S base-devel
cd
git clone https://aur.archlinux.org/packages/tofi
cd tofi
run0 makepkg -si 
                    
### audio 
                    
run0 pacman -S wireplumber pipewire pipewire-pulse pipewire-audio pipewire-jack helvum pavucontrol
systemctl --user enable --now pipewire-pulse.socket
                    
### video player
run0 pacman -S mpv 
                    
### music player 
run0 pacman -S rhythmbox

### screen recorder 
run0 pacman -S obs-studio
                    
### gaming 
run0 pacman -S vulkan-radeon lib32-vulkan-radeon radeontop xf86-video-amdgpu steam
                    
### web browsing 
run0 pacman -S qutebrowser
                    
### torrenting 
run0 pacman -S transmission-gtk
                    
### music
run0 pacman -S nicotine
                    
### video editing 
run0 pacman -S pitivi
                    
### image editing 
run0 pacman -S gimp
                    
### docker 
run0 pacman -S docker 
run0 systemctl enable docker.socket
run0 usermod -aG docker criptixo
run0 chmod 666 /var/run/docker.sock