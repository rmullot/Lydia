//
//  UserDescriptionCoordinator.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 05/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation
import UIKit
import LydiaUIKit
import LydiaBridge

protocol UserDescriptionCoordinatorDelegate: AnyObject {
    func didFinish(_ coordinator: UserDescriptionCoordinator)
}

final class UserDescriptionCoordinator: Coordinator {

    var childCoordinators = [Coordinator]()

    weak var rootViewController: SwipeNavigationController?
    weak var delegate: UserDescriptionCoordinatorDelegate?

    init(rootViewController: SwipeNavigationController) {
        self.rootViewController = rootViewController
    }

    func start(user: User) {
        let viewModel = UserDescriptionViewModel(user: user)
        viewModel.delegate = self
        let userDescriptionViewController = UserDescriptionViewController(viewModel: viewModel)
        rootViewController?.pushViewController(userDescriptionViewController, animated: true)
        rootViewController?.swipeDelegate = self
    }

    deinit {
        rootViewController?.swipeDelegate = nil
    }
}

// MARK: - UserDescriptionViewModelDelegate Methods

extension UserDescriptionCoordinator: UserDescriptionViewModelDelegate {
    func didTapBack() {
        if let navigationController = rootViewController {
            navigationController.popViewController(animated: true)
        }
        delegate?.didFinish(self)
    }
}

// MARK: - SwipeNavigationControllerDelegate Methods

extension UserDescriptionCoordinator: SwipeNavigationControllerDelegate {
    func didSwipeBack() {
        delegate?.didFinish(self)
    }
}
