# 线程池

### 设计逻辑：

![image-20240819093830374](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819093830374.png)

线程池对象函数的绑定：

![image-20240819094323404](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819094323404.png)



#### thread 语法：

初始化构造函数：

![image-20240819094748030](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819094748030.png)

拷贝构造函数：

![image-20240819094843667](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819094843667.png)

move构造函数：

![image-20240819094956026](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819094956026.png)

getid（）:获取线程id，返回类型std::thread::id

joinable():判断线程是否可以加入等待

join()：等待线程执行完成后才返回

detach():

![image-20240819100145808](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819100145808.png)

实例：

![image-20240819095317211](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819095317211.png)

![image-20240819095415003](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819095415003.png)

![image-20240819095550931](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819095550931.png)

![image-20240819100243032](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819100243032.png)



# 互斥锁

锁使用方式：

**![image-20240819104430845](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819104430845.png)**

**unique_lock 和 lock_guard的使用场景：**

![image-20240819110208886](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819110208886.png)

实例：

![image-20240819105246485](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819105246485.png)

![image-20240819110106398](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819110106398.png)

notify_one,随机唤醒一个等待条件变量的线程

![image-20240819111318238](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819111318238.png)

cond.wait(locker, predicate)``wait`函数是`std::condition_variable`类的成员函数，它有两个参数：一个互斥锁对象`locker`和一个谓词`predicate`。谓词是一个返回布尔值的函数或函数对象，用来检查等待条件是否满足。

# 条件变量

![image-20240819111049258](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819111049258.png)

# 原子变量 

**原子变量**是一种特殊的数据类型，用于执行原子操作。原子操作是不可分割的操作，可以确保在多线程环境中线程安全地执行。C++中的`std::atomic`提供了对原子操作的支持。



**用到了再看**



# 异步操作

std::future:

异步指向某个任务，然后通过future特性去获取任务函数的返回结果

std::aysnc:异步运行某个任务

![image-20240819145503528](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819145503528.png)

**async + future实例：**

![image-20240819150107563](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819150107563.png)

![image-20240819150322614](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819150322614.png)

**有参数时：**

future 的decltype推导：

![image-20240819150413427](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819150413427.png)

async语法：

![image-20240819150803356](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819150803356.png)







std::packaged_task:将任务和feature绑定在一起的模板，是一种封装对任务的封装

![image-20240819151116148](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819151116148.png)

std::promise

![image-20240819145723298](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819145723298.png)

![image-20240819151746342](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819151746342.png)



# function函数

头文件<funtional>

**类似与c语言的函数指针**

三种使用方式：

![image-20240819152148392](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819152148392.png)

保存成员函数时第一个参数是类对象的引用！（其实第一个参数就是this）

# bind

 ![image-20240819152635797](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819152635797.png)

实例用法：

![image-20240819152810010](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819152810010.png)

![image-20240819152949195](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819152949195.png)

绑定类方法：

![image-20240819153107613](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819153107613.png)



# c++实现线程池

**使用方法**![image-20240819154041123](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819154041123.png)

**去看代码，写代码！！！！！**

判断任务执行完毕时的条件为什么需要两个？

![image-20240819160127619](C:\Users\qhr\AppData\Roaming\Typora\typora-user-images\image-20240819160127619.png)

atomic_更严谨地保证了还没有执行完的线程，不会让**最后一个任务**还没执行完就判断全部执行完毕（因为最后一个任务开始执行时就pop弹栈了，好像栈中没有任务了，实际它还没执行完！！！）



# 异常处理

缺点：对性能有影响

try

throw



# 携程（c++ 20）