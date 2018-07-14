#!/usr/bin/env bash

ROOT=$PWD
rm -rf $ROOT/dist
mkdir -p $ROOT/dist/target
cd $ROOT

# 编译当前工程
./cmd_make.sh

# 发布@bxjs/base包
cp -rvf framework *.d.ts *.ts *.js *.sh package.json package-lock.json tsconfig.json LICENSE Makefile $ROOT/dist/target
cd $ROOT/dist/target
npm publish --registry=https://registry.npmjs.org

# 删除发布生成的中间文件避免IDE和GIT影响
rm -rf `find $ROOT/framework -name \*.js | xargs`
rm -rf $ROOT/*.js
rm -rf $ROOT/dist
