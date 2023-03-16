//
//  DataManager.swift
//  Notes
//
//  Created by Александр Харин on /163/23.
//

import Foundation

protocol DataManagerProtocol {
    var notes: [Note] { get }
    
    func getNotes() -> [Note]
    func createNewNote(note: Note)
    func fetchNote(for index: Int) -> Note
    func replaceNote(for index: Int, note: Note)
    func deleteNote(for index: Int)
}

class DataManager: DataManagerProtocol {
    
    static let shared = DataManager()
    init(){}
    
    var notes: [Note] = [
        Note(title: "Welcome note", note: "Your first note here", date: Date())
    ]
    
    func getNotes() -> [Note] {
        return notes
    }
    
    func createNewNote(note: Note) {
        notes.append(note)
    }
    
    func fetchNote(for row: Int) -> Note {
        return notes[row]
    }
    
    func replaceNote(for index: Int, note: Note) {
        notes[index] = note
    }
    
    func deleteNote(for index: Int) {
        notes.remove(at: index)
    }
}
