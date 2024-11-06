# 1.格式化输入输出

## 格式化输出printf：f->format

![image-20240815072310593](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815072310593.png)

%d的含义：缓冲区是数据流，%d是以整数的形式去**解释**这个内存空间的数据并输出

![image-20240815072641887](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815072641887.png)

转换说明：

![image-20240815073509506](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815073509506.png)

![image-20240815073957909](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815073957909.png)

![image-20240815073529696](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815073529696.png)

![image-20240815073942189](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815073942189.png)

常见输出格式：

![image-20240815072457121](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815072457121.png)

![image-20240815072505701](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815072505701.png)

## 格式化输入

## 格式化输入scanf：

![image-20240815081058358](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815081058358.png)

转换说明：

![image-20240815081850490](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815081850490.png)



# 命令行参数

int argc：输入参数的个数，默认1个，是exe文件执行路径

char *argv:输入参数的具体参数

![image-20240815113325988](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815113325988.png)

命令行操作：

![image-20240815113420232](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815113420232.png)

在执行的程序后面带上的就是参数

# 结构体

1.用typedef给结构体取别名：

![image-20240815113914702](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815113914702.png)

![image-20240815113925114](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815113925114.png)

2.结构体不像类，只能放数据

3.数据可能会内存对齐问题（可以省内存）

# 动态内存分配

内存分配（堆区）：

![image-20240815120221037](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815120221037.png)

内存释放：

![image-20240815120353715](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815120353715.png)

悬空指针问题：

![image-20240815120455026](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815120455026.png)

# 函数指针

double (*f) (double)必须加（*f），否则按照优先级优先和返回值结合

作用：创建一个函数，然后在别的地方调用---回调函数

实例：![image-20240815162350062](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815162350062.png)

注意compare函数！！！！之前一直没搞懂



# 文件

内存缺点：断电即失去

分类：文本文件、二进制文件

​		1.文本文件

![image-20240815185254962](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815185254962.png)

缺点：1.不跨平台，可能出现错误（win下\r\n换行，linux \n）或者提前终止（linux中没有eof，如果放到win下可能碰到eof直接终止）

​			2.占用空间高



二进制文件：

缺点：看不懂

优点：占用小，网络传输等需要高效的场景肯定都是二进制文件读写





缓冲区：

![image-20240815184042429](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815184042429.png)

fflush：不需要输出缓冲区，直接输出到文件中



流：

![image-20240815184318091](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815184318091.png)

流对象其实就是FILE结构体的对象，有三个指针可以指向头尾和当前读写位置。



文件的打开关闭：

​	1.fopen：**’+‘的模式都可以读也可以写，’b‘的模式代表读写二进制文件**

![image-20240815185816314](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815185816314.png)

![image-20240815185835838](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815185835838.png)





2. fclose：

![image-20240815190033505](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815190033505.png)

文本文件的读写：

1.fgetc/fputc



2.fgets/fputs



**序列化**：即将内存中的对象持久化（文本格式）xml，json

![image-20240815191745948](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815191745948.png)

**反序列化：**把持久化的对象加载到内存并生成对应的对象

![image-20240815191709213](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815191709213.png)

二进制文件的读写：

1.fread:

**为什么buf大小设置为4k的整数倍？因为操作系统的页大小为4k**

2.fwrite:

![image-20240815192923831](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815192923831.png)

# 文件定位

用前面的函数只能做到顺序读写，文件定位函数可以做到任意读写

![image-20240815231403310](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815231403310.png)

![image-20240815231415926](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815231415926.png)

![image-20240815231501952](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815231501952.png)

# 错误处理



errno：一个宏，出现错误就把errno设置成对应的错误码（可读性低）

![image-20240815231832331](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815231832331.png)

![image-20240815231911366](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815231911366.png)

因为errno可读性低，又有strerror（errno）来输出错误信息

![image-20240815232115275](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240815232115275.png)