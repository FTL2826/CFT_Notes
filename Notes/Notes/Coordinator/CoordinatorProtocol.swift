//
//  CoordinatorProtocol.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation
import UIKit.UINavigationController

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get }
    func start()
    func showNewNoteScreen()
    func showExistNoteScreen(for index: Int)
    func popBack()
}
