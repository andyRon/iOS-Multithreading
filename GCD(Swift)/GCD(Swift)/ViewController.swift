//
//  ViewController.swift
//  GCD(Swift)
//
//  Created by andyron<http://andyron.com> on 2018/3/15.
//  Copyright © 2018年 andyron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        case1()
//        case2()
//        case3()
//        case4()
//        case5()
//        case6()
    }

    func create() {
        // 串行队列
        let queue1 = DispatchQueue(label: "q1.andyron.com")
        
        // 并行队列
        let queue2 = DispatchQueue(label: "q2.andyron.com", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        // 全局队列
        let queue3 = DispatchQueue.global()
        // 主队列
        let main = DispatchQueue.main
    }
    
    //  主队列 + 同步执行
    func case1() {
        print("A=====\(Thread.current)")
        DispatchQueue.main.sync {
            print("B=====\(Thread.current)")
        }
        print("C=====\(Thread.current)")
    }
    // 主队列 + 异步执行
    func case2() {
        print("A=====\(Thread.current)")
        DispatchQueue.main.async {
            print("B=====\(Thread.current)")
        }
        print("C=====\(Thread.current)")
    }
    // 串行队列 + 同步执行
    func case3() {
        let queue = DispatchQueue(label: "q.andyron.com")
        queue.sync {
            print("1======\(Thread.current)")
        }
        queue.sync {
            print("2======\(Thread.current)")
        }
        queue.sync {
            print("3======\(Thread.current)")
        }
        print("4======\(Thread.current)")
    }
    // 串行队列 + 异步执行
    func case4() {
        let queue = DispatchQueue(label: "q.andyron.com")
        queue.async {
            print("1======\(Thread.current)")
        }
        queue.async {
            print("2======\(Thread.current)")
        }
        queue.async {
            print("3======\(Thread.current)")
        }
        print("4======\(Thread.current)")
    }
    // 并行队列 + 同步执行
    func case5() {
        let queue = DispatchQueue(label: "q.andyron.com", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue.sync {
            print("1======\(Thread.current)")
        }
        queue.sync {
            print("2======\(Thread.current)")
        }
        queue.sync {
            print("3======\(Thread.current)")
        }
        print("4======\(Thread.current)")

    }
    // 并行队列 + 异步执行
    func case6() {
        let queue = DispatchQueue(label: "q.andyron.com", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue.async {
            print("1======\(Thread.current)")
        }
        queue.async {
            print("2======\(Thread.current)")
        }
        queue.async {
            print("3======\(Thread.current)")
        }
        
        print("4======\(Thread.current)")
    }

}


