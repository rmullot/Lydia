//
//  Coordinator.swift
//  Test_Lydia
//
//  Created by Romain Mullot on 05/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {

    func addChildCoordinator(_ coordinator: Coordinator) { childCoordinators.append(coordinator)
    }
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ !($0 === coordinator) })
    }

}
