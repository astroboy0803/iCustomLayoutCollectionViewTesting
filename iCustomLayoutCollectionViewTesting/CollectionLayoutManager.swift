//
//  CollectionLayoutManager.swift
//  CustomLayoutCollectionViewTesting
//
//  Created by astroboy0803 on 2020/8/29.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class CollectionLayoutManager {
    
    private static let commonHeight: CGFloat = 60
    
    enum EditGridLayout {
        case single
        case average(UInt)
    }
    
    static func generateEditLayout(editLayout: EditGridLayout, callCount: @escaping (Int) -> Int) -> UICollectionViewLayout {
        if #available(iOS 13.0, *) {
            return self.generateCompositionalLayout(editLayout: editLayout, callCount: callCount)
        } else {
            let gridLayout: GridCollectionLayout
            switch editLayout {
            case .single:
                gridLayout = .init(arrangement: .single)
            case .average(let uInt):
                var count: CGFloat = 1
                let part: CGFloat = count / CGFloat(uInt)
                var ratios: [CGFloat] = []
                while (count - part) > 0 {
                    ratios.append(part)
                    count -= part
                }
                if count > 0 {
                    ratios.append(count)
                }
                gridLayout = .init(arrangement: .group(ratios: ratios))
            }
            gridLayout.isHeader = false
            return gridLayout
        }
    }
    
    @available(iOS 13.0, *)
    private static func generateCompositionalLayout(editLayout: EditGridLayout, callCount: @escaping (Int) -> Int) -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (secIndex, envrionment) -> NSCollectionLayoutSection? in
            
            let itemCount: Int
            if case let .average(grids) = editLayout, grids > 0 {
                itemCount = Int(grids)
            } else {
                itemCount = 1
            }
            let sectionCount = callCount(secIndex)
            let commonGroupCount = sectionCount / itemCount
            let remainderCount = sectionCount % itemCount
            var allGroupCount = commonGroupCount
            let hasRemainder = remainderCount != 0
            if hasRemainder {
                allGroupCount += 1
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(self.commonHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(self.commonHeight))
            let commonGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: itemCount)
            
            var subitems = [NSCollectionLayoutItem]()
            subitems.append(contentsOf: Array(repeating: commonGroup, count: commonGroupCount))
            if hasRemainder {
                let lastGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: remainderCount)
                subitems.append(lastGroup)
            }
            
            let combineGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(self.commonHeight))
            let combineGroup = NSCollectionLayoutGroup.vertical(layoutSize: combineGroupSize, subitems: subitems)
            return NSCollectionLayoutSection(group: combineGroup)
        }
        
//        let itemCount: Int
//        if case let .average(grids) = editLayout, grids > 0 {
//            itemCount = Int(grids)
//        } else {
//            itemCount = 1
//        }
//
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(self.commonHeight))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(self.commonHeight))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: itemCount)
//        let section = NSCollectionLayoutSection(group: group)
//        return UICollectionViewCompositionalLayout(section: section)
    }
}
