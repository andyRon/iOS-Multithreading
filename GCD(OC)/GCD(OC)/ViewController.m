//
//  ViewController.m
//  GCD(OC)
//
//  Created by andyron<http://andyron.com> on 2018/3/15.
//  Copyright © 2018年 andyron. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];

//    [self case1];
//    [self case2];
//    [self case3];
//    [self case4];
//    [self case5];
//    [self case6];
    
    [self after];
   
    
}

// 不同队列创建获取
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

/*  创建同步任务，会阻塞当前线程 (SYNC)
 结果只会打印前面的一部分
 打印完第一句后，dispatch_sync 立即阻塞当前的主线程，然后把 Block 中的任务放到 main_queue 中，可是 main_queue 中的任务会被取出来放到主线程中执行，但主线程这个时候已经被阻塞了，所以 Block 中的任务就不能完成，它不完成，dispatch_sync 就会一直阻塞主线程，这就是死锁现象。导致主线程一直卡死。
 
 主队列 + 同步执行
 */
- (void)case1 {
    NSLog(@"A=====%@", [NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"B=====%@", [NSThread currentThread]);
    });
    NSLog(@"C=====%@", [NSThread currentThread]);
}
// 创建异步任务，不会阻塞当前线程 (ASYNC)
// 主队列 + 异步执行
- (void)case2 {
    NSLog(@"A=====%@", [NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"B=====%@", [NSThread currentThread]);
    });
     NSLog(@"C=====%@", [NSThread currentThread]);
}
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

/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2.0秒后异步追加任务代码到主队列，并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);  // 打印当前线程
    });
}


/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 异步追加任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
            
        }
        
        // 回到主线程
        dispatch_async(mainQueue, ^{
            // 追加在主线程中执行的任务
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2----%@",[NSThread currentThread]);      // 打印当前线程
        });
    });
}
















/**
 2018-03-15 17:14:43.347287+0800 GCD(OC)[18729:22001166] 前 - <NSThread: 0x600000070300>{number = 1, name = main}
 2018-03-15 17:14:43.347496+0800 GCD(OC)[18729:22001166] 后 - <NSThread: 0x600000070300>{number = 1, name = main}
 2018-03-15 17:14:43.347522+0800 GCD(OC)[18729:22001511] sync之前 - <NSThread: 0x60000027e800>{number = 3, name = (null)}
 ------
 `dispatch_sync`同步执行，于是它所在的线程会被阻塞，一直等到 `sync` 里的任务执行完才会继续往下。于是 `sync` 就高兴的把自己 Block 中的任务放到 `queue` 中，可谁想 `queue` 是一个串行队列，一次执行一个任务，所以 `sync` 的 Block 必须等到前一个任务执行完毕，可万万没想到的是 `queue` 正在执行的任务就是被 `sync` 阻塞了的那个。于是又发生了死锁。所以 `sync` 所在的线程被卡死了。剩下的两句代码自然不会打印。
 */
- (void)create_1 {
    dispatch_queue_t queue = dispatch_queue_create("myQueue",DISPATCH_QUEUE_SERIAL);

    NSLog(@"前 - %@", [NSThread currentThread]);
    dispatch_async(queue, ^{
        NSLog(@"sync之前 - %@", [NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"sync - %@", [NSThread currentThread]);
        });
        NSLog(@"sync之后 - %@", [NSThread currentThread]);
    });
    NSLog(@"后 - %@", [NSThread currentThread]);
}
/// 队列组
- (void)duiliezu {
    //1.创建队列组
    dispatch_group_t group = dispatch_group_create();
    //2.创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    //3.多次使用队列组的方法执行任务, 只有异步方法
    //3.1.执行3次循环
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group-a,%d - %@",i, [NSThread currentThread]);
        }
    });
    
    //3.2.主队列执行8次循环
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        for (NSInteger i = 0; i < 8; i++) {
            NSLog(@"group-02 - %@", [NSThread currentThread]);
        }
    });
    
    //3.3.执行5次循环
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 5; i++) {
            NSLog(@"group-03 - %@", [NSThread currentThread]);
        }
    });
    
    //4.都完成后会自动通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"完成 - %@", [NSThread currentThread]);
    });

}

/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncConcurrent---end");
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。   执行的顺序不是固定的。
 */
- (void)asyncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}

/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncSerial---end");
}

/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncSerial---end");
}


// dispatch_once 在整个生命周期内只会执行一次
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"就一次%@",[NSThread currentThread]);
    });
}








@end
