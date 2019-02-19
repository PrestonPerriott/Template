//
//  HomeViewController.swift
//  Template
//
//  Created by Preston Perriott on 10/23/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var recipeCollectionView: UICollectionView!
    private var controller = HomeController()

    override func viewDidLoad() {
        super.viewDidLoad()

        controller.delegate = self
        setupCollectionView()

        if let current = RealmService.shared.getCurrentUser() {
            print("HomeVC - The accessToken of our current user is : \(current.accessToken)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// have controller reload data if date specifies its necessary
        controller.reloadData {
            self.recipeCollectionView.reloadData()
        }
    }
    
}

extension HomeViewController: HomeControllerDelegate {
    func didSelectRecipe(recipe: Recipe) {
        print("recipe selected")
        let detailVC = RecipeDetailViewController.instantiate(with: recipe)
        present(detailVC, animated: true, completion: nil)
    }
}

extension HomeViewController {
    
   func setupCollectionView() {
    controller.registerRecipeCells(recipeCollectionView: recipeCollectionView)
    recipeCollectionView.delegate = controller
    recipeCollectionView.dataSource = controller
    recipeCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
}
