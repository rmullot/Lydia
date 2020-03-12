//
//  UserDescriptionViewController.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 05/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit
import LydiaUIKit
import Kingfisher
import MapKit

final class UserDescriptionViewController: UIViewController {

    private let viewModel: UserDescriptionViewModelProtocol

    private let paddingStackView: CGFloat = 20

    private lazy var scrollView: LydiaScrollView = {
        let scrollView = LydiaScrollView.autolayout()
        scrollView.backgroundColor = .white
        scrollView.isUserInteractionEnabled = true
        scrollView.accessibilityIdentifier = "UserDescriptionViewController_scrollView"
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView.autolayout()
        stackView.backgroundColor = .white
        stackView.accessibilityIdentifier = "UserDescriptionViewController_stackView"
        stackView.isOpaque = true
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .firstBaseline
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: paddingStackView, bottom: 0, right: paddingStackView)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.isUserInteractionEnabled = true
        return stackView
    }()

    private lazy var genderLabel: UILabel = {
        let genderLabel = UILabel.autolayout()
        genderLabel.backgroundColor = .white
        genderLabel.accessibilityIdentifier = "UserDescriptionViewController_genderLabel"
        genderLabel.isOpaque = true
        genderLabel.textAlignment = .left
        genderLabel.textColor = .black
        genderLabel.numberOfLines = 0
        return genderLabel
    }()

    private lazy var identityLabel: UILabel = {
        let identityLabel = UILabel.autolayout()
        identityLabel.backgroundColor = .white
        identityLabel.accessibilityIdentifier = "UserDescriptionViewController_identityLabel"
        identityLabel.isOpaque = true
        identityLabel.textAlignment = .left
        identityLabel.textColor = .black
        identityLabel.numberOfLines = 0
        return identityLabel
    }()

    private lazy var cellLabel: UILabel = {
        let cellLabel = UILabel.autolayout()
        cellLabel.backgroundColor = .white
        cellLabel.accessibilityIdentifier = "UserDescriptionViewController_cellLabel"
        cellLabel.isOpaque = true
        cellLabel.textAlignment = .left
        cellLabel.textColor = .black
        cellLabel.numberOfLines = 0
        return cellLabel
    }()

    private lazy var birthdayDateLabel: UILabel = {
        let birthdayDateLabel = UILabel.autolayout()
        birthdayDateLabel.backgroundColor = .white
        birthdayDateLabel.accessibilityIdentifier = "UserDescriptionViewController_birthdayDateLabel"
        birthdayDateLabel.isOpaque = true
        birthdayDateLabel.textAlignment = .left
        birthdayDateLabel.textColor = .black
        birthdayDateLabel.numberOfLines = 0
        return birthdayDateLabel
    }()

    private lazy var emailLabel: UILabel = {
        let emailLabel = UILabel.autolayout()
        emailLabel.backgroundColor = .white
        emailLabel.accessibilityIdentifier = "UserDescriptionViewController_emailLabel"
        emailLabel.isOpaque = true
        emailLabel.textAlignment = .left
        emailLabel.textColor = .black
        emailLabel.numberOfLines = 0
        return emailLabel
    }()

    private lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel.autolayout()
        phoneLabel.backgroundColor = .white
        phoneLabel.accessibilityIdentifier = "UserDescriptionViewController_phoneLabel"
        phoneLabel.isOpaque = true
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = .black
        phoneLabel.numberOfLines = 0
        return phoneLabel
    }()

    private lazy var addressLabel: UILabel = {
        let addressLabel = UILabel.autolayout()
        addressLabel.backgroundColor = .white
        addressLabel.accessibilityIdentifier = "UserDescriptionViewController_addressLabel"
        addressLabel.isOpaque = true
        addressLabel.textAlignment = .left
        addressLabel.textColor = .black
        addressLabel.numberOfLines = 0
        return addressLabel
    }()

    private lazy var largePhoto: UIImageView = {
        let largePhoto = UIImageView.autolayout()
        largePhoto.backgroundColor = .white
        largePhoto.accessibilityIdentifier = "UserDescriptionViewController_largePhoto"
        largePhoto.isOpaque = true
        largePhoto.contentMode = .scaleAspectFit
        largePhoto.isUserInteractionEnabled = true
        return largePhoto
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView.autolayout()
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = false
        mapView.isUserInteractionEnabled = true
        mapView.accessibilityIdentifier = "UserDescriptionViewController_mapView"
        return mapView

    }()

    // MARK: - Memory Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }

    init(viewModel: UserDescriptionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Action Methods

extension UserDescriptionViewController {

    @objc
    func didTapBackButton(_ sender: UIButton) {
        viewModel.didTapBack()
    }
}

// MARK: - Setup Methods

private extension UserDescriptionViewController {

    func setup() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<", style: .plain, target: self, action: .didTapBackButton)
        edgesForExtendedLayout = []
        view.isOpaque = true
        view.backgroundColor = .white
        setupInterface()
        setupConstraints()
        config()
    }

    func setupInterface() {
        view.addSubview(scrollView)
        scrollView.addSubview(largePhoto)
        scrollView.addSubview(mapView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(genderLabel)
        stackView.addArrangedSubview(identityLabel)
        stackView.addArrangedSubview(birthdayDateLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(emailLabel)
        stackView.addArrangedSubview(phoneLabel)
        stackView.addArrangedSubview(cellLabel)

    }

    func setupConstraints() {
        scrollView.anchorToBounds(view: view)
        NSLayoutConstraint.activate([
            largePhoto.topAnchor.constraint(equalTo: scrollView.topAnchor),
            largePhoto.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            largePhoto.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            largePhoto.heightAnchor.constraint(equalToConstant: 200),

            mapView.topAnchor.constraint(equalTo: largePhoto.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            mapView.heightAnchor.constraint(equalToConstant: 500),

            stackView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)

        ])
    }

    func config() {
        birthdayDateLabel.text = viewModel.birthdayDate
        identityLabel.text = viewModel.identity
        emailLabel.text = viewModel.email
        genderLabel.text = viewModel.gender
        cellLabel.text = viewModel.cell
        phoneLabel.text = viewModel.phone
        addressLabel.text = viewModel.address
        if let currentUrl = viewModel.largePhotoUrl {
            largePhoto.kf.setImage(with: currentUrl)
        }

        let annotationPoint = MKPointAnnotation()

        annotationPoint.coordinate = viewModel.coordinates
        annotationPoint.title = viewModel.identity

        let annotationView: MKPinAnnotationView = MKPinAnnotationView(annotation: annotationPoint, reuseIdentifier: "Annotation")
        mapView.addAnnotation(annotationView.annotation!)
        mapView.setCenter(viewModel.coordinates, animated: true)
        loadViewIfNeeded()
    }
}

// MARK: - Selector

private extension Selector {
    static let didTapBackButton = #selector(UserDescriptionViewController.didTapBackButton(_:))
}
