#!/bin/ash

baseGitPath="https://github.com/pirati-web/"
reposDir=/mnt/repo
buildDir=/mnt/build

function cloneRepo() {
  git clone "${baseGitPath}${repo}.git"
}

function pullRepo() {
  cd $repo;
  git pull
  cd ..
}

function fetchRepo() {
  if $force; then
    echo "Clone (force)"
    cloneRepo
  elif [ -d $repo ]; then
    echo "Pull"
    pullRepo
  else
    echo "Clone (non-exists)"
    cloneRepo
  fi;
}

function build() {
  bundle install --without development
  bundle exec jekyll build -d ${buildDir}/${repo}
}

echo "Start! repo: $repo ; force: $force"

cd $reposDir

fetchRepo
cd $repo
build

echo "Stop!"
