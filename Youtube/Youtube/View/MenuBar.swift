//
//  MenuBar.swift
//  Youtube
//
//  Created by Nuno Pereira on 31/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

//    let textField: UITextField = { (placeHolder: String) in
//        let tv = UITextField()
//        tv.placeholder = placeHolder;
//        return tv
//    }("Email")
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor(r: 230, g: 32, b: 31)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()

    let cellId = "cellId"
    let imageNames = ["home", "trending", "subscriptions", "account"]

    var homeController: HomeController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(collectionView)

//        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
//        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true;
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true;
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        
//        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //Selecciona um elemento predefinido no carregamento da collectionView
        let startIndexPath = IndexPath(item: 0, section: 0);
        collectionView.selectItem(at: startIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
        
        setupHorizontalBar()
        
    }

    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1);
        
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leadingAnchor.constraint(equalTo: leadingAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageNames[indexPath.item])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor(r: 91, g: 14, b: 13)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print("HEIGHT: ", frame.height)
        return CGSize(width: frame.width / 4, height: frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(indexPath.item)
//        let x = CGFloat(indexPath.item) * frame.width / 4
//        horizontalBarLeftConstraint?.constant = x
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
//        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
//            super.layoutIfNeeded()
//        }, completion: nil)
    }



    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //Alterar a cor de uma imagem para outra cor
        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor(r: 91, g: 14, b: 13)
        return iv
    }()


    //Propriedade de collectionView afectada quando executada uma selecção de uma célula
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor(r: 91, g: 14, b: 13)
        }
    }

    //Propriedade de collectionView afectada quando é seleccionada uma célula
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor(r: 91, g: 14, b: 13)
        }
    }

    override func setupViews() {
        super.setupViews()
        addSubview(imageView)

        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
}


