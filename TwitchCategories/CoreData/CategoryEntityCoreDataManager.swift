//
//  CategoryEntityCoreDataManager.swift
//  TwitchCategories
//
//  Created by ADMIN ODoYal on 23.05.2021.
//

import Foundation
import CoreData

class CategoryEntityCoreDataManager {
    let coreDataEntityName: String = "CategoryEntity"
    
    static let shared = CategoryEntityCoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TwitchCategories")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    func save() {
        let context = persistentContainer.viewContext
        DispatchQueue.main.async {
            if context.hasChanges {
                context.performAndWait {
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print(error)
                    }
                }
            }
        }
    }
    
    func add(_ category: Categories.Top) {
        let context = persistentContainer.viewContext
        context.perform {
            let newCategory = CategoryEntity(context: context)
            newCategory.id = Int64(category.game.id)
            newCategory.name =  category.game.name
            newCategory.channels = Int64(category.channels)
            newCategory.viewers = Int64(category.viewers)
            newCategory.backPath = category.game.box?.backPath
        }
        save()
    }
    
    func find(with id: Int) -> CategoryEntity? {
        let context = persistentContainer.viewContext
        let requestResult: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        requestResult.predicate = NSPredicate(format: "id == %d", id)
        do {
            let movies = try context.fetch(requestResult)
            if movies.count > 0 {
                assert(movies.count == 1, "It means DB has dublicates")
                return movies[0]
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    func delete(with id: Int) {
        let context = persistentContainer.viewContext
        let category = find(with: id)
        if let category = category {
            context.delete(category)
            save()
        }
    }
    
    func all() -> [CategoryDetails] {
        let context = persistentContainer.viewContext
        let requestResult: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        
        let categories = try? context.fetch(requestResult)
        
        return categories?.map({ CategoryDetails.init(category: $0) }) ?? []
    }
    
    func all(with offset: Int) -> [CategoryDetails] {
        let context = persistentContainer.viewContext
        //        let requestResult: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        let fetchRequest = NSFetchRequest<CategoryEntity>()
        fetchRequest.fetchLimit = 10
        fetchRequest.fetchOffset = offset
        let entityDesc = NSEntityDescription.entity(forEntityName: coreDataEntityName, in: context)
        fetchRequest.entity = entityDesc
        let categories = try? context.fetch(fetchRequest)
        return categories?.map({ CategoryDetails.init(category: $0) }) ?? []
    }
    
    func clear() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: coreDataEntityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error)
        }
        save()
    }
}
