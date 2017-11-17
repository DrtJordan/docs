# JVM Doc


## 一、JVM 运行内存布局

![jvm-1](imgs/jvm-1.png)

### 1. 程序计数器 Program Counter Register (线程私有内存)

- 程序计数器
 - 是一块较小的内存区域，是当前线程所执行的<字节码的行号>指示器。

- Java 虚拟机的多线程是通过线程轮流切换, 并分配处理器执行时间的方式来实现的。

- 为了线程切换后能恢复到正确的执行位置, 每条线程都需要一个独立的程序计数器，各条线程之间计数器互补影响，独立存储，这类的内存叫做: 线程私有内存。

- 此内存区域是唯一不会出现 OutOfMemoryError 情况的内存


### 2. 虚拟机栈 VM Stack (线程私有内存)

- VM Stack 的生命周期与线程相同, VM Stack 也是线程私有

- VM Stack 用来描述 Java 方法执行的内存模型：
  - 每个方法在执行的同时会创建一个栈帧(Stack Frame)

- 栈帧(Stack Frame)：
  - 用于存储 <局部变量、操作数栈、动态链接、方法出口>, 每个方法从调用到执行完成的过程，就是对应一个栈帧(Stack Frame)在虚拟机中入栈到出栈的过程。

- 这个区域会有两种异常:
  - StackOverFlowError: 线程请求的深度大于虚拟机允许的深度。
  - OutOfMemoryError: 虚拟机栈 VM Stack 需要动态扩展内存大小，无法申请到足够的内存时会出现


### 3. 本地方法栈 Native Method Stack (线程私有内存)

- 本地方法栈与虚拟机栈作用类似，区别是：
 - 虚拟机栈 VM Stack: 是为虚拟机执行 Java 方法。 本地方法栈 Native Method Stack: 是为虚拟机使用到的本地方法(Native) 准备的，本地方法栈对使用的语言、数据结构没有明显

- 这个区域会有两种异常(与虚拟机栈 VM Stack 相似):
 - StackOverFlowError: 线程请求的深度大于虚拟机允许的深度。
 - OutOfMemoryError: 虚拟机栈 VM Stack 需要动态扩展内存大小，无法申请到足够的内存时会出现


### 4. Java 堆 Heap (线程共享内存)

Java 堆是虚拟机中内存管理的最大一块区域，被所有线程共享，在虚拟机启动的时候创建。堆唯一的目的是存放对象实例、分配的数组

Java 堆可以细分为:
- 新生代 Young Generation 区
 - Eden Space 任何新进入运行时数据区域的实例都会存放在此
 - S0 Suvivor Space 存在时间较长，经过垃圾回收没有被清除的实例，就从Eden 搬到了S0
 - S1 Survivor Space 同理，存在时间更长的实例，就从S0 搬到了S1
- 旧生代 Old Generation/tenured 区
 - 存在时间更长的实例，对象多次回收没被清除，就从S1 搬到了 tenured
- Perm 永久代存放运行时数据区的方法区

这个区域内存不足会抛出: OutOfMemoryError 异常


### 5. 方法区 Method Area (线程共享内存)

方法区 Method Area 是各个线程共享的内存区域, 存储已经被虚拟机加载的 Class 信息(字段,方法,接口等)、常量、静态变量、即使编译后的代码数据。

这个区域内存不足会抛出: OutOfMemoryError 异常


### 5.1. 运行时常量池 Runtime Constant Pool 也是 方法区 Method Area 的一部分 (属于方法区 Method Area 规则)

存放编译期间生成的各种<字面量>和<符号引用>, 这部分数据将在类加载后进入 <方法区的运行时常量池> 中存放

这个区域内存不足会抛出: OutOfMemoryError 异常


### 6. 直接内存 Direct Memory

直接内存 Direct Memory 不是 JVM 运行时内存的一部分，而是 JDK 1.4 中新加入的 NIO(New Input/Output) 类, 引入了基于通道(Channel) 与 缓冲区(Buffle) 的 I/O 方式。
这种方式可以使用 本地(Native) 函数库直接在堆外分配内存，通过一个存储在 Java 堆中的 DirectByteBuffer 对象, 作为这块堆外内存的引用，这样就避免了 Java 堆和 Native 堆来回复制数据.

直接内存分配的堆外内存会受到物理机和操作系统的内存限制, 如果动态扩展不足会出现: OutOfMemoryError 异常
