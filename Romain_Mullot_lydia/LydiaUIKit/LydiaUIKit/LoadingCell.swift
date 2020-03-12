//
//  LoadingCell.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 08/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit

final public class LoadingCell: UITableViewCell {

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        loadingIndicator.backgroundColor = .white
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.accessibilityIdentifier = "LoadingCell_loadingIndicator"
        loadingIndicator.isOpaque = true
        return loadingIndicator
    }()

    override public func prepareForReuse() {
        super.prepareForReuse()
        loadingIndicator.stopAnimating()
    }

    public func config() {
        loadingIndicator.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

}

private extension LoadingCell {

    func setup() {
        isOpaque = true
        translatesAutoresizingMaskIntoConstraints = true
        selectionStyle = .none
        setupInterface()
        setupConstraints()

    }

    func setupInterface() {
        addSubview(loadingIndicator)
    }

    func setupConstraints() {

        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
