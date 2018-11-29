//
//  HomeController.swift
//  Template
//
//  Created by Preston Perriott on 10/23/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import RealmSwift
import Foundation
import UIKit
import SVProgressHUD

protocol HomeControllerDelegate: class {
    func didSelectRecipe(recipe: Recipe)
}

class HomeController: NSObject {
    
    weak var delegate: HomeControllerDelegate?
    private var recipes = [Recipe]()
    private var didGetDaily: Bool = false
    private var randomCategory: HomeRecipeCategoryType = .healthy
    private var previousCategory: HomeRecipeCategoryType.RawValue {
        var category = ""
        guard let user = RealmService.shared.getCurrentUser() else {
            return category
        }
        /// Essentially if new user pick random item from our cateogry types
        if (user.previousCategory == "") {
            category = HomeRecipeCategoryType.random().rawValue
        } else {
            category = user.previousCategory
        }
        print("Our retrunes category is \(category)")
        return category
    }
    private var currentUser: User?
    
    public func registerRecipeCells(recipeCollectionView: UICollectionView)
        {
        recipeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    
    public func reloadData(complete: @escaping () -> Void) {
        
        SVProgressHUD.show()
        let group = DispatchGroup()
        group.enter()
        
        /// For this logic to work, we would need to save the updated prevCat to realm but mongo also
        if let savedRecipes = (RealmService.shared.getDailyRecipes()) {
            if (savedRecipes.count > 0) {
                recipes = Array(savedRecipes)
                print("Realm data is \(savedRecipes)")
                SVProgressHUD.dismiss()
                group.leave()
                group.notify(queue: .main) {
                    print("Reloaded data from Realm")
                    print(self.previousCategory)
                    complete()
                }
            } else {
                /// Else hit the API for a random w/ a randome recipes cat and save the category & recipe
                RecipeService.getDailyRecipes(for: self.previousCategory, completion: {(results) in
                    if let returnedRecipes = results.res {
                        
                        let list = List<Recipe>()
                        for recipe in returnedRecipes {
                            list.append(recipe)
                        }
                        do {
                            try RealmService.shared.saveDailyRecipes(list)
                            try RealmService.shared.updateUserField(field: User.CodingKeys.previousCategory, with: self.previousCategory)
                            /// Could get time of this request, and then check againt current date 
                            self.recipes = returnedRecipes
                        } catch {
                            print("Error saving recipes to DB")
                        }
                    } else {
                        let err = NSError(domain: "Unknown connection err", code: 300, userInfo: nil)
                        print(err)
                    }
                    
                    SVProgressHUD.dismiss()
                    group.leave()
                    group.notify(queue: .main) {
                        print("Reloaded data")
                        complete()
                    }
                })
            }
            
        } else {
            
            /// Larger problem on my hands
            
/**/     }
    }
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.recipeImageView.image = UIImage(data: try! Data(contentsOf: URL(string: recipes[indexPath.item].image)!))
        cell.recipeTitle.text = recipes[indexPath.item].title
        cell.caloriesLabel.text = String(format: "%.0f", recipes[indexPath.item].calories) + " calories"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didSelectRecipe(recipe: recipes[indexPath.item])
    }
}
