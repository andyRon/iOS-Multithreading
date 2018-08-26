//
//  ViewController.m
//  NSOperation(OC)
//
//  Created by andyron<http://andyron.com> on 2018/3/15.
//  Copyright © 2018年 andyron. All rights reserved.
//

#import "ViewController.h"
#import "AROperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self creat1];
//    [self creat2];
//    [self useBlockOperationAddExecutionBlock];
    
//    [self useCustomOperation];
//    [self mainQueue];
//    [self creatQueue];
//    [self addOperationToQueue];
//    [self addOperationWithBlockToQueue];
    
    
    
//    [self setMaxConcurrentOperationCount];
    
//    [self addDependency];

    
}
// 使用NSInvocationOperation
- (void)creat1 {
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    [operation start];
}
- (void)run {
    NSLog(@"这是NSInvocationOperation创建");
}

// 使用NSBlockOperation
- (void)creat2 {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [operation start];
}

/**
 * 使用子类 NSBlockOperation
 * 调用方法 AddExecutionBlock:
 每一次代码的执行，block执行顺序是不同的，因为被分配不同线程中异步执行的，
 */
- (void)useBlockOperationAddExecutionBlock {
    
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
}

// 使用自定义子类
-(void)useCustomOperation {
    AROperation *op = [[AROperation alloc] init];
    [op start];
}

// 使用主队列，主队列在主线程中串行执行
- (void)mainQueue {
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [mainQueue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    }];
    [mainQueue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
        NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    }];
    [mainQueue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
        NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    }];
    [mainQueue addOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1]; // 模拟耗时操作
        NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
    }];
}

// 创建其他队列(自定义队列)
- (void)creatQueue {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    for (NSInteger i = 0; i < 5;  i++) {
        [operation addExecutionBlock:^{
            NSLog(@"第%ld次block：%@", i, [NSThread currentThread]);
        }];
    }
    [queue addOperation:operation];
   
}

/**
 * 使用 addOperation: 将操作加入到操作队列中
 */
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

/**
 * 使用 addOperationWithBlock: 将操作加入到操作队列中
 */
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

/**
 * 设置 MaxConcurrentOperationCount（最大并发操作数）
 */
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


/**
 * 操作依赖
 * 使用方法：addDependency:
 */
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








@end
