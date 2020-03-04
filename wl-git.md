# Git 使用#
b
### 配置
1. 设置项目用户信息
    - git config -e [--global]
    - git config  user.name "name“  
    - git config  user.email "email address"
2. 配置全局用户信息
    - git config -global  user.name "username"
    - git config -global  user.email "email addressw"
3.  查看配置
    - git  config --list
4. 初始化
    - git  init
5. 克隆
	- git clone url (https://gitee.com/bml2000/xuexi.git)
6. 拉取
	- git pull
    - git fetch
7. 推送
	- git push
	- git push -f 
	- git push [remote] [tag]
	- git push [remote] --tags
	- git push [remote] --tags
	- git push [remote] [branch]
	- git push [remote] --all
8. 添加到暂存区
	- git add file file
	- git add dir
	- git add .
	- git add -p  
	- git rm  file
	- git rm -f  file
	- git rm --cached file
	- git mv oldname newname
9. 提交本地库
	- git commit  -m "note" file file
	- git commit -a 
10. 比较
	- git diff
	- git diff --cached 
	- git diff master origin/master
	- git diff HEAD
11.  撤销
	- git checkout -- file    工作区内撤销
	- git reset --hard HEAD ^  从本地库还原上次
	- git reset --hard HEAD~2  从本地库还原上n次
	- git reset --soft         撤销本地库
	- git reset --mined 		撤销本地库和暂存库
	- git reset --hard origin/master  重远程库撤销
12. 远程仓库
	- git remote -v   		            	查看
	- git remote add origin branch			添加远程仓库链接
	- git remote remove 					删除远程仓库链接
13. 分支处理
	
	- git switch name 				转换分支
	- git branch name  				新建分支
	- git branch -r                 查看远程分支
	- git branch -a					查看本地分支
	- git checkout					新建分支
	- git checkout -b               新建分支并转到此分支
	- git branch -d name 			删除分支
	- git merge name 				合并分支
14. 状态查看
	- git status    				状态
	- git log						日志
	- git log --pretty=oneline
	- git relog						提交日志
	- git relog --online
	- git tag						版本
	- git tag [tag]	
	- git tag -d [tag]              删除版本
	- git tag tag [commit] 

	- git stash save                 暂存
	- git stash list
	- git stash drop
	- git stash apply 
	- git stash pop
 	- git rebase
 	
