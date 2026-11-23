//
//  UIViewController+LydiaUIKit.swift
//  LydiaUIKit
//
//  Created by Romain Mullot.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import UIKit

public extension UIViewController {

    func applyOpaqueWhiteNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = nil

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
}
