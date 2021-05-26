//
//  CoreDataManager.swift
//  TwitchCategories
//
//  Created by ADMIN ODoYal on 24.05.2021.
//

import Foundation

protocol CoreDataEntityManager {
    // D - Details
    associatedtype D
    // E - CoreData Entity
    associatedtype E
    var coreDataEntityName: String { get }
    
    func save()
    func add(_ entuty: D)
    func find(with id: Int) -> E?
    func delete(with id: Int)
    func clear()
}
