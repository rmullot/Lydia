//
//  ReachabilityService.swift
//  LydiaNetwork
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import CoreTelephony
import UIKit

// MARK: - OnlineMode

public enum OnlineMode: Int {
    case offline = 0
    case onlineSlow = 1
    case online = 2
}

// MARK: - Reachability Manager Delegate

public protocol ReachabilityServiceDelegate: class {
    var onlineMode: OnlineMode {get}
    func onlineModeChanged(_ onlineMode: OnlineMode)
}

// MARK: - ReachabilityService

public final class ReachabilityService {

    // MARK: Properties

    public static let sharedInstance = ReachabilityService()

    public private(set) var delegates = MulticastDelegate<ReachabilityServiceDelegate>()

    private var reachability: Reachability?

    private let telephonyInfo = CTTelephonyNetworkInfo()

    private var _onlineMode: OnlineMode = .online

    private(set) var onlineMode: OnlineMode {
        set {
            _onlineMode = newValue
            delegates.invoke { (delegate) in
                delegate.onlineModeChanged(_onlineMode)
            }
        }

        get {
            return _onlineMode
        }
    }

    private let changeOperatingModeDelay: Double = 2.0 //in seconds

    private var changeOperatinModeClosure: DispatchQueue.CancellableClosure?

    private init() {
        delegates = MulticastDelegate<ReachabilityServiceDelegate>.init(addClosure: {delegate in
            delegate.onlineModeChanged(self.onlineMode)
        })
        onlineMode = .online
        do {
            reachability = try Reachability()
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(ReachabilityService.reachabilityChanged(_:)),
                                                   name: .reachabilityChanged,
                                                   object: reachability)

            try reachability?.startNotifier()
        } catch let error {
            print("Reachability Error: \(error)")
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ReachabilityService.refreshReachability),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Reachability changed

    @objc func refreshReachability() {
        if let reachability = reachability {
            NotificationCenter.default.post(name: .reachabilityChanged, object: reachability)
        }
    }

    @objc func reachabilityChanged(_ note: Notification) {
        // === to check the reference of the object
        guard let noteReachability = note.object as? Reachability, let reachability = self.reachability, reachability === noteReachability else {
            return
        }

        if reachability.connection != .unavailable {
            //handle slow / fast mode here
            guard #available(iOS 12, *) else {
                if let currentRadioAccessTechnology = telephonyInfo.currentRadioAccessTechnology {
                    switch currentRadioAccessTechnology {
                    case CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x,
                         CTRadioAccessTechnologyGPRS:
                        //slow mode
                        changeOnlineMode(.onlineSlow)
                    default:
                        //fast mode
                        changeOnlineMode(.online)
                    }
                } else {
                    changeOnlineMode(.online)
                }
                return
            }
           changeOnlineMode(.online)
        } else {
            changeOnlineMode(.offline)
        }
    }

    func changeOnlineMode(_ onlineMode: OnlineMode) {

        if let closure = changeOperatinModeClosure {
            closure!()
        }

        if onlineMode == .online || onlineMode == .onlineSlow {
            self.onlineMode = onlineMode
        } else {
            changeOperatinModeClosure = DispatchQueue.main.cancellableAsyncAfter(secondsDeadline: changeOperatingModeDelay) {
                self.onlineMode = onlineMode
            }
        }
    }

}
