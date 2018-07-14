#!/usr/bin/env bash

# 本地开发调试app工程
if [ "$1" == "x" ]; then
    killall node; exit 0;
fi
killall node
find ./app -name '*.js' -type f -print -exec rm -rf {} \; # 删除应用app目录下的所有js文件必须强制使用ts强类型编程
rm -rf .tscache
echo "import '@bxjs/base/framework/test'" > ./test.ts
./node_modules/nodemon/bin/nodemon.js --exec "./node_modules/ts-node/dist/bin.js --cache-directory .tscache --project ./tsconfig.json" ./test.ts $1 --ignore dist/ --ignore test/ --ignore resources/ &
