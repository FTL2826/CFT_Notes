//
//  MainFlowFactory.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation

class MainFlowFactory {
    
    func createListVC(coordinator: Coordinator) -> ListViewController {
        let dataManager = DataManager.shared
        
        let viewModel = ListViewViewModel(dataManager: dataManager)
        
        let vc = ListViewController(
            viewModel: viewModel,
            coordinator: coordinator)
        
        return vc
    }
    
    func createNewNoteVC(coordinator: Coordinator) -> NoteViewController {
        let dataManager = DataManager.shared
        
        let viewModel = NoteViewViewModel(dataManager: dataManager)
        
        let vc = NoteViewController(
            viewModel: viewModel,
            coordinator: coordinator)
        
        return vc
    }
    
    func createExistNoteVC(coordinator: Coordinator, for index: Int) -> NoteViewController {
        let dataManager = DataManager.shared
        
        let viewModel = NoteViewViewModel(dataManager: dataManager)
        
        let vc = NoteViewController(
            viewModel: viewModel,
            coordinator: coordinator,
            index: index)
        
        return vc
    }
    
}
