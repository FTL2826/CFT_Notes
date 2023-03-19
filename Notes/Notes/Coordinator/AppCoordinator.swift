//
//  AppCoordinator.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation
import UIKit.UINavigationController

class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    let factory = MainFlowFactory()
    
    init (navController: UINavigationController){
        self.navigationController = navController
    }
    
    func start() {
        openNotesList()
    }
    
    func openNotesList() {
        let vc = factory.createListVC(coordinator: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showNewNoteScreen() {
        let vc = factory.createNewNoteVC(coordinator: self)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showExistNoteScreen(for indexPath: IndexPath) {
        let vc = factory.createExistNoteVC(coordinator: self, for: indexPath)
        
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popBack() {
        navigationController.popViewController(animated: true)
    }
    
    func showFontPicker(with delegate: UIFontPickerViewControllerDelegate) {
        let vc = factory.createFontPicker()
        vc.delegate = delegate
        navigationController.present(vc, animated: true)
    }
    
    func showImagePicker(with delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
        let vc = factory.createImagePicker()
        vc.delegate = delegate
        navigationController.present(vc, animated: true)
    }
    
}
