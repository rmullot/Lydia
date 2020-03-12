//
//  ApplicationCoordinator.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 05/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit
import LydiaBridge
import LydiaUIKit

final class ApplicationCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()

    weak var window: UIWindow?
    var rootViewController: SwipeNavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = UsersViewModel(userService: UserService.sharedInstance)
        viewModel.delegate = self
        let usersListViewController = UsersListViewController(viewModel: viewModel)
        rootViewController = SwipeNavigationController(rootViewController: usersListViewController)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }

}

// MARK: - UsersViewModelDelegate Methods

extension ApplicationCoordinator: UsersViewModelDelegate {

    func didTapUser(user: User) {
        if let rootViewController = rootViewController {
            let userDescription = UserDescriptionCoordinator(rootViewController: rootViewController)
            userDescription.delegate = self
            addChildCoordinator(userDescription)
            userDescription.start(user: user)
        }
    }
}

// MARK: - UserDescriptionCoordinatorDelegate Methods

extension ApplicationCoordinator: UserDescriptionCoordinatorDelegate {
    func didFinish(_ coordinator: UserDescriptionCoordinator) {
        removeChildCoordinator(coordinator)
    }
}
