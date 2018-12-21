关于iOS多线程，这边勉强可以看看(OC&Swift)
------------------------


![搜多线程谷歌给的第一张图🙄](https://upload-images.jianshu.io/upload_images/1678135-4dd42c5a74e7eac7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1000)



iOS开发多线程总是绕不过的坎，看了很多前辈们优秀的文章，如：[关于iOS多线程，我说，你听，没准你就懂了！](https://www.jianshu.com/p/51fd1362249e)、[谈iOS多线程(NSThread、NSOperation、GCD)编程](http://www.jianshu.com/p/6e6f4e005a0b)、[iOS多线程：『GCD』详尽总结](http://www.jianshu.com/p/2d57c72016c6)、[iOS多线程：『pthread、NSThread』详尽总结](https://www.jianshu.com/p/cbaeea5368b1)、[iOS多线程：『NSOperation、NSOperationQueue』详尽总结](https://www.jianshu.com/p/4b1d77054b35)、[关于iOS多线程，你看我就够了](https://www.jianshu.com/p/0b0d9b1f1f19)等，但不自己整理一下，敲一下代码总是感觉不深刻 ，于是就有这篇文章，断断续续整理了好久。  

示例我尽量把不同知识点代码独立开，看着简单一些，容易理解。示例代码我都用OC和Swift分别写了，不过文中都是以OC说明的，英文如果用两种语言一起，看起来可能比较乱，文章也会更加长（已经非常长了😂😂）。  
Swift写法可能有比较大区别，也有些功能取消，但看一下代码应该能明白了。
文中的所有示例代码：**[andyRon/iOS-Multithreading](https://github.com/andyRon/iOS-Multithreading)**

由于简书没有Markdown的目录功能，我截了Typora的大纲，先看个大概：
![](https://upload-images.jianshu.io/upload_images/1678135-29de3060eff432c4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 1 简介

### 1.1 一些概念

- 系统中正在运行的每一个应用程序都是一个 **进程(Process)** ，每个进程系统都会分配给它独立的内存运行。也就是说，在iOS系统中中，每一个应用都是一个进程。

- 一个进程的所有任务都在 **线程(Thread)** 中进行，因此每个进程至少要有一个线程，也就是**主线程**。那多线程其实就是一个进程开启多条线程，让所有任务并发执行。

- iOS App一旦运行，默认就会开启一条线程。这条线程，通常称作为“主线程”。在iOS应用中主线程的作用一般是：  
  刷新UI；  
  处理UI事件，例如点击、滚动、拖拽。

- 如果主线程的操作太多、太耗时，就会造成App卡顿现象严重。所以，通常我们都会把耗时的操作放在子线程中进行，获取到结果之后，回到主线程去刷新UI。

- 多线程在一定意义上实现了进程内的资源共享，以及效率的提升。同时，在一定程度上相对独立，它是程序执行流的最小单元，是进程中的一个实体，是执行程序最基本的单元，有自己栈和寄存器。

- **同步**： 只能在当前线程按先后顺序依次执行，不开启新线程。
- **异步**： 可以在当前线程开启多个新线程执行，可不按顺序执行。
- **队列**： 装载线程任务的队形结构。
- **并发**： 线程执行可以同时一起进行执行。
- **串行**： 线程执行只能依次逐一先后有序的执行。



> 通过确保主线程自由响应用户事件，并发可以很好地提高应用的响应性。通过将工作分配到多核，还能提高应用处理的性能。但是并发也带来一定的额外开销(调度)，并且使代码更加复杂，更难编写和调试。



### 1.2 多线程概念补充

- 多线程的原理：  

  同一时间，CPU只能处理一条线程，也就是只有一条线程在工作。所谓多线程并发(同时)执行，其实是CPU快速的在多线程之间调度(切换)。如果CPU调度线程的时间足够快，就造成了多线程并发执行的假象。

- 在实际项目开发中并不是线程越多越好，如果开了大量的线程，会消耗大量的CPU资源，CPU会被累死，所以一般手机只开1~3个线程为宜，不超过5个。

- 多线程的优点：  

  能适当提高程序的执行效率  
  能适当提高资源的利用率，这个利用率表现在(CPU，内存的利用率)

- 多线程的缺点：
  1. 开启线程需要占用一定的内存空间(默认情况下，主线程占用1M，子线程占用512KB，如果开启大量的线程，会占用大量的内存空间，降低程序的性能)

  2. 线程越多，CPU在调度线程上的开销就越大

  3. 线程越多，程序设计就越复杂，比如线程之间的通信，多线程的数据共享，这些都需要程序的处理，增加了程序的复杂度。

- 在iOS开发中使用线程的注意事项：  

    1. 别将比较耗时的操作放在主线程中
    2. 耗时操作会卡住主线程，严重影响UI的流畅度，给用户一种“卡”的坏体验






## 2 四种解决方案对比
- 目前iOS多线程有四种方法：pthread，NSThread，GCD， NSOperation，四种方案的简单对比一下。

![多线程的四种方案对比](http://upload-images.jianshu.io/upload_images/1678135-a77b124e0fd294e3..png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240 "1499394732413995.png")

由于pthread平常几乎用不到，我暂时就不学了。
- 每个NSThread对象对应一个线程，真正最原始的线程，相对简单，但是需要手动管理所有的线程活动，如生命周期、线程同步、睡眠等。
- 怎么选择 ？ 
  简单而安全的选择NSOperation实现多线程即可。  
  处理大量并发数据，又追求性能效率的选择GCD。


## 3 NSTread
生命周期还是需要程序员手动管理，所以这套方案也是偶尔用用。

### 3.1 NSThread三种线程开启方式
- 动态开启
```
NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething1:) object:(@"NSThread1")];
[thread1 start];
```
- 静态开启
```
// 创建好之后直接启动
[NSThread detachNewThreadSelector:@selector(doSomething2:) toTarget:self withObject:(@"NSTread2")];
```
- 隐式开启
```
// 创建好之后也是直接启动
[self performSelectorInBackground:@selector(doSomething3:) withObject:(@"NSTread3")];
```

### 3.2 NSThread拓展
- 获取当前线程
```
NSThread *current = [NSThread currentThread]; 
```  
- 获取主线程
```
NSThread *main = [NSThread mainThread];   
```
- 暂停当前线程一段时间
```
[NSThread sleepForTimeInterval:2];
```
- 暂停当前线程到某个时间
```
[NSThread  sleepUntilDate: date];
```
- 线程之间通信
```
//在指定线程上执行操作
[self performSelector:@selector(run) onThread:thread withObject:nil waitUntilDone:YES]; 
//在主线程上执行操作
[self performSelectorOnMainThread:@selector(run) withObject:nil waitUntilDone:YES]; 
//在当前线程执行操作
[self performSelector:@selector(run) withObject:nil];
```


## 4. GCD

![](https://upload-images.jianshu.io/upload_images/1678135-485f98d116b57409.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

GCD为Grand Central Dispatch的缩写。Grand Central Dispatch (GCD)是Apple开发的一个多核编程的较新的解决方法。它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。

### 4.1 GCD的优点

- GCD 可用于多核的并行运算
- GCD 会自动利用更多的 CPU 内核（比如双核、四核）
- GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
- 程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码

###  4.2 任务和队列

- **任务**： 表现上就是一段代码，OC就对应一个Block。**任务** 有两种执行方式，*是否会创建新的线程*，*会不会阻塞当前线程*
    1. **同步执行**（sync）：在当前线程执行任务，不会开辟新的线程。必须等到Block函数执行完毕后，dispatch函数才会返回。
    2. **异步执行**（async）：可以在新的线程中执行任务，但不一定会开辟新的线程。dispatch函数会立即返回, 然后Block在后台异步执行。

- **队列**：任务管理方式。分为 **串行** 和 **并行**两种方式，都是按照 FIFO（先进先出）原则依次触发任务。

    1. **串行队列** ： 所有任务会在一条线程中执行（有可能是当前线程也有可能是新开辟的线程），并且一个任务执行完毕后，才开始执行下一个任务。（等待完成）
    2. **并行队列**： 可以开启多条线程并行执行任务（但不一定会开启新的线程），并且当一个任务放到指定线程开始执行时，下一个任务就可以开始执行了。（等待发生）

> 两者的区别：**执行顺序不同，以及开启线程数不同。**

- 两个特殊队列：

    1. **主队列**： 系统创建好的一个 **串行队列**，它管理必须在主线程中执行的任务。
    2. **全局队列**：系统为我们创建好的一个**并行队列**，使用起来与我们自己创建的并行队列无本质差别。

- 不同队列创建获取方式：
```
- (void)create {
    // dispatch_queue_create 第一个参数是队列名字，一般用app的Bundle Identifier命名方式命名；第二个参数为NULL时表是串行队列
    //串行队列
    dispatch_queue_t serialQueue = dispatch_queue_create("q1.andyron.com", NULL);
    dispatch_queue_t serialQueue2 = dispatch_queue_create("q2.andyron.com", DISPATCH_QUEUE_SERIAL);
    //并行队列
    dispatch_queue_t concurrentQueue = dispatch_queue_create("q3.andyron.com", DISPATCH_QUEUE_CONCURRENT);
    //全局并行队列    DISPATCH_QUEUE_PRIORITY_DEFAULT表示优先级
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //主队列获取
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
}
```


|     |同步执行|	异步执行|
|-------| -----| ------|
|串行队列|	当前线程，一个一个执行 |	其他线程，一个一个执行|
|并行队列|	当前线程，一个一个执行 |	开很多线程，一起执行|


### 4.3 下面👇以一个一个🌰来学习GCD，帮助搞清上面的概念

- 例子一:线程死锁（主队列 + 同步执行）
```
- (void)case1 {
    NSLog(@"A=====%@", [NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"B=====%@", [NSThread currentThread]);
    });
    NSLog(@"C=====%@", [NSThread currentThread]);
}
```
  
运行结果崩溃：  
   ![](https://upload-images.jianshu.io/upload_images/1678135-926ac158226a8ff5.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
打印结果：
```
GCD(OC)[51511:6351422] A=====<NSThread: 0x600000064340>{number = 1, name = main}
```
解释：默认就一个主队列和一个主线程，因此`case1`函数这段任务就在主队列中同步执行，`dispatch_sync...`这段代码表示把B处任务加入主队列中，并且同步执行，这就出问题，B处任务要等主队列中同步执行之前的`case1`这段任务结束后执行，但B处任务在`case1`这段任务中，`case1`又要等B处任务执行完才能继续执行。`case1`任务要等B处完成才能继续，但`case1`又排在B处前面，这就尴尬了，￣□￣｜｜，因此崩溃了😖

- 例子二：主队列 + 异步执行
```
- (void)case2 {
    NSLog(@"A=====%@", [NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"B=====%@", [NSThread currentThread]);
    });
     NSLog(@"C=====%@", [NSThread currentThread]);
}
```
结果：
```
GCD(OC)[52567:6465354] A=====<NSThread: 0x600000068d40>{number = 1, name = main}
GCD(OC)[52567:6465354] C=====<NSThread: 0x600000068d40>{number = 1, name = main}
GCD(OC)[52567:6465354] B=====<NSThread: 0x600000068d40>{number = 1, name = main}
```
解释：任务都在主队列（串行），而且只要一个主线程（name都是main），B处任务由于是异步执行，等case2任务完成后执行。

- 例子三：串行队列 + 同步执行
```
// 串行队列 + 同步执行
- (void)case3 {
    dispatch_queue_t serialQueue = dispatch_queue_create("q2.andyron.com", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(serialQueue, ^{
        NSLog(@"1======%@", [NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"2======%@", [NSThread currentThread]);
    });
    dispatch_sync(serialQueue, ^{
        NSLog(@"3======%@", [NSThread currentThread]);
    });
    NSLog(@"4======%@", [NSThread currentThread]);
}
```
结果：
```
GCD(OC)[53734:6582112] 1======<NSThread: 0x604000261700>{number = 1, name = main}
GCD(OC)[53734:6582112] 2======<NSThread: 0x604000261700>{number = 1, name = main}
GCD(OC)[53734:6582112] 3======<NSThread: 0x604000261700>{number = 1, name = main}
GCD(OC)[53734:6582112] 4======<NSThread: 0x604000261700>{number = 1, name = main}
```
解释：🌰1中的主队列也是串行队列，但和这边不同，这边是新建了另一个串行队列，不会出现冲突，并且都在主线程中运行，这也说明了同步执行不具备创建新线程的能力。

- 列子四：串行队列 + 异步执行
```
// 串行队列 + 异步执行
- (void)case4 {
    dispatch_queue_t serialQueue = dispatch_queue_create("q2.andyron.com", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSLog(@"1========%@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"2========%@",[NSThread currentThread]);
    });
    dispatch_async(serialQueue, ^{
        NSLog(@"3========%@",[NSThread currentThread]);
    });
    NSLog(@"4========%@",[NSThread currentThread]);
}
```
打印结果：
```
GCD(OC)[53970:6604711] 4========<NSThread: 0x60000007c880>{number = 1, name = main}
GCD(OC)[53970:6604933] 1========<NSThread: 0x600000460280>{number = 3, name = (null)}
GCD(OC)[53970:6604933] 2========<NSThread: 0x600000460280>{number = 3, name = (null)}
GCD(OC)[53970:6604933] 3========<NSThread: 0x600000460280>{number = 3, name = (null)}
```
解释：现在打印了4，后打印了1，2，3，这是一部执行的结果，并且4在主线程，其它在子线程打印，这也说明了异步执行可以创建新线程。

- 列子五：并行队列 + 同步执行
```
/// 并行队列 + 同步执行
- (void)case5 {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("q3.andyron.com", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"1========%@",[NSThread currentThread]);
        //[self nslogCount:10000 number:1];
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"2========%@",[NSThread currentThread]);
        //[self nslogCount:10000 number:2];
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"3========%@",[NSThread currentThread]);
        //[self nslogCount:10000 number:3];
    });
    NSLog(@"4========%@",[NSThread currentThread]);
}
```
打印结果：
```
GCD(OC)[54401:6646454] 1========<NSThread: 0x600000260e80>{number = 1, name = main}
GCD(OC)[54401:6646454] 2========<NSThread: 0x600000260e80>{number = 1, name = main}
GCD(OC)[54401:6646454] 3========<NSThread: 0x600000260e80>{number = 1, name = main}
GCD(OC)[54401:6646454] 4========<NSThread: 0x600000260e80>{number = 1, name = main}
```
解释：都在主线程执行，由于只有一个线程，结果看上去是顺序执行。

- 列子六： 并行队列 + 异步执行
```
// 并行队列 + 异步执行
- (void)case6 {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("q3.andyron.com", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"1========%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"2========%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"3========%@",[NSThread currentThread]);
    });
    NSLog(@"4========%@",[NSThread currentThread]);
}
```
打印结果：
```
GCD(OC)[54687:6675227] 2========<NSThread: 0x600000466600>{number = 5, name = (null)}
GCD(OC)[54687:6675036] 4========<NSThread: 0x604000078d00>{number = 1, name = main}
GCD(OC)[54687:6675226] 1========<NSThread: 0x600000463fc0>{number = 4, name = (null)}
GCD(OC)[54687:6675229] 3========<NSThread: 0x60400067d400>{number = 6, name = (null)}
```
解释：除了打印4的是主线，其他又开启了三个线程来执行三个任务，当天开启几个线程是有CPU自己决定的，任务的执行是随机的。


### 4.4 GCD 重点

- 只要是串行队列，肯定要等上一个任务执行完成，才能开始下一个任务。但是并行队列当上一个任务开始执行后，下一个任务就可以开始执行。
- 同步+串行：未开辟新线程，串行执行任务；同步+并行：未开辟新线程，串行执行任务；异步+串行：新开辟一条线程，串行执行任务；异步+并行：开辟多条新线程，并行执行任务；在主线程中同步使用主队列执行任务，会造成死锁。

### 4.5 GCD其他相关方法

- 延迟执行方法： `void dispatch_after(dispatch_time_t when, dispatch_queue_t queue, dispatch_block_t block);`
指定时间后执行某个任务，`dispatch_after`函数指定的时间是指多长后将任务加到某个队列中，而不是具体执行时间，具体时间要看CPU执行时间了，可以看做是个大约延迟时间。
```
- (void)after {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}
```

- `dispatch_once`：在生命周期内只执行一次。
```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"就一次%@",[NSThread currentThread]);
    });
}
```
不管点击多少次只有一次输出。


GCD的内容很丰富，还有很多函数，2016和2017的WWDC都有专门讲到GCD，想更近一步可以参考：[Modernizing Grand Central Dispatch Usage](https://developer.apple.com/videos/play/wwdc2017/706/)，[Concurrent Programming With GCD in Swift 3](https://developer.apple.com/videos/play/wwdc2016/720/)。




## 5 NSOperation 和 NSOperationQueue

### 5.1 概念

-  `NSOperation`(**操作**) 和 `NSOperationQueue`（**操作队列**） 是苹果对GCD的封装
- `NSOperation` 和 `NSOperationQueue` 分别相当于 GCD 的 **任务** 和 **队列**
- `NSOperation` 只是一个抽象类，不能直接使用，使用其 2 个子类：`NSInvocationOperation` 和 `NSBlockOperation` 。
- `NSOperation`的使用除了其现有的子类，还可以自定义子类。

- 操作队列通过设置最大并发操作数（maxConcurrentOperationCount）来控制并发、串行。
- NSOperationQueue 为我们提供了两种不同类型的队列：主队列和自定义队列。主队列运行在主线程之上，而自定义队列在后台执行。


- NSOperation 需要配合 NSOperationQueue 来使用。否则，NSOperation 单独使用时系统默认同步执行操作，配合 NSOperationQueue 我们能更好的实现异步执行。

### 5. 2 NSOperation 实现多线程的步骤
  1. 创建操作：先将需要执行的操作封装到一个 NSOperation 对象中。  
  2. 创建队列：创建 NSOperationQueue 对象。  
  3. 将操作加入到队列中：将 NSOperation 对象添加到NSOperationQueue 对象中。  
  4. 之后，系统就会自动将 NSOperationQueue 中的 NSOperation 取出来，在新线程中执行操作。  


### 5.3 使用NSOperation的子类NSInvocationOperation
```
NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
[operation start];
```
在没有使用`NSOperationQueue`时，`NSInvocationOperation`会在当前线程（主线程或其他线程）内运行。

### 5.4 使用NSOperation的子类NSBlockOperation
```
NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
[operation start];
```

结果：

```
NSOperation(OC)[97406:5880178] 1---<NSThread: 0x60400006e700>{number = 1, name = main}
NSOperation(OC)[97406:5880178] 1---<NSThread: 0x60400006e700>{number = 1, name = main}
```

在没有使用`NSOperationQueue`时，`NSBlockOperation `也会在当前线程（主线程或其他线程）内运行。

另外，`NSBlockOperation`还提供了一个方法 `addExecutionBlock:`，用来添加额外的操作：

```
// 1.创建 NSBlockOperation 对象
NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
    
   NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程

}];
// 2.添加额外的操作
[op addExecutionBlock:^{
    [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
    NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    
}];
[op addExecutionBlock:^{
    [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
    NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    
}];
[op addExecutionBlock:^{
    [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
    NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
    
}];
[op addExecutionBlock:^{
    [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
    NSLog(@"5---%@", [NSThread currentThread]); // 打印当前线程
    
}];
// 3.调用 start 方法开始执行操作
[op start];

```

某一次的运行结果：

```
NSOperation(OC)[97709:5888750] 1---<NSThread: 0x600000469740>{number = 3, name = (null)}
NSOperation(OC)[97709:5888750] 5---<NSThread: 0x600000469740>{number = 3, name = (null)}
NSOperation(OC)[97709:5888748] 3---<NSThread: 0x600000469e40>{number = 4, name = (null)}
NSOperation(OC)[97709:5888498] 4---<NSThread: 0x60400007a600>{number = 1, name = main}
NSOperation(OC)[97709:5888758] 2---<NSThread: 0x604000463480>{number = 5, name = (null)}
```

`addExecutionBlock:`添加的操作和之前`blockOperationWithBlock`添加的操作是否在主线程或者是否开多线程，是由系统决定，它们的地位是相同的，所以每一次执行的结果可能不同。

### 5.5 NSOperation的自定义子类

除了上面两个子类外，还可以通过重写`main`方法来自定义子类。
```
#import "AROperation.h"

@implementation AROperation

- (void)main {
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"自定义Operation---%@", [NSThread currentThread]);
        }
    }
}
@end
```
使用：
```
AROperation *op = [[AROperation alloc] init];
[op start];
```

### 5.6 NSOperationQueue

上面几种情况都是没有操作队列，一般只在主线程运行。而使用操作队列就可以实现多线程了。操作队列分两种：  
 
 **主队列** :   凡是添加到主队列中的操作，都会放到主线程中执行  
 **自定义队列**:  操作自动放到子线程中执行，同时包含了：串行、并发功能。

#### 5.6.1 创建队列

```
// 主队列获取方法
NSOperationQueue *queue = [NSOperationQueue mainQueue];

// 自定义队列创建方法
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
```

#### 5.6.2 添加操作到队列中

两种不同的添加方法：
- `- (void)addOperation:(NSOperation *)op;`
```
- (void)addOperationToQueue {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.创建操作
    // 使用 NSInvocationOperation 创建操作1
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    
    // 使用 NSInvocationOperation 创建操作2
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    
    // 使用 NSBlockOperation 创建操作3
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op3 addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    // 3.使用 addOperation: 添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
}
- (void) task1 {
    NSLog(@"1---%@", [NSThread currentThread]);
}
- (void) task2 {
    NSLog(@"2---%@", [NSThread currentThread]);
}
```
某一次的运行结果：
```
NSOperation(OC)[7557:6218702] 2---<NSThread: 0x60400027f900>{number = 4, name = (null)}
NSOperation(OC)[7557:6218699] 1---<NSThread: 0x600000461a00>{number = 3, name = (null)}
NSOperation(OC)[7557:6218701] 4---<NSThread: 0x6040004606c0>{number = 5, name = (null)}
NSOperation(OC)[7557:6218700] 3---<NSThread: 0x604000460d40>{number = 6, name = (null)}
NSOperation(OC)[7557:6218700] 3---<NSThread: 0x604000460d40>{number = 6, name = (null)}
NSOperation(OC)[7557:6218701] 4---<NSThread: 0x6040004606c0>{number = 5, name = (null)}
```
并发运行，执行次序不确定。

- `- (void)addOperationWithBlock:(void (^)(void))block;`  不需要先创建操作，直接添加block
```
- (void)addOperationWithBlockToQueue {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.使用 addOperationWithBlock: 添加操作到队列中
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}
```
某一次的运行结果：
```
NSOperation(OC)[7772:6229770] 2---<NSThread: 0x600000277640>{number = 5, name = (null)}
NSOperation(OC)[7772:6229772] 1---<NSThread: 0x60400026bfc0>{number = 4, name = (null)}
NSOperation(OC)[7772:6229780] 3---<NSThread: 0x6040002686c0>{number = 3, name = (null)}
NSOperation(OC)[7772:6229770] 2---<NSThread: 0x600000277640>{number = 5, name = (null)}
NSOperation(OC)[7772:6229780] 3---<NSThread: 0x6040002686c0>{number = 3, name = (null)}
NSOperation(OC)[7772:6229772] 1---<NSThread: 0x60400026bfc0>{number = 4, name = (null)}
```

#### 5.6.3 maxConcurrentOperationCount
`NSOperationQueue` 提供一个`maxConcurrentOperationCount`（**最大并发操作数**）属性来控制串行还是并发。  
`maxConcurrentOperationCount` 控制的不是并发线程的数量，而是一个队列中同时能并发执行的最大操作数。而且一个操作也并非只能在一个线程中运行。  
`maxConcurrentOperationCount `默认情况下为-1，表示不进行限制。

```
- (void)setMaxConcurrentOperationCount {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.设置最大并发操作数
    queue.maxConcurrentOperationCount = 1; // 串行队列
    //     queue.maxConcurrentOperationCount = 2; // 并发队列
    //     queue.maxConcurrentOperationCount = 8; // 并发队列
    
    // 3.添加操作
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
}
```
当**最大并发操作数**为1时，也就是串行执行时，控制台中返回的结果顺序是固定的。而大于1时，也就是并发执行，每一次执行的顺序就可能不同（控制台中返回的额结果顺序可能不同）。当然开启的线程数量是有系统决定的。


### 5.7 NSOperation之间的依赖
并行时，各个的操作的执行顺序是有系统决定，程序员不能直接控制。但是NSOperation提高了依赖，来解决这个问题。相关方法和属性：  

- `- (void)addDependency:(NSOperation *)op;`     添加依赖，使当前操作依赖于操作 op 的完成。  
- `- (void)removeDependency:(NSOperation *)op;`     移除依赖，取消当前操作对操作 op 的依赖。  
- `@property (readonly, copy) NSArray<NSOperation *> *dependencies;`     在当前操作开始执行之前完成执行的所有操作对象数组。

```
- (void)addDependency {
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // 2.创建操作
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    // 3.添加依赖
    [op2 addDependency:op1]; // 让op2 依赖于 op1，则先执行op1，再执行op2
    
    // 4.添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}
```
运行结果是固定的：
```
NSOperation(OC)[8977:6302811] 1---<NSThread: 0x604000277f80>{number = 3, name = (null)}
NSOperation(OC)[8977:6302811] 1---<NSThread: 0x604000277f80>{number = 3, name = (null)}
NSOperation(OC)[8977:6302810] 2---<NSThread: 0x604000274240>{number = 4, name = (null)}
NSOperation(OC)[8977:6302810] 2---<NSThread: 0x604000274240>{number = 4, name = (null)}
```
> `注意`：不能添加相互依赖，会死锁，比如 A依赖B，B依赖A。
可以使用 removeDependency 来解除依赖关系。
可以在不同的队列之间依赖，反正就是这个依赖是添加到任务身上的，和队列没关系。



### 5.8 NSOperation 常用属性和方法

- 取消操作方法
  `- (void)cancel;`     实质是标记 isCancelled 状态。

- 判断操作状态方法

  + `- (BOOL)isFinished;`     判断操作是否已经结束。  
  + `- (BOOL)isCancelled;`  判断操作是否已经标记为取消。  
  + `- (BOOL)isExecuting;`  判断操作是否正在在运行。  
  + `- (BOOL)isReady;`        判断操作是否处于准备就绪状态，这个值和操作的依赖关系相关。

- 操作同步

  + `- (void)waitUntilFinished;` 阻塞当前线程，直到该操作结束。可用于线程执行顺序的同步。
  + `- (void)setCompletionBlock:(void (^)(void))block;` completionBlock 会在当前操作执行完毕时执行 completionBlock。
  + `- (void)addDependency:(NSOperation *)op;`  添加依赖，使当前操作依赖于操作 op 的完成。
  + `- (void)removeDependency:(NSOperation *)op;`  移除依赖，取消当前操作对操作 op 的依赖。
  + `@property (readonly, copy) NSArray<NSOperation *> *dependencies;` 在当前操作开始执行之前完成执行的所有操作对象数组。

### 5.9 NSOperationQueue 常用属性和方法

1. 取消/暂停/恢复操作
  + `- (void)cancelAllOperations;` 可以取消队列的所有操作。
  + `- (BOOL)isSuspended;` 判断队列是否处于暂停状态。 YES 为暂停状态，NO 为恢复状态。
  + `- (void)setSuspended:(BOOL)b;` 可设置操作的暂停和恢复，YES 代表暂停队列，NO 代表恢复队列。

2. 操作同步
  + `- (void)waitUntilAllOperationsAreFinished;` 阻塞当前线程，直到队列中的操作全部执行完毕。
3. 添加/获取操作
  + `- (void)addOperationWithBlock:(void (^)(void))block;` 向队列中添加一个 NSBlockOperation 类型操作对象。
  + `- (void)addOperations:(NSArray *)ops waitUntilFinished:(BOOL)wait;` 向队列中添加操作数组，wait 标志是否阻塞当前线程直到所有操作结束
  + `- (NSArray *)operations;` 当前在队列中的操作数组（某个操作执行结束后会自动从这个数组清除）。
  + `- (NSUInteger)operationCount;` 当前队列中的操作数。
4. 获取队列
  + `+ (id)currentQueue;` 获取当前队列，如果当前线程不是在 NSOperationQueue 上运行则返回 nil。
  + `+ (id)mainQueue;` 获取主队列。

 
## 6 后记
虽然总结了很多，但还有很多内容没有涉及和深入。
由于个人能力有限，时间紧凑（实际我已经花了很多时间😒🤦‍♀️🤦‍♀️），文中难免有错误，希望小伙伴批评指正。



> 示例代码：**[andyRon/iOS-Multithreading](https://github.com/andyRon/iOS-Multithreading)**

> 参考：
[关于iOS多线程，我说，你听，没准你就懂了！](https://www.jianshu.com/p/51fd1362249e)  
[谈iOS多线程(NSThread、NSOperation、GCD)编程](http://www.jianshu.com/p/6e6f4e005a0b)  
[iOS多线程：『GCD』详尽总结](http://www.jianshu.com/p/2d57c72016c6)  
[iOS多线程：『pthread、NSThread』详尽总结](https://www.jianshu.com/p/cbaeea5368b1)  
[iOS多线程：『NSOperation、NSOperationQueue』详尽总结](https://www.jianshu.com/p/4b1d77054b35)  
[关于iOS多线程，你看我就够了](https://www.jianshu.com/p/0b0d9b1f1f19)  
[Grand Central Dispatch (GCD) and Dispatch Queues in Swift 3](https://www.appcoda.com/grand-central-dispatch/)  
[WWDC-2017-Modernizing Grand Central Dispatch Usage](https://developer.apple.com/videos/play/wwdc2017/706/)  
