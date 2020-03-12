//
//  NetworkActivityService.swift
//  LydiaNetwork
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony

// MARK: - NetworkActivityService Protocol

public protocol NetworkActivityServiceProtocol {
  var countRequest: MutexCounter { get set }
  func newRequestStarted() -> Int
  func requestFinished() -> Int
  func disableActivityIndicator()
}

// MARK: - NetworkActivityService

public final class NetworkActivityService: NetworkActivityServiceProtocol {

    public static let sharedInstance = NetworkActivityService()

    public var countRequest: MutexCounter = MutexCounter()

    private let maxActivityDuration: Double = 120 //in seconds

    private var disableActivityIndicatorClosure: DispatchQueue.CancellableClosure = nil

    private init() {

    }

    @discardableResult
    public func newRequestStarted() -> Int {
        let count = countRequest.incrementAndGet()
        if let closure = disableActivityIndicatorClosure {
            closure()
        }

        disableActivityIndicatorClosure = DispatchQueue.main.cancellableAsyncAfter(secondsDeadline: maxActivityDuration) {
            self.disableActivityIndicator()
        }
        guard #available(iOS 13.0, *) else {
            if !UIApplication.shared.isNetworkActivityIndicatorVisible {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            return count
        }
        return count
    }

    @discardableResult
    public func requestFinished() -> Int {
        let currentCounter = countRequest.decrementAndGet()

        if currentCounter <= 0 {
            if let closure = disableActivityIndicatorClosure {
                closure()
            }
            countRequest.setValue(0)
            guard #available(iOS 13, *) else {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                return currentCounter
            }

        }
        return currentCounter
    }

    public func disableActivityIndicator() {
        if let closure = disableActivityIndicatorClosure {
            closure()
        }
        countRequest.setValue(0)
        guard #available(iOS 13, *) else {
            DispatchQueue.main.async {
                       UIApplication.shared.isNetworkActivityIndicatorVisible = false
                   }
            return
        }
    }

}
