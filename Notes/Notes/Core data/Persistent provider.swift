//
//  Persistent provider.swift
//  Notes
//
//  Created by Александр Харин on /173/23.
//

import CoreData
import Foundation

protocol PersistentProviderProtocol {
    var fetchController: NSFetchedResultsController<Notes> { get }
    
    func saveNewNote(title: String, noteContext: NSAttributedString)
    func updateNote(for indexPath: IndexPath, title: String, noteContext: NSAttributedString)
    func deleteNote(at indexPath: IndexPath)
}


final class PersistentProvider: NSObject, PersistentProviderProtocol {
    static let shared = PersistentProvider()
    
    private var persistentContainer: NSPersistentContainer!
    var mainViewContext: NSManagedObjectContext!
    var backgroundViewContext: NSManagedObjectContext!
    
    lazy var fetchController: NSFetchedResultsController<Notes> = {
        let fetchRequest: NSFetchRequest<Notes> = Notes.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Notes.date), ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: backgroundViewContext,
            sectionNameKeyPath: nil,
            cacheName: "CD cache")
        do {
            try controller.performFetch()
        } catch {
            print("Fetch controller error:", error.localizedDescription)
        }
        return controller
    }()
    
    override init() {
        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer = container
        mainViewContext = persistentContainer?.viewContext
        backgroundViewContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundViewContext.parent = mainViewContext
    }
    
    func saveContext() {
        if backgroundViewContext.hasChanges {
            do {
                try backgroundViewContext.save()
            } catch {
                print(error)
            }
        }
        if mainViewContext.hasChanges {
            do {
                try mainViewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveNewNote(title: String, noteContext: NSAttributedString) {
        let note = Notes(context: backgroundViewContext)
        note.title = title
        note.noteContex = noteContext
        note.date = Date()
        saveContext()
    }
    
    func updateNote(for indexPath: IndexPath, title: String, noteContext: NSAttributedString) {
        let note = fetchController.object(at: indexPath)
        note.title = title
        note.noteContex = noteContext
        note.date = Date()
        saveContext()
    }
    
    func deleteNote(at indexPath: IndexPath) {
        backgroundViewContext.delete(fetchController.object(at: indexPath))
        saveContext()
    }
}
