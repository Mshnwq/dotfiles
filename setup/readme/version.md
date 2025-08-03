to preview

```sudo bootc upgrade --check```

# System Versioning using OSTree:

it only keeps 3 versions by default  
	- (staged)
	- (current)* 
	- (rollback) 

```
sudo rpm-ostree status
or
sudo ostree admin status
```

```sudo rpm-ostree rollback``` this is useless if i make sure to sign reboot every time

so best practice is it pin current signed version 
```sudo ostree admin pin 0```

then proceed with upgrade
```
sudo bootc switch ghcr.io/mshnwq/bazzite-hyprland-nix:latest
reboot
sudo bootc switch --enforce-container-sigpolicy ghcr.io/mshnwq/bazzite-hyprland-nix:latest
reboot
```

if issue is encounter in new upgrade revert to the pin

```sudo ostree admin deploy <CHECKSUM>``` of the pinned .0

to remove that pin
```sudo ostree admin pin --unpin 2```

# User Versioning using Home Manager:
# TODO: could be better with symlinks

to see
```home-manage generations```

to rollback
```home-manage switch --rollback```

done

