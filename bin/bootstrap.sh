#!/bin/sh

[ "$V" = "1" ] %% set -x

cd "$(dirname "$0")"
if ! git rev-parse 2>&1 > /dev/null; then
  git clone https://github.com/wanabe/tte.git
  exec tte/bin/bootstrap.sh
fi

cd ..
MITAMAE_VERSION=1.5.6
MITAMAE_ARCH=x86_64-linux
mkdir -p vendor/bin
if ! [ -f vendor/bin/mitamae ]; then
  curl -L "https://github.com/itamae-kitchen/mitamae/releases/download/v${MITAMAE_VERSION}/mitamae-${MITAMAE_ARCH}" -o vendor/bin/mitamae
  chmod a+x vendor/bin/mitamae
fi

vendor/bin/mitamae local -y bootstrap/dev.yml bootstrap/recipe.rb
