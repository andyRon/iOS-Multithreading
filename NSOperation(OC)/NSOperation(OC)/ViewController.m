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

    
    [self create_yilai];
//
    
//    [self useBlockOperationAddExecutionBlock];
//    [self mainQueue];
//    [self setMaxConcurrentOperationCount];
    
}
/// 创建NSInvocationOperation, NSInvocationOperation需要调用另外的方法
- (void)creat1 {
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    [operation start];
}
- (void)run {
    
}

- (void)creat2 {
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    for (NSInteger i = 0; i < 5;  i++) {
        [operation2 addExecutionBlock:^{
            NSLog(@"第%ld次block：%@", i, [NSThread currentThread]);
        }];
    }
    [operation2 start];
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

/// 使用主队列，主队列在主线程中串行执行
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

/// 创建其他队列(自定义队列)
- (void)creat3 {
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
/// 添加依赖
- (void)create_yilai {
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"上水印 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"上传图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    [operation2 addDependency:operation1];
    [operation3 addDependency:operation2];
    
    
//    NSLog(@"operation2: %@", operation2);
//    NSLog(@"依赖的哪些：%@", [operation3 dependencies]);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation1, operation2, operation3] waitUntilFinished:NO];
    
    NSLog(@"任务数：%d", [queue operationCount]);
    
    
}

-(void)useCustomOperation {
    AROperation *op = [[AROperation alloc] init];
    [op start];
}

/**
 * 设置 MaxConcurrentOperationCount（最大并发操作数）
 */
- (void)setMaxConcurrentOperationCount {
    
    // 1.创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 2.设置最大并发操作数
//    queue.maxConcurrentOperationCount = 1; // 串行队列
     queue.maxConcurrentOperationCount = 2; // 并发队列
    // queue.maxConcurrentOperationCount = 8; // 并发队列
    
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


@end
