//
//  ViewController.swift
//  NSOperation(Swift)
//
//  Created by Andy Ron on 2018/8/26.
//  Copyright © 2018年 Andy Ron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        create()
//        useBlockOperationAddExecutionBlock()
//        useCustomOperation()
//        mainQueue()
//        createQueue()
        
//        addOperationToQueue()
//        setMaxConcurrentOperationCount()
        addDependency()
    }

    func create() {
        let operation = BlockOperation {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 2)
                print("1----\(Thread.current)")
            }
        }
        operation.start()
    }
    
    func useBlockOperationAddExecutionBlock() {
        let op = BlockOperation{
            print("1----\(Thread.current)")
        }
        
        op.addExecutionBlock {
            Thread.sleep(forTimeInterval: 1)
            print("2----\(Thread.current)")
        }
        op.addExecutionBlock {
            Thread.sleep(forTimeInterval: 1)
            print("3----\(Thread.current)")
        }
        op.addExecutionBlock {
            Thread.sleep(forTimeInterval: 1)
            print("4----\(Thread.current)")
        }
        op.addExecutionBlock {
            Thread.sleep(forTimeInterval: 1)
            print("5----\(Thread.current)")
        }

        op.start()
    }
    
    func useCustomOperation() {
        let op = AROperation()
        op.start()
    }
    
    func mainQueue() {
        let mainQueue = OperationQueue.main
        mainQueue.addOperation {
            Thread.sleep(forTimeInterval: 1)
            print("1----\(Thread.current)")
        }
        mainQueue.addOperation {
            Thread.sleep(forTimeInterval: 1)
            print("2----\(Thread.current)")
        }
        mainQueue.addOperation {
            Thread.sleep(forTimeInterval: 1)
            print("3----\(Thread.current)")
        }
        mainQueue.addOperation {
            Thread.sleep(forTimeInterval: 1)
            print("4----\(Thread.current)")
        }
    }
    
    func createQueue() {
        let queue = OperationQueue()
        let op = BlockOperation{
            print(Thread.current)
        }
        
        for i in 0..<5 {
            op.addExecutionBlock {
                print("第\(i)次block：\(Thread.current)")
            }
        }
        queue.addOperation(op)
    }
    
    func addOperationToQueue() {
        let queue = OperationQueue()
        let op1 = BlockOperation{
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("1----\(Thread.current)")
            }
        }
        op1.addExecutionBlock {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("2----\(Thread.current)")
            }
        }
        
        queue.addOperation(op1)
        
        queue.addOperation {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("3----\(Thread.current)")
            }
        }
    }
    
    func setMaxConcurrentOperationCount() {
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
//        queue.maxConcurrentOperationCount = 2
//        queue.maxConcurrentOperationCount = 5

        
        queue.addOperation {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("1----\(Thread.current)")
            }
        }
        queue.addOperation {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("2----\(Thread.current)")
            }
        }
        queue.addOperation {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("3----\(Thread.current)")
            }
        }
        queue.addOperation {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("4----\(Thread.current)")
            }
        }
    }

    
    func addDependency() {
        let queue = OperationQueue()
        
        let op1 = BlockOperation {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("1----\(Thread.current)")
            }
        }
        
        let op2 = BlockOperation {
            for _ in 0..<2 {
                Thread.sleep(forTimeInterval: 1)
                print("2----\(Thread.current)")
            }
        }
        
        op2.addDependency(op1)
        
        queue.addOperation(op1)
        queue.addOperation(op2)
    }

}

