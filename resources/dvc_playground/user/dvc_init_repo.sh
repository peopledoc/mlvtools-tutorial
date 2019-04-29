#!/usr/bin/env bash

pushd ~
git config --global user.name $(whoami)
git config --global user.email $(whoami)@example.com

git clone git@git_srv:/srv/git/test_dvc_remote.git
popd


dvc remote add dvc_remote ssh://dvc_user@dvc_srv:/data/dvc/remote
dvc config core.remote dvc_remote
tail -f /dev/null
