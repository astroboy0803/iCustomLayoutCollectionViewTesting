//
//  CustomFlowLayout.swift
//  CustomLayoutCollectionViewTesting
//
//  Created by astroboy0803 on 2020/8/26.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class CustomFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.initSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initSetup()
    }
    
    final private func initSetup() {
        self.scrollDirection = .vertical
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.headerReferenceSize = CGSize(width: 0, height: 40)
        
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttrElements = super.layoutAttributesForElements(in: rect)
        
        layoutAttrElements?.forEach({ layoutAttributes in
            guard layoutAttributes.representedElementCategory == .cell, let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame else {
                return
            }
            layoutAttributes.frame = newFrame
        })
        
        return layoutAttrElements
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView, let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else {
            return nil
        }
        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.frame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}
