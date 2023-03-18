//
//  ListViewViewModel.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation

protocol ListViewViewModelProtocol {
    
    func numberOfSections() -> Int
    func rowsInTable(for section: Int) -> Int
    func fetchNote(for indexPath: IndexPath) -> Notes
    func dateToSubtitle(date: Date) -> String
    func fetchFromDB()
    func deleteNote(for indexPath: IndexPath)
}

class ListViewViewModel: ListViewViewModelProtocol {
    
    var persistentProvider: PersistentProviderProtocol
    let dateFormatter = DateFormatter()
    
    init(persistentProvider: PersistentProviderProtocol) {
        self.persistentProvider = persistentProvider
        dateFormatter.dateFormat = "dd-MM-yyyy"
    }
    
    func numberOfSections() -> Int {
        return persistentProvider.fetchController.sections?.count ?? 0
    }
    
    func rowsInTable(for section: Int) -> Int {
        let sectionInfo = persistentProvider.fetchController.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    func fetchNote(for indexPath: IndexPath) -> Notes {
        let note = persistentProvider.fetchController.object(at: indexPath)
        return note
    }
    
    func dateToSubtitle(date: Date) -> String {
        let str = dateFormatter.string(from: date)
        return str
    }
    
    func fetchFromDB() {
        do {
            try persistentProvider.fetchController.performFetch()
        } catch {
            print("Fetch controller error:", error.localizedDescription)
        }
    }
    
    func deleteNote(for indexPath: IndexPath) {
        persistentProvider.deleteNote(at: indexPath)
    }
    
    
}
