//
//  LydiaScrollView.swift
//  LydiaUIKit
//
//  Created by Romain Mullot on 05/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

public class LydiaScrollView: UIScrollView {

    private var currentKeyboardHeight: CGFloat = .zero

    public lazy var contentView: UIView = {
        let contentView = UIView.autolayout()
        contentView.backgroundColor = backgroundColor
        contentView.accessibilityIdentifier = "LydiaScrollView_ContentView"
        contentView.isOpaque = true
        return contentView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override public var backgroundColor: UIColor? {
        didSet {
            contentView.backgroundColor = backgroundColor
        }
    }

}
private extension LydiaScrollView {

    func setup() {
        isOpaque = true
        contentInsetAdjustmentBehavior = .never
        contentInset = .zero
        scrollIndicatorInsets = .zero
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        setupInterface()
        setupConstraints()
    }

    func setupInterface() {
        addSubview(contentView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor)
        ])
    }
}
