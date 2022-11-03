#!/bin/bash

version=0.3.8
pf_path=~

while getopts "p:v:" opt
do
    case $opt in
        p) pf_path="$OPTARG";;
        v) version="$OPTARG";;
        ?) echo "script usage: $(basename \$0) [-p path] [-v version]" >&2
            exit 1
        ;;
    esac
done

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
rustup update stable
rustc -V
cd "${pf_path/'pathfinder'/''}/pathfinder" || exit 1
echo -e "\n\033[0;32mОновлюємо ноду до версії ${version} за шляхом $(pwd)\033[0m\n"
git fetch
git checkout "v${version}"
cargo build --release --bin pathfinder
mv ./target/release/pathfinder /usr/local/bin/
cd py || exit 1
source .venv/bin/activate
PIP_REQUIRE_VIRTUALENV=true pip install -e .[dev]
systemctl restart starknetd

echo -e "\n\033[0;94mНода успішно оновлена до актуальної версії!"
echo -e "\033[0;93mПоточна версія ноди:"

pathfinder -V