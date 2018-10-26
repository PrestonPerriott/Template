//
//  HomeCollectionViewLayout.swift
//  Template
//
//  Created by Preston Perriott on 10/26/18.
//  Copyright © 2018 Preston Perriott. All rights reserved.
//

import UIKit

struct HomeLayoutConstants {
    struct Cell {
        static let featuredHeight: CGFloat = 280
        static let regularHeight: CGFloat = 100
    }
}

class HomeCollectionViewLayout: UICollectionViewLayout {

    /// Amount user must scroll before featured cell changes
    let dragOffset: CGFloat = 180
    var cache: [UICollectionViewLayoutAttributes] = []
    
    /// Returns index of current featured Cell
    var featuredCellIndex: Int {
        let yContentOffset = collectionView!.contentOffset.y
        return max(0, Int(yContentOffset / dragOffset))
    }
    
    /// Returns a val between 1 and 0, representing how close the next cell is to becoming the featured cell
    var nextCellPercentageOffset: CGFloat {
        let yContentOffset = collectionView!.contentOffset.y
        return (yContentOffset / dragOffset) - CGFloat(featuredCellIndex)
    }
    
    var width: CGFloat {
        return collectionView!.frame.width
    }
    
    var height: CGFloat {
        return collectionView!.bounds.width
    }
    
    var numberOfCells: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
}

extension HomeCollectionViewLayout {
    /// Returns content size of everything in collectionView
    override var collectionViewContentSize: CGSize {
        let contentHeight = (CGFloat(numberOfCells) * dragOffset) + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        let regularHeight = HomeLayoutConstants.Cell.regularHeight
        let featuredHeight = HomeLayoutConstants.Cell.featuredHeight
        
        var frame = CGRect.zero
        var y: CGFloat = 0
        
        /// Iterate through Cells and adjust size according to its position
        for cell in 0..<numberOfCells {
            /// current Cell index and attributes
            let indexPath = IndexPath(item: cell, section: 0)
            let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            /// Prepare cell to move up or down, ost cells are regular height, so it defualts to regular height
            attr.zIndex = cell
            var height = regularHeight
            
            /// Determine cell status
            if indexPath.item == featuredCellIndex {
                ///calc y offset, used to get new y for cell
                let yOffset = regularHeight * nextCellPercentageOffset
                y = collectionView!.contentOffset.y - yOffset
                /// set cell height to be featured hieght
                height = featuredHeight
            } else if indexPath.item == (featuredCellIndex + 1) && indexPath.item != numberOfCells {
                /// calc the largest y could be of cell next to featured
                let maxY = y + regularHeight
                /// calculated height during scroll
                height = regularHeight + max((featuredHeight - regularHeight) * nextCellPercentageOffset, 0)
                /// Combined get corrected Y val
                y = maxY - height
            }
            
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attr.frame = frame
            cache.append(attr)
            y = frame.maxY
        }
    }
    
    /// Return all attributes in the cache whose frame intersects with the rect passed to the method
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    /// Returns true b/c we need layout to constantly invalidate as the user scrolls
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    /// Smoother Scrolling
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let cellIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = cellIndex * dragOffset
        return CGPoint(x: 0, y: yOffset)
    }
}
