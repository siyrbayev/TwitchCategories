//
//  CategoriesDetails.swift
//  TwitchCategories
//
//  Created by ADMIN ODoYal on 23.05.2021.
//

import Foundation

struct Categories: Decodable {
    let top: [Top]
    
    struct Top: Decodable{
        let channels: Int
        let viewers: Int
        let game: Game
        
        init(category: CategoryEntity) {
            channels = Int(category.channels)
            viewers = Int(category.viewers)
            game = Game(id: Int(category.id),name: category.name, box: Game.Box(backPath: category.backPath))
        }
        
        struct Game: Decodable {
            let id: Int
            let name: String?
            let box: Box?
            
            enum CodingKeys: String, CodingKey {
                case id = "_id"
                case name
                case box
            }
        
            struct Box: Decodable {
                let backPath: String?
                
                enum CodingKeys: String, CodingKey {
                    case backPath = "large"
                }
            }
        }
    }
}

struct CategoryDetails {
    let id: Int
    let name: String
    let channels: Int
    let viewers: Int
    let backPath: String
    
    init(category: CategoryEntity) {
        id = Int(category.id)
        name = category.name ?? "noName"
        channels = Int(category.channels)
        viewers = Int(category.viewers)
        backPath = category.backPath ?? "noPath"
    }
}
