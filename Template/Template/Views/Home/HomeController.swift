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
}

class HomeController: NSObject {
    
    weak var delegate: HomeControllerDelegate?
    private var recipes = [Recipe]()
    private var didGetDaily: Bool = false
    private var randomCategory: HomeRecipeCategoryType = .healthy
    private var currentUser: User?
    
    ///For now we randomize the search query
    ///In the future we'll want to save the last 10 past queries so we don't
    //keep showing the user data they've just seen.
    
    ///Or Slowly pool a list of all the different categories to choose from
    
    public func registerRecipeCells(recipeCollectionView: UICollectionView)
        {
        recipeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    
    public func reloadData(complete: @escaping () -> Void) {
        
        SVProgressHUD.show()
        let group = DispatchGroup()
        group.enter()
        ///Search Realm for saved Daily recipes before making call
        ///Search realm for last saved category and choose other
        guard let user = RealmService.shared.getCurrentUser() else {
            SVProgressHUD.dismiss()
            group.leave()
            return
        }
        /// If theres already a documentated previousCategory return and don't hit API
        /// Instead find dailyRecipes from Realm
        print("Our users prev category : \(user.previousCategory)")
        if (user.previousCategory != "") {
            /// For this logic to work, we would need to save the updated prevCat to realm but mongo also
            if let savedRecipes = (RealmService.shared.getDailyRecipes())
                {
                    recipes = Array(savedRecipes)
                }
                group.leave()
                group.notify(queue: .main) {
                    print("Reloaded data from Realm")
                    complete()
                }
                return
        } else {
        /// Else hit the API for the recipes and save the category
            RecipeService.getDailyRecipes(for: randomCategory.rawValue, completion: {(results) in
                if let returnedRecipes = results.res {
                    //self.recipes = returnedRecipes
                    let list = List<Recipe>()
                    for recipe in returnedRecipes {
                        list.append(recipe)
                    }
                    do {
                        try RealmService.shared.updateUserField(field: User.CodingKeys.previousCategory, with: self.randomCategory.rawValue)
                        try RealmService.shared.saveDailyRecipes(list)
                        print("Updated \n \(list)")
                        let obj =  RealmService.shared.getDailyRecipes()
                        let updatedU = RealmService.shared.getCurrentUser()
                        print("Retrieved recipes from Realm : \(String(describing: obj)) \n For updated user obj : \(String(describing: updatedU))")
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
        print(recipes[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
