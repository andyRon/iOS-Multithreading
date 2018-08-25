//
//  ViewController.m
//  NSThread(OC)
//
//  Created by andyron<http://andyron.com> on 2018/3/14.
//  Copyright © 2018年 andyron. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self case1];
//    [self case2];
//    [self case3];
}
// 动态实例 开启线程
- (void)case1 {
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(doSomething1:) object:(@"NSThread1")];
    [thread1 start];
    [NSThread sleepForTimeInterval:5];
    NSLog(@"当前线程: %@, %@, %@", [NSThread currentThread], [thread1 name], [NSThread mainThread]);
}

- (void)doSomething1: (NSObject *)object {
    NSLog(@"在doSomething中：%@", object);
    NSLog(@"doSomething1: %@", [NSThread currentThread]);
}


// 静态实例 开启线程
- (void)case2 {
    // 创建好之后直接启动
    [NSThread detachNewThreadSelector:@selector(doSomething2:) toTarget:self withObject:(@"NSTread2")];
    NSLog(@"当前线程: %@", [NSThread currentThread]);
}
- (void)doSomething2:(NSObject *)object {
    NSLog(@"%@", object);
    NSLog(@"doSomething2: %@", [NSThread currentThread]);
}


// 隐式实例 开启线程，方法是NSObject的类别里
- (void)case3 {
    // 创建好之后也是直接启动
    [self performSelectorInBackground:@selector(doSomething3:) withObject:(@"NSTread3")];
    NSLog(@"当前线程: %@", [NSThread currentThread]);
}
- (void)doSomething3:(NSObject *)object {
    NSLog(@"%@", object);
    NSLog(@"doSomething3: %@", [NSThread currentThread]);
}
@end
