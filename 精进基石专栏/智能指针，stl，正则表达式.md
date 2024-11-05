





# 智能指针

解决问题：

​	内存泄露：不需要手动释放，使用智能指针自动释放

​	共享所有权的指针的传播和释放（shared_ptr）：比如多线程使用同一个对象时的析构问题

## shared_ptr:

场景：

![image-20240817183717746](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817183717746.png)

只能是**只读**方式，否则应该深拷贝了

![image-20240817183131581](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817183131581.png)

![image-20240817183514655](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817183514655.png)



![image-20240817183525938](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817183525938.png)



结束作用域**栈**上变量执行析构，reference count  - 1 ；当reference count = 0后才会释放**堆**上的对象

**问题：智能指针线程安全吗？**

答：ref count而言是安全的，但如果是需要对对象进行**修改**则不安全，需要加锁



语法：

​	创建：

![image-20240817184804593](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817184804593.png)



​	reset（）：有参数则指向这个参数new的堆对象，没参数则减少这个指针的**一个引用**

​	不能将裸指针指向智能指针，智能先new，先声明智能指针再赋值

![image-20240817185055882](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817185055882.png)

​	get（）：

![image-20240817185911902](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817185911902.png)

​	自定义删除器：

![image-20240817190035974](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817190035974.png)



注意问题：

​	1.裸指针只能委托给一个智能指针，多个则报逻辑错误![image-20240817190230521](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817190230521.png)

​	2.![image-20240817190525691](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817190525691.png)

​	3.

![image-20240817190943230](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817190943230.png)



可能会析构两次，正确做法如下：

![image-20240817190825031](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817190825031.png)



4.避免**循环引用**

![image-20240817191209995](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817191209995.png)

  循环指了以后count都为2，析构的时候count都为1，不会释放堆上对象

![image-20240817191817482](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817191817482.png)





## unique_ptr:

只有一个指针可以指向委托的对象，其他的指针不能再指向这个对象



## weak_ptr:

解决循环引用问题，需要配合shared_ptr一起使用

![image-20240817194849681](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817194849681.png)





语法：

![image-20240817194426891](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817194426891.png)



**注意：lock要先锁，再用expire检测！！！**

weak_ptr不持有引用计数，shared_ptr持有引用计数



# STL

# 右值引用和移动语义

什么是左值右值

![image-20240817195145945](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817195145945.png)

**左值引用**

只能指向左值

![image-20240817195358632](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817195358632.png)

但是，const左值引用可以指向右值

![image-20240817195537894](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817195537894.png)

**右值引用**

![image-20240817200014584](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817200014584.png)

引入右值引用是为了修改右值！！！

move函数：变左为右

![image-20240817200150749](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817200150749.png)

右值引用有什么用？

![image-20240817200613718](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817200613718.png)

只需要**资源转移**，而不需要新的资源申请，提升性能，节省资源，避免不必要的拷贝



问题：

不管左值引用还是右值引用，都会修改原地址的值

![image-20240817200927545](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817200927545.png)

移动拷贝函数，浅拷贝函数，深拷贝函数：

浅拷贝当存在指针时，不会拷贝，只会指向相同的堆区，可能两次delete；

深拷贝占用资源多；

移动拷贝会直接剪切资源，性能更好

 **A a = move(b) 有移动拷贝先调用移动拷贝，没有就调用别的拷贝构造函数**



# forward完美转发

作用：本身传入的是什么值（左或右），不管经过什么变化，都转发原本的值 

![image-20240817202743895](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817202743895.png)

![image-20240817203043446](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817203043446.png)



# emplace系列函数

通过直接构造对象的方式避免了内存的拷贝和移动



# 小结：

![image-20240817203642424](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240817203642424.png)



# 匿名函数lambda

lambda表达式：用一个变量去存储一个函数

空捕获：不能使用所在函数体中的变量

![image-20240819091559996](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819091559996.png)

  值捕获和引用捕获：![image-20240819092338615](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819092338615.png)

隐式捕获：

![image-20240819092515139](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819092515139.png)

表达式捕获（c++14）：

可以捕获**右值**

![image-20240819092826209](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819092826209.png)

泛型lambda（c++14）：

![image-20240819093021659](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819093021659.png)



混合捕获：

![image-20240819093128475](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819093128475.png)

# 正则表达式

