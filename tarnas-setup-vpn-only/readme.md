# automatic mount

## fstab:

```
# /etc/fstab
UUID=$uuid $path          ext4   defaults,noauto,nofail,x-systemd.automount,x-systemd.device-timeout=5,x-systemd.idle-timeout=600 0 2
```

don't forget to run `systemctl daemon-reload` after ediding fstab

the above sets the disk with $uuid (found by blkid) to the $path (global)
to be automatically mounted when accessed - so whenever any program (cd, ls, w/e)
reaches to $path - it will be automounted by systemd

## udev rule

```
# /etc/udev/rules.d/99-movies-disk.rules
ACTION=="add", SUBSYSTEM=="block", ENV{ID_FS_UUID}=="$uuid", \
    RUN+="/bin/systemctl --no-block start $systemd-mount-unit" 
```

don't forget to run `udevadm control --reload` after changes to udev rules

the above automatically runs the systemd mount unit when the disk connects (same $uuid value)
you can find the $systemd-mount-unit using `systemctl list-units --type=mount`
the mount unit name is inferred from the $path in fstab

# vpn

see here how to get your vpn credentials:
https://github.com/qdm12/gluetun-wiki/blob/main/setup/providers/nordvpn.md
