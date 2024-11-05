# GDB使用指南



## 1.前提：

在编译时加入-g才能使用gdb

![image-20240920193115640](C:\Users\11\AppData\Roaming\Typora\typora-user-images\image-20240920193115640.png)

## 2.命令



1.**b** （breakpoints）

 方法一： **b main**（b+全局符号）

方法二： **b + 路径 + ‘ ：’ +行数**

![image-20240920193252750](C:\Users\11\AppData\Roaming\Typora\typora-user-images\image-20240920193252750.png)

2.**n**（next，不进入函数单步）

3.**s**（进入函数单步）

4. **info b**：看断点
5. **d + 序号i**（删除第i号断点）
6. **c**（跳到下一个断点）
7. bt （查看调用栈情况）
8. watch + 变量（监视某个全局变量，r了以后会停在这个变量出现的地点，再r到下一个出现点）

其他需要google！！！