//
//  LabelHeaderView.swift
//  CustomLayoutCollectionViewTesting
//
//  Created by astroboy0803 on 2020/8/26.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class LabelHeaderView: UICollectionReusableView {

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .magenta
        label.font = .systemFont(ofSize: 40, weight: .bold)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
