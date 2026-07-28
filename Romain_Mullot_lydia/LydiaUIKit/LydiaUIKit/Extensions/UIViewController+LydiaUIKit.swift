//
//  UIViewController+LydiaUIKit.swift
//  LydiaUIKit
//
//  Created by Romain Mullot.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import UIKit

public extension UIViewController {

    /// Applies an explicit, fully opaque white `UINavigationBarAppearance` to this view controller's
    /// navigation item.
    ///
    /// Since iOS 13 (and formalized by the `UINavigationBarAppearance` API this app now targets on
    /// iOS 15+), an unconfigured navigation bar uses a *transparent* `scrollEdgeAppearance` whenever
    /// its content is scrolled to the top. That transparency lets whatever is directly behind the bar
    /// show through - e.g. an async-loading image or an `MKMapView` (which renders solid black/dark
    /// until its tiles paint in) - producing a black navigation bar that only resolves once the
    /// content behind it finishes rendering or the user scrolls.
    ///
    /// Call this from `viewDidLoad`/`setup` on any screen that lays content directly under the
    /// navigation bar and cannot tolerate a transparent bar.
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
