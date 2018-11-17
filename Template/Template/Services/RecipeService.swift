//
//  RecipeService.swift
//  Template
//
//  Created by Preston Perriott on 10/23/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation

class RecipeService {
    
    class func getDailyRecipes(for category: String, completion: @escaping NetworkCompletion<[Recipe]>) {
        
        let params = ["category": category]
        NetworkService.init([Recipe].self).request(method: .post, path: EndPoints.home, params: params, complete: completion)
    }
    
    class func userPreviousCategory() -> String {
        guard let user = RealmService.shared.getCurrentUser() else {
            return ""
        }
        let category = user.previousCategory
        return category
    }
}
