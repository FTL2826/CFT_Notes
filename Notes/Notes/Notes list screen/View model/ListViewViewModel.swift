//
//  ListViewViewModel.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation

protocol ListViewViewModelProtocol {
    
    func rowsInTable() -> Int
    func titleForRow(index: Int) -> String
    func subtitleForRow(index: Int) -> String
    func deleteNote(for index: Int)
}

class ListViewViewModel: ListViewViewModelProtocol {
    
    var dataManager: DataManagerProtocol
    let dateFormatter = DateFormatter()
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    func rowsInTable() -> Int {
        return dataManager.notes.count
    }
    
    func titleForRow(index: Int) -> String {
        return dataManager.notes[index].title
    }
    
    func subtitleForRow(index: Int) -> String {
        let str = dateFormatter.string(from: dataManager.notes[index].date)
        return str
    }
    
    func deleteNote(for index: Int) {
        dataManager.deleteNote(for: index)
    }
    
}
