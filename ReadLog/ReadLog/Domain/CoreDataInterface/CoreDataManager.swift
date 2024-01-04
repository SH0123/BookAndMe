//
//  CoreDataManager.swift
//  ReadLog
//
//  Created by sanghyo on 1/3/24.
//

import Foundation
import CoreData

enum CoreDataError: Error {
    case invalidManagedObjectType
    case saveFail
}

struct CoreDataManager {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = PersistenceController.shared.container.viewContext
    }
    
    func create() {
        
    }
    
    func fetchAll<Entity: NSManagedObject>(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<[Entity], Error> {
        
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            if let fetchResults = try context.fetch(fetchRequest) as? [Entity] {
                return .success(fetchResults)
            } else {
                return .failure(CoreDataError.invalidManagedObjectType)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func fetch<Entity: NSManagedObject>(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?) -> Result<Entity, Error>  {
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            if let fetchResult = try context.fetch(fetchRequest).first as? Entity {
                return .success(fetchResult)
            } else {
                return .failure(CoreDataError.invalidManagedObjectType)
            }
        } catch {
            return .failure(error)
        }
    }
    
    func delete<Entity: NSManagedObject>(_ entity: Entity) -> Result<Void, Error> {
        context.delete(entity)
        
        return save()
    }
    
    func save() -> Result<Void, Error> {
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(CoreDataError.saveFail)
        }
    }
}
