//
//  InjectionMap.swift
//  LydiaCore
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

public protocol InjectionMapServiceProtocol {
  func register<T>(_ factory: T)
  func resolve<T>() -> T
  func reboot()
}

/// Design Pattern InversionOfControl
public final class InjectionMapService: InjectionMapServiceProtocol {

  public static let sharedInstance = InjectionMapService()

  private var registrations = [String: Any]()

  public func register<T>( _ factory: T) {
    let key = String(describing: T.self)
    registrations[key] = Registration<T>(factory: factory)
  }

  public func resolve<T>() -> T {
    return resolve { (builder: () -> T) in
      builder()
    }
  }
  private func resolve<T, F>(_ builder: (F) -> T) -> T {
    let key = String(describing: F.self)
    if let registration = registrations[key] as? Registration<F> {
      guard registration.instance != nil else {
        let instance = builder(registration.factory)
        registration.instance = instance
        return instance
      }
      return registration.instance as! T

    } else {
      fatalError("\(F.self) is not registered in the IoC container")
    }
  }

  public func reboot() {
    registrations.removeAll()
  }

  private init() { }
}

private class Registration<F> {

  var instance: Any?
  let factory: F

  init(factory: F, instance: Any? = nil) {
    self.factory = factory
    self.instance = instance
  }
}
