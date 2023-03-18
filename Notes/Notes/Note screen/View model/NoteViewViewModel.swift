//
//  NoteViewViewModel.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation

protocol NoteViewViewModelProtocol {
    func saveNote(for indexPath: IndexPath?, title: String, noteContex: NSAttributedString)
    func fetchNote(for indexPath: IndexPath) -> Notes
}

class NoteViewViewModel: NoteViewViewModelProtocol {
    
    var persistentProvider: PersistentProviderProtocol
    
    init(persistentProvider: PersistentProviderProtocol) {
        self.persistentProvider = persistentProvider
    }
    
    func saveNote(for indexPath: IndexPath?, title: String, noteContex: NSAttributedString) {
        guard let indexPath = indexPath else {
            persistentProvider.saveNewNote(title: title, noteContext: noteContex)
            return
        }
        persistentProvider.updateNote(for: indexPath, title: title, noteContext: noteContex)
    }
    
    func fetchNote(for indexPath: IndexPath) -> Notes {
        let note = persistentProvider.fetchController.object(at: indexPath)
        return note
    }
    
}
