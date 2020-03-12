//
//  Collection+LydiaCore.swift
//  LydiaCore
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

extension Collection {

  /// Return a boolean checking if the array is not empty
  public var isNotEmpty: Bool {
    return !isEmpty
  }

  public func isValidIndex(_ index: Int) -> Bool {
    guard isNotEmpty else { return false }
    return  index < count && index >= 0
  }

}
