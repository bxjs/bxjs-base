#!/usr/bin/env bash

killall node
rm -rf ./package-lock.json ./npm-debug.log ./yarn.lock ./yarn-error.log
rm -rf ./node_modules
yarn install
