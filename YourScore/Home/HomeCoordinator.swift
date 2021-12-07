//
//  HomeCoordinator.swift
//  Copyright © 2022 Cameron Cooke. All rights reserved.
//

import Foundation
import UIKit

final class HomeCoordinator {

    let navigator: Navigator

    init(navigator: Navigator) {
        self.navigator = navigator
    }

    func start() {
        let viewModel = HomeViewModel(service: .live)
        let homeViewController = HomeViewController(viewModel: viewModel)

        navigator.setViewControllers([homeViewController], false)
    }
}
