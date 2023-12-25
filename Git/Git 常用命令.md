# 1. 修改与提交


```bash
git add <file> # 将单个文件从工作区添加到暂存区
git add . # 将所有文件添加到暂存区
git commit -m "messenge" # 将暂存区文件提交到本地仓库
git status # 查看工作区状态，显示有变更的文件。
git diff # 比较文件的不同，即暂存区和工作区的差异。
```


# 2. 远程操作


```bash
git push origin master # 将本地的master分支推送到远程对应的分支
git pull  # 下载远程代码并合并，相当于git fetch + git pull
git fetch   # 从远程获取代码库，但不进行合并操作

git remote add origin <url> # 将远程仓库与本地仓库关联起来
git remote -v # 查看远程库信息
```


# 3. 撤销与回退

## 3.1 撤销

```bash
# 场景1：当改乱了工作区某个文件的内容，但还没有add到暂存区
git checkout <file> # 撤销工作区的某个文件到和暂存区一样的状态

# 场景2：当乱改了工作区某个文件的内容，并且git add到了暂存区
git reset HEAD <file> # 第1步，将暂存区的文件修改撤销掉
git checkout <file> # 第2步，将工作区的文件修改撤销掉

# 场景3：乱改了很多文件，想回到最新一次提交时的状态
git reset --hard HEAD # 撤销工作区中所有未提交文件的修改内容
```


## 3.2 回退


回退操作：当已经进行了commit操作，需要回退到之前的版本：

```bash
git reset --hard HEAD^ # 回退到上次提交的状态
git reset --hard HEAD~n # 回退到n个版本前的状态
git reset --hard HEAD commitid # 回退到某一个commitid的状态
git reset --soft HEAD commitid # 回退到某一个commitid的状态，并且保留暂存区的内容
git reset --mixed(默认) HEAD commitid # 回退到某一个commitid的状态，并且
```


# 4. 分支管理


```bash
git branch <name> # 创建分支
git checkout <name> # 切换到某个分支
git checkout -b <name> # 创建并切换到新分支，相当于同时执行了以上两个命令
git merge <name> # 合并某个分支到当前分支中，默认fast forward
git branch -a # 查看所有分支
git branch -d <name> # 删除分支
```
