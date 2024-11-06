

#### 9-16 souceinsight 编辑时使用卡顿

点击微软输入法-设置-兼容性打开即可







#### 9-19 ntyco的使用：

clone下来要先编译 make

执行时遇到问题：

![image-20240919220445082](C:\Users\12280\Desktop\c++全栈笔记\typora-user-images\image-20240919220445082.png)

要加上 -I （Include directory）库文件路径 -L （Library directory）-l库文件

-I 和 -L 是编译器要额外查找库的路径， -l（小写）是链接相应库文件

最后执行需要：

![image-20240919220759223](C:\Users\12280\Desktop\c++全栈笔记\typora-user-images\image-20240919220759223.png)



#### 9-19 写crud时遇到res 重复定义问题：

需要在业务逻辑中把每个case括号扩一下，改下作用域



#### 9-19 代码在set ，modify之后再get会直接down掉：

原因：![image-20240920080627199](C:\Users\12280\Desktop\c++全栈笔记\typora-user-images\image-20240920080627199.png)

#### 9-19 del再set的bug：

![image-20240920085315105](C:\Users\12280\Desktop\c++全栈笔记\typora-user-images\image-20240920085315105.png)





#### 9-26 关于makefile:



$(OBJS): %.o=%.c 正确

$(OBJS): %. o = %. c 加了空格make clean的时候把我的.c文件全删了！！！！！

未知原因，待讨论







#### 9-27 关于**gtest直接编译时使用 **-lgtest -lgtest_main**发现找不到文件**

下载了gtest并且cmake 了 Cmakelists.txt

然后make

默认在/usr/src/gtest生成了.a文件（静态库文件）

直接编译时使用 **-lgtest -lgtest_main**发现找不到文件

原因：

静态库文件必须放到/usr/lib文件夹下才能通过 -lxxx找到链接库！

否则就需要通过动态链接的方式



#### 9-27 关于**c的语法**

*queue->tail = link; //为什么不能queue->tail->next = link;???





#### 9-28 关于编译器bug:隐式声明

![image-20240928080333415](C:\Users\12280\AppData\Roaming\Typora\typora-user-images\image-20240928080333415.png)

说隐式声明一般就是找不到定义的函数就自动转化为隐式声明。

可能原因：函数位置不对，调用的位置在定义位置之前就会报这个错，或者是压根没定义，或者写错了函数名字

#### 10-3:django后台 url问题：

```
<a class="nav-link active" aria-current="page" href="/blog/index/1">Linux/C/C++</a>
```

对于这个href前面必须加上“/”，否则每次点击都会基于当前的url**叠加**上/blog/index/1，而不是在/blog的基础上**改变**





#### 10-10:ubuntu1604一直无法开启ssh。。。

每次启动不会自动开启ssh

```
sudo apt-get remove openssh-server openssh-client --purge && sudo apt-get autoremove && sudo apt-get autoclean && sudo apt-get update

sudo apt-get install openssh-server openssh-client

```

两条指令暴力解决



#### 10-10 ubuntu ifconfig发现网卡没有ip地址：

[VMware 虚拟机 Ubuntu 系统没有IP地址 解决：UP BROADCAST MULTICAST 问题_vmware虚拟机ubuntu无法分配ip-CSDN博客](https://blog.csdn.net/qq_38222534/article/details/80635272)



#### 10-10 ubuntu的ssh需要启动好一会才能连接

。。。。



#### 10-10 vscode没有保存文件权限：

![image-20241010200531620]($%7Bimages%7D/image-20241010200531620.png)



#### 10-14  数据库安装后密码问题

你可以通过以下命令查看 `root` 用户使用的身份验证插件：

```
bash复制代码sudo mysql -u root
SELECT user, host, plugin FROM mysql.user;
```

如果你看到 `root` 用户的 `plugin` 字段显示为 `auth_socket`，那就是它允许你无密码登录的原因。

#### 10-14 如何修改MySQL的root用户密码或配置

如果你想为 `root` 用户设置密码并使用传统的用户名/密码方式登录，可以按以下步骤操作：

1. 登录MySQL：

   ```
   bash
   
   
   复制代码
   sudo mysql
   ```

2. 更改 `root` 用户的验证方式为 `mysql_native_password`：

   ```
   sql复制代码ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_new_password';
   FLUSH PRIVILEGES;
   ```

3. 退出MySQL并使用密码登录：

   ```
   bash
   
   
   复制代码
   mysql -u root -p
   ```

这样，你就可以使用设置的密码登录MySQL了。





#### 10-14 navicat如何查看表与表之间的关系：

’查看‘--》’ER图表‘



#### 10-16 kafka环境搭建

**https://www.yuque.com/docs/share/fa589923-4368-4bcd-97ad-5e38d7207dee?#**

#### 10-16 c++操作kafka

**[1-4 C++操作kafka (yuque.com)](https://www.yuque.com/linuxer/xngi03/ugtbw0?#XrqtI)**



10-19 强制删除非空文件夹

rm -rf 文件夹名



10-22worker process 3135 exited on signal 11 ngx_http_fastdfs_process_init pid=3137，nginx无法访问一直加载

[worker process 3135 exited on signal 11 ngx_http_fastdfs_process_init pid=3137，nginx无法访问一直加载_worker process 28231 exited on signal 11 (core dum-CSDN博客](https://blog.csdn.net/A_XJF01/article/details/122617466)



#### 10-25 ：git clone 很慢

如果git clone非常慢，down不下来怎么办？

在该项目文件夹下

```shell
git init

git remote add origin http://github.com/<user>/<xxx.git>

git fetch --all -tags

git checkout Vxxx
```

#### 10-25： Ubuntu20.04安装mysql 5.7

[Ubuntu20.04安装MySQL5.7-实测3种方法（保姆级教程）_ubuntu安装mysql5.7-CSDN博客](https://blog.csdn.net/liuhuango123/article/details/128264867?ops_request_misc=&request_id=&biz_id=102&utm_term=ubuntu20.04安装mysql 5.7&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduweb~default-0-128264867.142^v100^pc_search_result_base3&spm=1018.2226.3001.4187)



#### 10-26:mysql密码正确无法登录

原因：新的mysqluser表中只有 root @ localhost

所以要加-h

```shell
mysql -h localhost -u root -p
```



10-26：vscode无法修改wsl文件

```shell
sudo chown <user> /home/<user>
#修改文件所属用户
```

