//
//  MultiCastDelegate.swift
//  LydiaNetwork
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

public final class MulticastDelegate <T> {

  private let lockQueue = DispatchQueue.global(qos: .utility)

  private let semaphore = DispatchSemaphore(value: 1)

  private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

  fileprivate let addClosure: ((T) -> Void)?

  public init(addClosure: ((T) -> Void)? = nil) {
    self.addClosure = addClosure
  }

  public func add(_ delegate: T) {
    self.lockQueue.sync {
        self.semaphore.wait()
        delegates.add(delegate as AnyObject)
        self.addClosure?(delegate)
        self.semaphore.signal()
    }
  }

  public func remove(_ delegate: T) {
    self.lockQueue.sync {
        self.semaphore.wait()
        delegates.allObjects.filter { $0 === delegate as AnyObject }.reversed().forEach {
            delegates.remove($0)
        }
        self.semaphore.signal()
    }
  }

  public func invoke(_ invocation: (T) -> Void) {
    self.lockQueue.sync {
      delegates.allObjects.reversed().forEach {
        if let delegate = $0 as? T {
          invocation(delegate)
        }
      }
    }
  }

}
