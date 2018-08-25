//
//  AROperation.m
//  NSOperation(OC)
//
//  Created by andyron<http://andyron.com> on 2018/3/15.
//  Copyright © 2018年 andyron. All rights reserved.
//

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
