//
//  CoordinatorFactory.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation
import UIKit.UINavigationController

class CoordinatorFactory {
    func createAppFlowCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        return AppCoordinator(navController: navigationController)
    }
}
