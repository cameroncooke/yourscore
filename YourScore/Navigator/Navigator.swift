//
//  Navigator.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import UIKit

final class Navigator {
    var setViewControllers: ([UIViewController], _ animated: Bool) -> Void
    var pushViewController: (UIViewController, _ animated: Bool) -> Void
    var popViewController: (_ animated: Bool) -> Void

    init(
        setViewControllers: @escaping ([UIViewController], Bool) -> Void,
        pushViewController: @escaping (UIViewController, Bool) -> Void,
        popViewController: @escaping (Bool) -> Void
    ) {
        self.setViewControllers = setViewControllers
        self.pushViewController = pushViewController
        self.popViewController = popViewController
    }
}

extension Navigator {

    static func live(navigationController: UINavigationController) -> Self {
        Self(
            setViewControllers: { viewControllers, animated in
                navigationController.setViewControllers(viewControllers, animated: animated)
            },
            pushViewController: { viewController, animated in
                navigationController.pushViewController(viewController, animated: animated)
            },
            popViewController: { animated in
                navigationController.popViewController(animated: animated)
            }
        )
    }
}
