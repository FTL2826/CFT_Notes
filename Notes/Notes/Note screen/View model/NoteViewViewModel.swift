//
//  NoteViewViewModel.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation

protocol NoteViewViewModelProtocol {
    func saveNote(index: Int?, title: String, noteContex: String)
    func fetchNote(for index: Int) -> Note
}

class NoteViewViewModel: NoteViewViewModelProtocol {
    
    var dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func saveNote(index: Int?, title: String, noteContex: String) {
        guard let index = index else {
            let note = Note(title: title, note: noteContex, date: Date())
            dataManager.createNewNote(note: note)
            return
        }
        dataManager.replaceNote(for: index, note: Note(title: title, note: noteContex, date: Date()))
    }
    
    func fetchNote(for index: Int) -> Note {
        return dataManager.fetchNote(for: index)
    }
    
}
