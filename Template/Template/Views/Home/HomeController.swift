//
//  HomeController.swift
//  Template
//
//  Created by Preston Perriott on 10/23/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import Foundation
import UIKit
protocol HomeControllerDelegate: class {
}

class HomeController: NSObject {
    
    weak var delegate: HomeControllerDelegate?
    private var recipes = [Recipe]()
    private var didGetDaily: Bool = false
    private var randomCategory: HomeRecipeCategoryType = .healthy
    
    ///For now we randomize the search query
    ///In the future we'll want to save the last 10 past queries so we don't
    //keep showing the user data they've just seen.
    
    ///Or Slowly pool a list of all the different categories to choose from
    
    public func registerRecipeCells(recipeCollectionView: UICollectionView)
        {
        recipeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    
    public func reloadData(complete: @escaping () -> Void)
        {
        let group = DispatchGroup()
        group.enter()
        ///Search Realm for saved Daily recipes before making call
        ///Search realm for last saved category and choose other
        randomCategory = HomeRecipeCategoryType.random()
        RecipeService.getDailyRecipes(for: randomCategory.rawValue, completion: {(results) in
            if let returnedRecipes = results.res {
                self.recipes = returnedRecipes
                ///Save to realm
                ///Save searched category to realm & saved recipe
                group.leave()
            } else {
                let err = NSError(domain: "Unkown connection err", code: 300, userInfo: nil)
                print(err)
            }
        })
        group.notify(queue: .main) {
            print("Reloaded data")
            complete()
        }
    }
    
}

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colors = [UIColor.blue, UIColor.red, UIColor.purple, UIColor.orange, UIColor.green, UIColor.yellow, UIColor.gray]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
//     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let count: CGFloat = 5.0
//        let screen = collectionView.frame.size.height
//        return CGSize(width: collectionView.frame.size.width, height: (screen/count))
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
