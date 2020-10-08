#!/bin/bash
# 1 = username
# 2 = uid
# 3 = groupname
# 4 = gid
# 5 = proj
# 6 = dockerid

if [ "$1" == "--help" ]; then
  echo 'How to use:'
  echo '  docker run -it --network="host" --hostname="devenv:${IMG}" -v "${DIR}:${DIR}" -v /var/run/docker.sock:/var/run/docker.sock -v "${HOME}/.ssh:/_ssh" -v "${HOME}/.kube:/_kube" -v "${HOME}/.local/share/direnv:/_direnv" fulsome/devenv:"$IMG" "$(id -un)" "$(id -u)" "$(id -gn)" "$(id -g)" "${DIR}" "$(getent group docker | cut -d: -f3)"'
  echo
  echo 'Recommended values to define are:'
  echo '  IMG="latest"'
  echo '  DIR="$(pwd)"'

  exit 0
fi

# Rearange perms to fit the outside world
usermod -l "$1" dock
mkdir -p /home/"$1"
mv -n /home/dock/* /home/dock/.* /home/"$1" 2> /dev/null
rmdir /home/dock
usermod -d /home/"$1" "$1"
usermod -u "$2" "$1"
groupmod -g "$4" dock
groupmod -n "$3" dock

# Make sure the docker socket is same same
groupmod -g "$6" docker
gpasswd -a "$1" docker

chown -R "$2":"$4" /home/"$1"

# Make sure all our confs are good
cd /home/"$1"/._devconf
sudo -u "$1" make
cd /home/"$1"/.config/nvim/plugged/fzf
sudo -u "$1" ./install --all
# Make tmux persistant
sed -i -r -e "s|^set -g @resurrect-dir.*$|set -g @resurrect-dir '${5}/._tmuxres'|" /home/"$1"/.tmux.conf

# link secret keys
ln -s /_ssh /home/"$1"/.ssh
ln -s /_kube /home/"$1"/.kube
mkdir -p /home/"$1"/.local/share
ln -s /_direnv /home/"$1"/.local/share/direnv
mkdir -p /home/"$1"/.config/
ln -s /_doctl /home/"$1"/.config/doctl
rm -r /home/"$1"/.vim-tmp
ln -s /_vimtmp /home/"$1"/.vim-tmp

cd "$5"
exec sudo -u "$1" /bin/zsh -i -c tmux
# exec  /bin/zsh -i -c tmux
