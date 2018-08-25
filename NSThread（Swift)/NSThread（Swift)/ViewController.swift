//
//  ViewController.swift
//  NSThread（Swift)
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
        case3()
    }

    func case1() {
        let thread = Thread(target: self, selector: #selector(ViewController.doSomething1(object:)), object: "thread1")
        thread.start()
    }
    @objc func doSomething1(object: NSObject) {
        print("在doSomething1中：\(object)")
        print("doSomething1:\(Thread.current)")
    }
    
    func case2() {
        Thread.detachNewThreadSelector(#selector(ViewController.doSomething2(object:)), toTarget: self, with: "thread1")
    }

    @objc func doSomething2(object: NSObject) {
        print("在doSomething2中：\(object)")
        print("doSomething2:\(Thread.current)")
    }
    
    func case3() {
        self.performSelector(inBackground: #selector(ViewController.doSomething3(object:)), with: "thread3")
    }
    
    @objc func doSomething3(object: NSObject) {
        print("在doSomething3中：\(object)")
        print("doSomething3:\(Thread.current)")
    }
}

