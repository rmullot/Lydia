//
//  SwipeNavigationController.swift
//  LydiaUIKit
//
//  Created by Romain Mullot on 06/03/2020.
//  Copyright © 2020 Romain Mullot. All rights reserved.
//

import UIKit

public protocol SwipeNavigationControllerDelegate: AnyObject {
    func didSwipeBack()
}

public final class SwipeNavigationController: UINavigationController {

    // MARK: - Private Properties

    public weak var swipeDelegate: SwipeNavigationControllerDelegate?

    private var duringPushAnimation = false

    private var swipeBackDone = false

    // MARK: - Lifecycle

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        delegate = self
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        // This needs to be in here, not in init
        interactivePopGestureRecognizer?.delegate = self
    }

    deinit {
        delegate = nil
        swipeDelegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }

    // MARK: - Overrides

    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true

        super.pushViewController(viewController, animated: animated)
    }

    @discardableResult
    public override func popViewController(animated: Bool) -> UIViewController? {
        swipeBackDone = true
        return super.popViewController(animated: true)
    }

    @discardableResult
    public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        swipeBackDone = true
        return super.popToViewController(viewController, animated: animated)
    }

}

// MARK: - UINavigationControllerDelegate

extension SwipeNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }
        swipeNavigationController.duringPushAnimation = false
        if swipeBackDone {
            swipeBackDone = false
            swipeDelegate?.didSwipeBack()
        }
    }

}

// MARK: - UIGestureRecognizerDelegate

extension SwipeNavigationController: UIGestureRecognizerDelegate {

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }

        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}
