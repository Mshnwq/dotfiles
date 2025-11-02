toolbox create --yes
toolbox enter --no-tty -- bash -c '
  sudo dnf install -y gcc make zlib-devel bzip2 bzip2-devel libffi-devel \
    xz-devel wget curl llvm ncurses-devel tk-devel sqlite-devel \
    gdbm-devel libnsl2-devel libuuid-devel readline-devel \
    openssl-devel
' 2>&1 | systemd-cat
podman stop "$(podman ps -q)"
