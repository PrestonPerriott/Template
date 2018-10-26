//
//  Recipe.swift
//  Template
//
//  Created by Preston Perriott on 10/23/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

enum HomeRecipeCategoryType: String, CaseIterable {
    case italian
    case french
    case asain
    case middleeastern
    case spanish
    case german
    case american
    case indian
    case mexican
    case healthy
    case lowcarb
    case lowcalorie
    case kosher
    case halal
    case european
    case spicy
}

extension HomeRecipeCategoryType {
    static func random() -> HomeRecipeCategoryType {
        let categories: [HomeRecipeCategoryType] = HomeRecipeCategoryType.allCases
        let random = Int(arc4random()) % categories.count
        return categories[random]
    }
}

class Recipe: Object, Codable {
    
    @objc dynamic var title = ""
    @objc dynamic var url = ""
    @objc dynamic var image = ""
    @objc dynamic var calories = ""
    @objc dynamic var totalTime = ""
    @objc dynamic var categories = ""
    @objc dynamic var ingredients = ""
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    internal enum CodingKeys: String, CodingKey {
        case title = "title"
        case url = "url"
        case image = "image"
        case calories = "calories"
        case totalTime = "totalTime"
        case categories = "category"
        case ingredients = "ingredients"
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        url = try container.decode(String.self, forKey: .url)
        image = try container.decode(String.self, forKey: .image)
        calories = try container.decode(String.self, forKey: .calories)
        totalTime = try container.decode(String.self, forKey: .totalTime)
        
        let categoriesAry = try container.decode([String].self, forKey: .categories)
        for cat in categoriesAry{
            categories.append(contentsOf: cat)
        }
        
        let ingredientsAry = try container.decode([String].self, forKey: .ingredients)
        for ingrd in ingredientsAry {
            ingredients.append(ingrd)
        }
    }
    
    func encode(encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encode(image, forKey: .image)
        
        try container.encode(calories, forKey: .calories)
        try container.encode(totalTime, forKey: .totalTime)
    }
}
