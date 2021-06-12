//
//  CustomCollectionViewController.swift
//  CustomLayoutCollectionViewTesting
//
//  Created by astroboy0803 on 2020/8/26.
//  Copyright © 2020 BruceHuang. All rights reserved.
//

import UIKit

class CustomCollectionViewController: UIViewController {
    
    enum GridLayoutConfiguration {
        case average(UInt)
        case custom(UICollectionViewLayout)
    }
    
    private let addButton: UIButton = UIButton()
    
    private let deleteButton: UIButton = UIButton()
    
    private var isDelete: Bool = false

    private var layoutConfigure: GridLayoutConfiguration
    
    init(layoutConfigure: GridLayoutConfiguration) {
        self.layoutConfigure = layoutConfigure
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy private var items: [[LabelCellViewModel]] = {
        var result = [[LabelCellViewModel]]()
        let sections = Int.random(in: 5...10)
        print("sections = \(sections)")
        for section in 0..<sections {
            let count = Int.random(in: 5...10)
            print("\(section)_\(count)")
            var values = [LabelCellViewModel]()
            for index in 1...count {
                let title = "section: \(section + 1)\nindex: \(index)"
                let randomCnt = Int.random(in: 1...5)
                var content = "repeat print count = \(randomCnt)"
                let value = Int.random(in: 1...100)
                for idx in 1...randomCnt {
                    content += "\n\(idx) - value = \(value)"
                }
                values.append(LabelCellViewModel(title: title, content: content))
            }
            result.append(values)
        }
        return result
    }()
    
    lazy private var collectionView: UICollectionView = { [configure = self.layoutConfigure] in
        
        switch configure {
        case let .custom(layout):
            return UICollectionView(frame: .zero, collectionViewLayout: layout)
        case let .average(rowCount):
            let layout = CollectionLayoutManager.generateEditLayout(editLayout: rowCount < 2 ? .single : .average(rowCount), callCount: { [weak self] section in
                guard let self = self else {
                    return 0
                }
                return self.items[section].count
            })
            return UICollectionView(frame: .zero, collectionViewLayout: layout)
        }
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.registers()
        self.setupTargets()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupTargets() {
        for button in [self.addButton, self.deleteButton] {
            button.addTarget(self, action: #selector(self.changeGridSize(_:)), for: .touchUpInside)
        }
    }
    
    @objc
    private func changeGridSize(_ sender: UIButton) {
        switch sender {
        case self.addButton:
            if case let .average(rowCount) = self.layoutConfigure, rowCount < 5 {
                self.layoutConfigure = .average(rowCount + 1)
            }
        case self.deleteButton:
            if case let .average(rowCount) = self.layoutConfigure, rowCount > 1 {
                self.layoutConfigure = .average(rowCount - 1)
            }
        default:
            return
        }
    }
    
    final private func setupUI() {
        // self.collectionView.contentInsetAdjustmentBehavior = .always
        
        self.addButton.setTitle("+", for: .normal)
        self.deleteButton.setTitle("-", for: .normal)
        [self.addButton, self.deleteButton].forEach({
            $0.titleLabel?.font = .systemFont(ofSize: 36, weight: .semibold)
            $0.setTitleColor(.white, for: .normal)
            $0.setBackgroundImage(self.colorToImage(color: .systemBlue), for: .normal)
            $0.setTitleColor(.white, for: .highlighted)
            $0.setBackgroundImage(self.colorToImage(color: .black), for: .highlighted)
        })
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor(displayP3Red: 224.0/255.0, green: 216.0/255.0, blue: 200.0/255.0, alpha: 1)
        self.collectionView.backgroundColor = UIColor(displayP3Red: 248.0/255.0, green: 241.0/255.0, blue: 227.0/255.0, alpha: 1)
        
        [self.addButton, self.deleteButton, self.collectionView].forEach({
            contentView.addSubview($0)
        })
        [contentView].forEach({
            self.view.addSubview($0)
        })
        
        [self.addButton, self.deleteButton, self.collectionView, contentView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        var contraints: [NSLayoutConstraint]
        
        if #available(iOS 11.0, *) {
            contraints = [
                contentView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ]
        } else {
            contraints = [
                contentView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ]
        }
        
        contraints.append(contentsOf: [
            self.deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            self.deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            self.deleteButton.widthAnchor.constraint(equalToConstant: 40),
            self.deleteButton.heightAnchor.constraint(equalToConstant: 40),
            
            self.addButton.topAnchor.constraint(equalTo: self.deleteButton.topAnchor),
            self.addButton.bottomAnchor.constraint(equalTo: self.deleteButton.bottomAnchor),
            self.addButton.widthAnchor.constraint(equalTo: self.deleteButton.widthAnchor),
            self.addButton.trailingAnchor.constraint(equalTo: self.deleteButton.leadingAnchor, constant: -20),
            
            self.collectionView.topAnchor.constraint(equalTo: self.deleteButton.bottomAnchor, constant: 10),
            self.collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            self.collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            self.collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate(contraints)
    }
    
    final private func registers() {
        self.collectionView.register(LabelCollectionCell.self, forCellWithReuseIdentifier: LabelCollectionCell.cellIdentifiler)
        self.collectionView.register(LabelHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    
    // MARK: 顏色轉為圖片
    final private func colorToImage(color: UIColor) -> UIImage {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        return render.image { (context) in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        }
    }
}

extension CustomCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if isDelete {
//            self.items[indexPath.section].remove(at: indexPath.item)
//            collectionView.performBatchUpdates({
//                collectionView.deleteItems(at: [indexPath])
//            }, completion: nil)
//        } else {
//            self.items[indexPath.section].insert(LabelCellViewModel(title: "insert title", content: "insert content"), at: indexPath.item)
//            collectionView.performBatchUpdates({
//                collectionView.insertItems(at: [indexPath])
//            }, completion: nil)
//        }
//
//        isDelete = !isDelete
        
        
        let cellVM = self.items[indexPath.section][indexPath.item]
        cellVM.content.value = (cellVM.content.value ?? "") + "\n" + (cellVM.content.value ?? "")
        collectionView.reloadItems(at: [indexPath])
    }
}

extension CustomCollectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCollectionCell.cellIdentifiler, for: indexPath)
        if let labelCell = cell as? LabelCollectionCell {
            labelCell.setup(viewModel: self.items[indexPath.section][indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as! LabelHeaderView
        headerView.label.text = "Header (\(indexPath.section + 1) / \(self.items.count)) - count = (\(self.items[indexPath.section].count))"
        return headerView
    }
}
