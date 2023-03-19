//
//  MainFlowFactory.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation
import UIKit.UIFontPickerViewController

class MainFlowFactory {
    
    func createListVC(coordinator: Coordinator) -> ListViewController {
        let persistentProvider = PersistentProvider.shared
        
        if !UserDefaults.standard.bool(forKey: "firstStart") {
            let noteContext = NSMutableAttributedString(string: "Enter text here", attributes: [.foregroundColor : UIColor.label, .font : UIFont.systemFont(ofSize: 20)])
            persistentProvider.saveNewNote(title: "Your first note", noteContext: noteContext)
            UserDefaults.standard.set(true, forKey: "firstStart")
        }
        
        let viewModel = ListViewViewModel(persistentProvider: persistentProvider)
        
        let vc = ListViewController(
            viewModel: viewModel,
            coordinator: coordinator)
        
        persistentProvider.fetchController.delegate = vc
        
        return vc
    }
    
    func createNewNoteVC(coordinator: Coordinator) -> NoteViewController {
        let persistentProvider = PersistentProvider.shared
        
        let viewModel = NoteViewViewModel(persistentProvider: persistentProvider)
        
        let vc = NoteViewController(
            viewModel: viewModel,
            coordinator: coordinator)
        
        return vc
    }
    
    func createExistNoteVC(coordinator: Coordinator, for indexPath: IndexPath) -> NoteViewController {
        let persistentProvider = PersistentProvider.shared
        
        let viewModel = NoteViewViewModel(persistentProvider: persistentProvider)
        
        let vc = NoteViewController(
            viewModel: viewModel,
            coordinator: coordinator,
            indexPath: indexPath)
        
        return vc
    }
    
    func createFontPicker() -> UIFontPickerViewController {
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = false
        let vc = UIFontPickerViewController(configuration: config)
        return vc
    }
    
    func createImagePicker() -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }
    
}
