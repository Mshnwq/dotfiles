https://starbeamrainbowlabs.com/blog/article.php?article=posts%2F441-resize-luks-lvm.html

check notebook

- use custom option:
	- checkmark encrypt 
	- click auto generate
	# if it mount /boot/efi of another partition do not use
	# instead remove and an create new partition for it
	# in order to do that since auto generate filled all 
	# empty space must resize the btrf (/ /var /home) down
	# by ~1Gib use XXXGiB format. 
	# now create new partion /boot/efi ~1GiB type EFI !
	#
	# in the end three new partitions will be created.
	# XXXGiB BTRFS -> / /var /home
	#   1GiB fat   -> /boot
	#  ~1GiB efi   -> /boot/efi
	# 
	# after done old oses should be picked up by os-prober
	# of new os GRUB will be at the new efi partition
	# dont forget set BIOS boot order to it if old is pinned
