# git

git定义：分布式版本控制工具

github定义：代码托管平台

 

## 作用：

1.保存文件的所有修改记录

2.使用版本号进行区分（Hash：SHA1）

3.随时可浏览历史版本记录

4.可还原到历史指定版本

5.对比不同版本的文化差异

 

## 版本控制：

集中式：代表SVN，有一个中央服务器，所有内容都提交到这个服务器上

分布式：代表git，每一台机器也是分布式的一个节点，有本地仓库，也有集中仓库



## 基本概念

### 仓库：

​	远端仓库：

![image-20240820193059664](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820193059664.png)

​	本地仓库

![image-20240820193216107](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820193216107.png)

### 协议：

​	1.http

​	2.ssh

![image-20240820193342962](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820193342962.png)

生成公钥和私钥地址

![image-20240820193911688](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820193911688.png)

​	3.git



### 配置用户名和邮箱

![image-20240820200822242](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820200822242.png)

工作区，暂存区，本地仓库，远程仓库概念

远程仓库别称：origin

暂存区：svn中没有暂存区，每次提交都是直接提交到中央，导致可能很多无意义的提交，暂存区就是为了统一提交，减少无用提交

![image-20240820202134067](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820202134067.png)

git **add** [文件名] ：添加到**暂存区**

git **commit** [文件列表] -m "注释" ： 提交到本地仓库

git **push** origin master ： push 到远程仓库（origin）的 master分支

git **pull** ：从远程仓库拉取到**工作区**

版本号：40位哈希

head：一个指针指向最近一次提交的记录（当前检出记录的符号引用）



## 操作

#### 	基本操作

![image-20240820205217392](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820205217392.png)

#### 逆向操作

![image-20240820205346934](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820205346934.png)

​	--soft：退到暂存区（也可以写版本号（40位哈希））

![image-20240820205948659](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820205948659.png)





git **checkout**：重置工作区中做的一些修改，返回到**修改之前**



#### 本地仓库整理操作

![image-20240820211107442](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820211107442.png)

细节补充：x 和：wq的区别：在没有变更文件时：x不会修改时间，但wq会。



git **rebase** -i ：

​	1.合并:进去选择 s，合并到上一个提交中

​	2.修改非上一个（可能要修改上两个的），选择e，修改上两个的内容，再git commit --amend

#### 分支操作

![image-20240820214425774](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820214425774.png)

![image-20240820220132036](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820220132036.png)

![image-20240820221345476](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820221345476.png)

**问题：为什么不建议git rebase合并分支**：

![image-20240820221234792](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820221234792.png)



常见场景：

![image-20240820215115024](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820215115024.png)

​	**两次merge：先切换到develop把master合并过来测试，没问题再切换回master把develop放过来合并**





**实际分支场景：**

![image-20240820222139205](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820222139205.png)

![image-20240820222335158](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820222335158.png)

解决冲突：

![image-20240820221554990](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820221554990.png)

![image-20240820221607355](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820221607355.png)

冲突实例：

使用的是git merge master

![image-20240820215325199](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820215325199.png)

![image-20240820215438072](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820215438072.png)





## 使用规范

#### 项目对象：

![image-20240820222609631](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820222609631.png)



#### 分支管理：

![image-20240820222526342](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240820222526342.png)