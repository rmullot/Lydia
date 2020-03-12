//
//  UserDescriptionViewModel.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 05/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import LydiaBridge
import MapKit

protocol UserDescriptionViewModelProtocol: AnyObject {
    var delegate: UserDescriptionViewModelDelegate? { get set }
    var email: String { get }
    var gender: String { get }
    var nationality: String { get }
    var identity: String { get }
    var phone: String { get }
    var cell: String { get }
    var birthdayDate: String { get }
    var registeredDate: String { get }
    var address: String { get }
    var largePhotoUrl: URL? { get }
    var coordinates: CLLocationCoordinate2D { get }
    func didTapBack()
}

protocol UserDescriptionViewModelDelegate: AnyObject {
    func didTapBack()
}

final class UserDescriptionViewModel: UserDescriptionViewModelProtocol {
    weak var delegate: UserDescriptionViewModelDelegate?
    let user: User

    var email: String {
        return user.email
    }

    var gender: String {
        return user.gender
    }

    var nationality: String {
        return user.nationality
    }

    var identity: String {
        return user.identity
    }

    var phone: String {
        return user.cell
    }

    var cell: String {
        return user.cell
    }

    var birthdayDate: String {
        return user.birthdayDate.descriptionDateString
    }

    var registeredDate: String {
        return user.registeredDate.descriptionDateString
    }

    var largePhotoUrl: URL? {
        return URL(string: user.imageUrls[UserImageSize.large.rawValue] ?? "")
    }

    var address: String {
        return user.location.address
    }

    var coordinates: CLLocationCoordinate2D {
        var location = CLLocationCoordinate2D()
        location.latitude = user.location.latitude
        location.longitude = user.location.longitude
        return location
    }

    init(user: User) {
        self.user = user
    }

    func didTapBack() {
        if let url = largePhotoUrl {
            URLSession.shared.getAllTasks { tasks in
                 tasks
                   .filter { $0.state == .running }
                   .filter { $0.originalRequest?.url == url }.first?
                   .cancel()
               }
        }
        delegate?.didTapBack()
    }
}
