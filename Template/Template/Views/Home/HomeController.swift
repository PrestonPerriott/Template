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
    
    public func registerRecipeCells(recipeCollectionView: UICollectionView)
        {
        recipeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    
    public func reloadData(complete: @escaping () -> Void)
        {
        let group = DispatchGroup()
        group.enter()
        ///Search Realm for saved Daily recipes before making call
        RecipeService.getDailyRecipes(for: "kosher", completion: {(results) in
            if let returnedRecipes = results.res {
                self.recipes = returnedRecipes
                ///Save to realm 
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

extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath)
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count: CGFloat = 5.0
        let screen = collectionView.frame.size.height
        return CGSize(width: collectionView.frame.size.width, height: (screen/count))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
