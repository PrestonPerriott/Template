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
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// have controller reload data if date specifies its necessary
        
    }
}

extension HomeViewController: HomeControllerDelegate {
    
}

extension HomeViewController {
    
   func setupCollectionView() {
    controller.registerRecipeCells(recipeCollectionView: recipeCollectionView)
    recipeCollectionView.delegate = controller
    recipeCollectionView.dataSource = controller
    }
}
