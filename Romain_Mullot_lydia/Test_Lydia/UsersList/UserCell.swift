//
//  UserCell.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 05/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

final class UserCell: UITableViewCell {

    private lazy var photoView: UIImageView = {
        let photoView = UIImageView.autolayout()
        photoView.backgroundColor = .white
        photoView.accessibilityIdentifier = "UserCell_photoView"
        photoView.isOpaque = true
        photoView.contentMode = .scaleAspectFit
        photoView.layer.applySketchShadow()
        return photoView
    }()

    private lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel.autolayout()
        phoneLabel.backgroundColor = .white
        phoneLabel.accessibilityIdentifier = "UserCell_phoneLabel"
        phoneLabel.isOpaque = true
        return phoneLabel
    }()

    private lazy var identityLabel: UILabel = {
        let identityLabel = UILabel.autolayout()
        identityLabel.backgroundColor = .white
        identityLabel.accessibilityIdentifier = "UserCell_identityLabel"
        identityLabel.isOpaque = true
        identityLabel.numberOfLines = 0
        return identityLabel
    }()

    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel.autolayout()
        emailLabel.backgroundColor = .white
        emailLabel.accessibilityIdentifier = "UserCell_emailLabel"
        emailLabel.isOpaque = true
        return emailLabel
    }()

    func config(viewModel: UsersViewModelProtocol, index: Int) {
        identityLabel.text = viewModel.getIdentity(index: index)
        emailLabel.text = viewModel.getEmail(index: index)
        phoneLabel.text = viewModel.getPhone(index: index)
        if let currentImageUrl = viewModel.getThumbImage(index: index) {
            photoView.kf.setImage(with: currentImageUrl)
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
        phoneLabel.text = ""
        identityLabel.text = ""
        emailLabel.text = ""
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

}

private extension UserCell {

    func setup() {
        isOpaque = true
        translatesAutoresizingMaskIntoConstraints = true
        selectionStyle = .none
        setupInterface()
        setupConstraints()

    }

    func setupInterface() {
        addSubview(photoView)
        addSubview(identityLabel)
        addSubview(emailLabel)
        addSubview(phoneLabel)
    }

    func setupConstraints() {
        let defaultMargin: CGFloat = 10

        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: topAnchor, constant: defaultMargin),
            photoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -defaultMargin),
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: defaultMargin),
            photoView.widthAnchor.constraint(equalToConstant: 95),
            photoView.heightAnchor.constraint(equalTo: photoView.widthAnchor),

            identityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            identityLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: defaultMargin),
            identityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultMargin),
            identityLabel.heightAnchor.constraint(equalToConstant: 53),

            emailLabel.topAnchor.constraint(equalTo: identityLabel.bottomAnchor),
            emailLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: defaultMargin),
            emailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultMargin),
            emailLabel.heightAnchor.constraint(equalToConstant: 25),

            phoneLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor),
            phoneLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -defaultMargin),
            phoneLabel.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: defaultMargin),
            phoneLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -defaultMargin),
            phoneLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
