//
//  SceneDelegate.swift
//  Test_Lydia
//

import UIKit
import LydiaBridge

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        applicationCoordinator = ApplicationCoordinator(window: window!)
        applicationCoordinator?.start()
    }

}
