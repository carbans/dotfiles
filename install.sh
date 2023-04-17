#!/bin/bash
set -e


function parse() {
  for arg in "$@"; do # transform long options to short ones
    shift
    case "$arg" in
      "--name") set -- "$@" "-n" ;;
      "--verbose") set -- "$@" "-v" ;;
      *) set -- "$@" "$arg"
    esac
  done
  while getopts "n:v" optname  # left to ":" are flags that expect a value, right to the ":" are flags that expect nothing
  do
    case "$optname" in
      "n") name=${OPTARG} ;;
      "v") verbose=true ;;
    esac
  done
  shift "$((OPTIND-1))" # shift out all the already processed options
}


installBaseDeps() {
  sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    ruby
}

installDocker() {
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

setupTerm() {
  chsh -s $(which zsh)
}


installOMZ() {
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

installDeps() {
  gem install colorls
}
setupOMZ() {
  curl -o ~/.zshrc https://raw.githubusercontent.com/carbans/dotfiles/master/zsh/zshrc
}



