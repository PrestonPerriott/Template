//
//  HomeCollectionViewCell.swift
//  Template
//
//  Created by Preston Perriott on 10/23/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var imageCoverView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let regHeight = HomeLayoutConstants.Cell.regularHeight
        let featHeight = HomeLayoutConstants.Cell.featuredHeight
        
        let delta = 1 - ((featHeight - frame.height) / (featHeight - regHeight))
        
        let minAlpha: CGFloat = 0.25
        let maxAlpha: CGFloat = 0.70
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
        
        /// Scaling contents of cell
        let scale = max(delta, 0.5)
        recipeTitle.transform = CGAffineTransform(scaleX: scale, y: scale)
        caloriesLabel.alpha = delta
    }
}
