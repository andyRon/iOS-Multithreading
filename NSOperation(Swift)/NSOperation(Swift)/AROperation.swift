//
//  AROperation.swift
//  NSOperation(Swift)
//
//  Created by Andy Ron on 2018/8/26.
//  Copyright © 2018年 Andy Ron. All rights reserved.
//

import UIKit

class AROperation: Operation {

    override func main() {
        if !self.isCancelled {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("自定义Operation----\(Thread.current)")
            }
        }
    }
    
}
