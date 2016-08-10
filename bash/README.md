# Zsh Profiles

Just run `./install.sh` to install it as `~/.zshrc`.  You can put your own
customization under `~/.profiles.d` dir (shared by both my zsh profiles and
bash profiles).

For example I have these -

```
% mkdir ~/.profiles.d

% cd ~/profiles.d; ls
00-docker-machine-env.sh  01-go-path.sh  02-aws-cli-completer.sh

% cat 00-docker-machine-env.sh
eval $(docker-machine env dockerhost)

% cat 01-go-path.sh
export GOPATH=$HOME

% cat 02-aws-cli-completer.sh
if [[ $SHELL == *zsh ]]; then
    source /usr/local/bin/aws_zsh_completer.sh
fi
```
