#!/usr/bin/env bash

# 阿里云函数计算发布脚本（支持框架本地调试和发布到应用正式使用，通过判断app目录是否存在判定）
# 读取package.json中的配置字段信息动态生成配置脚本并加载到环境变量中。
if [ -d "./node_modules/@bxjs/base" ]; then
    # 在正式应用项目中FC发布
    ./node_modules/typescript/bin/tsc
    cd ./node_modules/@bxjs/base
else
    # 在axjs本地git仓库中调试框架代码用途FC发布
    ./node_modules/typescript/bin/tsc
fi
node ./ts_make_config_script.js
source ./__config__.sh

# 对当前工程编译打包发布到FC上
ROOT=$ROOT_APP
cd $ROOT
rm -rf $ROOT/dist
mkdir -p $ROOT/dist/tool
mkdir -p $ROOT/dist/target

./node_modules/typescript/bin/tsc
if [ $? != 0 ]; then
    echo 'make error'
    exit
fi

if [ -d "./node_modules/@bxjs/base" ]; then
    # 在正式应用项目中FC发布
    cp -rvf app package.json yarn.lock tsconfig.json $ROOT/dist/target
    cp -rvf ./node_modules/@bxjs/base/global.d.ts $ROOT/dist/target
else
    # 在axjs本地git仓库中调试框架代码用途FC发布
    cp -rvf app framework test.d.ts global.d.ts error.d.ts error.ts error.js package.json yarn.lock tsconfig.json $ROOT/dist/target
fi
cd $ROOT/dist/target
if [ "$1" == "prod" ]; then
    # 在正式应用线上打包
    yarn install --production
else
    # 日常和预发测试打包（生产和开发的包都安装）
    yarn install
fi
# 阿里云公网发布环境下函数计算的入口定义(hack阿里云封装的私有日志机制实现兼容日常和预发express的日志打印格式)
echo "console.setLogLevel('error'); console.log = console.error; exports.handler = require('@bxjs/base/framework/index').handler" > ./index.js
zip -q -9 -r $ROOT/dist/$FC_FUNCTION_NAME.zip *
cp -rf $ROOT/dist/$FC_FUNCTION_NAME.zip $ROOT/dist/target.zip

# 删除打包生成的中间文件避免IDE和GIT影响
rm -rf `find $ROOT/app -name \*.js | xargs`
if [ ! -d "./node_modules/@bxjs/base" ]; then
    rm -rf `find $ROOT/framework -name \*.js | xargs`
fi
rm -rf $ROOT/*.js
cd $ROOT_AXJS
