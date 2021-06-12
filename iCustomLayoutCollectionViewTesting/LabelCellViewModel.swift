//
//  LabelCellViewModel.swift
//  CustomLayoutCollectionViewTesting
//
//  Created by astroboy0803 on 2020/8/27.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import Foundation

class LabelCellViewModel {
    let title: Box<String> = Box(nil)
    let content: Box<String> = Box(nil)
    
    init(title: String, content: String) {
        self.title.value = title
        self.content.value = content
    }
    
    final func removeAllBindings() {
        self.title.removeAllBinding()
        self.content.removeAllBinding()
    }
}
