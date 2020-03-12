//
//  UIView+LydiaUIKit.swift
//  LydiaUIKit
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {

    static func autolayout() -> Self {
        let view = Self()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func anchorToBounds(view: UIView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    func setVerticalContentPriority(_ priority: UILayoutPriority) {
        setContentHuggingPriority(priority, for: .vertical)
        setContentCompressionResistancePriority(priority, for: .vertical)
    }

    func setHorizontalalContentPriority(_ priority: UILayoutPriority) {
        setContentHuggingPriority(priority, for: .horizontal)
        setContentCompressionResistancePriority(priority, for: .horizontal)
    }
}
