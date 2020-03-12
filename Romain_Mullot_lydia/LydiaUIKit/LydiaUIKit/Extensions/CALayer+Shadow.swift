//
//  CALayer+Shadow.swift
//  LydiaUIKit
//
//  Created by Romain Mullot on 04/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

public extension CALayer {

    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, coordX: CGFloat = 0, coordY: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: coordX, height: coordY)
        shadowRadius = blur / 2
        if spread == 0 {
            shadowPath = nil
        } else {
            let deltaX = -spread
            let rect = bounds.insetBy(dx: deltaX, dy: deltaX)
            shadowPath = UIBezierPath(rect: rect).cgPath

        }
    }

}
