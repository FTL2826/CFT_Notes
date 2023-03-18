//
//  MainFlowFactory.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation

class MainFlowFactory {
    
    func createListVC(coordinator: Coordinator) -> ListViewController {
        let persistentProvider = PersistentProvider.shared
        
        if !UserDefaults.standard.bool(forKey: "firstStart") {
            persistentProvider.saveNewNote(title: "Your first note", noteContext: NSAttributedString(string: "Enter text here"))
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
    
}
