//
//  RecipeDetailViewController.swift
//  Template
//
//  Created by Preston Perriott on 11/19/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var detailScrollView: UIScrollView!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    
    @IBOutlet weak var detailCookTimeLabel: UILabel!
    @IBOutlet weak var cookTimeView: UIView!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var detailIngredientsTableView: UITableView!
    @IBOutlet weak var detailDirectionsLabel: UILabel!
    @IBOutlet weak var directionsView: UIView!
    
    var recipe: Recipe!
    
    static func instantiate(with recipe: Recipe) -> RecipeDetailViewController {
        let vc = UIStoryboard(name: "RecipeDetail", bundle: nil).instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        vc.recipe = recipe
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailImageView.image = UIImage(data: try! Data(contentsOf: URL(string: recipe.image)!))
        self.detailTitle.text = recipe.title
        self.detailCookTimeLabel.text = "\(recipe.totalTime) min"
        self.view.applyGradient(with: [UIColor.init(red: 21/255, green: 21/255, blue: 23/255, alpha: 0.75).cgColor, UIColor.init(red: 41/255, green: 35/255, blue: 46/255, alpha: 0.75).cgColor, UIColor.init(red: 57/255, green: 48/255, blue: 66/255, alpha: 0.75).cgColor])
        
        let viewArray: [UIView] = [cookTimeView, descriptionView, directionsView, detailImageView]
        for view in viewArray {
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowOffset = CGSize(width: 4, height: 4)
            view.layer.shadowRadius = 6
            view.layer.cornerRadius = 6
        }
    }
    @IBAction func pressedBackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
