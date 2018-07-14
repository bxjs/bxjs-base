# @bxjs/base包发布管理命令

login:
	# 登录npmjs账号（https://www.npmjs.com/）
	npm login --registry=https://registry.npmjs.org/ --scope=@bxjs
publish:
	# 发布@bxjs/base包命令实现（发布之前需要先执行make login命令）
	@echo "current version is $(shell echo `npm version|xargs`)"
	git add --all && git commit -m "auto release submit code" . && git push
	npm version patch # 更新版本号如果出错需要暂停先手动递交修改内容
	./npm_publish.sh # 编译发布包
	git push # npm version会自动产生一个tag需要在发布完成之后将tag推送到仓库上（如果发布失败需要回滚tag即可）
	@echo "\033[0;32m"
	@echo "Publish @bxjs/base Successfully!"
	@echo "\033[0m"
