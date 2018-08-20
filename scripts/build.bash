#!/usr/bin/env bash

function command_required () {
    if ! [ -x "$(command -v $1)" ]; then
        >&2 echo "${1^} required to run this script. Install it first."
        exit 1
    fi
}

command_required 'go'
command_required 'docker'

if ! [ -x "$(command -v xgo)" ]; then
    echo 'Installing xgo for cross-compilation'
    go get github.com/karalabe/xgo
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd $(dirname "$DIR")

VERSION=$(sed -n '7{ N; N; s/\n/./g; s/[^."]*"\([^"]*\)"/\1/g; p; }' "$PWD/version/version.go")

echo "Building evm $VERSION"

mkdir -p "$PWD/bin"
xgo --deps='https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2' --dest "$PWD/bin" --out "evm-$VERSION" "$PWD/cmd/evm"

popd
