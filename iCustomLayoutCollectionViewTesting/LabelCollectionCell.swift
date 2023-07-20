//
//  LabelCollectionCell.swift
//  CustomLayoutCollectionViewTesting
//
//  Created by astroboy0803 on 2020/8/26.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class LabelCollectionCell: UICollectionViewCell {
    static let cellIdentifiler = "LabelCollectionCell"
    
    private let title = UILabel()
    private let content = UILabel()
    
    private var viewModel: LabelCellViewModel? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final private func setupViews() {
        self.title.font = .systemFont(ofSize: 24, weight: .bold)
        self.title.numberOfLines = 0
        self.title.textAlignment = .right
        self.title.textColor = .darkGray
        //self.title.lineBreakMode = .byWordWrapping
        self.content.font = .systemFont(ofSize: 24, weight: .regular)
        self.content.numberOfLines = 0
        self.content.textAlignment = .left
        self.content.textColor = .black
        //self.content.lineBreakMode = .byWordWrapping
        
        [self.title, self.content].forEach({ view in
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 5
            view.layer.borderColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(126.0 / 255.0), blue: CGFloat(48.0 / 255.0), alpha: 1).cgColor
        })
        
        [self.contentView].forEach({ view in
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 5
            view.layer.borderColor = UIColor.darkGray.cgColor
        })
        
        [self.contentView, self.title, self.content].forEach({
            $0.backgroundColor = .clear
        })

        self.contentView.addSubview(self.title)
        self.contentView.addSubview(self.content)

        [self.title, self.content].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            self.title.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.title.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2),
            self.title.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -20),
            
            self.content.centerYAnchor.constraint(equalTo: self.title.centerYAnchor),
            self.content.heightAnchor.constraint(equalTo: self.title.heightAnchor),
            self.content.leadingAnchor.constraint(equalTo: self.title.trailingAnchor, constant: 10),
            self.content.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
    }
    
    final func setup(viewModel: LabelCellViewModel) {
        self.viewModel?.removeAllBindings()
        viewModel.removeAllBindings()
        self.viewModel = viewModel
        self.viewModel?.title.binding(listener: { [titleLabel = self.title] (newValue, _) in
            titleLabel.text = newValue
        })
        
        self.viewModel?.content.binding(listener: { [contentLabel = self.content] (newValue, _) in
            contentLabel.text = newValue
        })
    }
    
    // MARK: label autosize height
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        guard #unavailable(iOS 13.0) else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }
        
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        
//        label.preferredMaxLayoutWidth = layoutAttributes.frame.width
//            layoutAttributes.frame.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        let size = self.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        layoutAttributes.frame.size = size
        return layoutAttributes
    }
}
