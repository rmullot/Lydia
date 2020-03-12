//
//  UITableView+LydiaUIKit.swift
//  LydiaUIKit
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

public extension UITableView {

    func registerReusableCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }

    func registerReusableView<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
    }

    func dequeueReusableView<T: UITableViewHeaderFooterView>(_: T.Type) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as! T
    }
}
