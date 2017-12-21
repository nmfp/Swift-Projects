//
//  CategoryCell.swift
//  AppStore
//
//  Created by Nuno Pereira on 09/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit


class CategoryCell : UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var appCategory: AppCategory? {
        didSet {
            if let name = appCategory?.name {
                nameLabel.text = name
            }
            self.appsCollectionView.reloadData()
        }
    }
    
    var featuredAppsController: FeaturedAppsController?
    
        let cellId = "appCellId"
    
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best New Apps"
        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.backgroundColor = .green
        return label
    }()
    
    lazy var appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
       cv.backgroundColor = .clear
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    let dividerLine: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    
    func setupViews(){
//        backgroundColor = .yellow
        
        
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(nameLabel)
        addSubview(appsCollectionView)
        addSubview(dividerLine)
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        appsCollectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        appsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        appsCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        appsCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        
        dividerLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
        dividerLine.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let apps = appCategory?.apps else { return 0}
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    //Reduz-se a altura em 32 por se ter adicionado a label do nome com 30 mais os separadores
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let app = appCategory?.apps?[indexPath.item] {
            featuredAppsController?.showAppDetailForApp(app: app)
        }
    }
}


class AppCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var app: App? {
        didSet {
            guard let app = app else {return}
            imageView.image = UIImage(named: app.imageName!)
            categoryLabel.text = app.category
            
            //Validar o preco pois para as free a label e vazia
            if let price = app.price {
                priceLabel.text = "$\(price)"
            }
            else {
                priceLabel.text = ""
            }
            if let name = app.name {
                nameLabel.text = name
                
                let size = CGSize(width: frame.width, height: 1000)
                let rect = NSString(string: name).boundingRect(with: size, options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
                
                //Se for true e porque sao 2 linhas
                if rect.height > 20 {
                    categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
                }
                else {
                    categoryLabel.frame = CGRect(x: 0, y: frame.width + 22, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 40, width: frame.width, height: 20)
                }
                
                nameLabel.frame = CGRect(x: 0, y: frame.width + 5, width: frame.width, height: 40)
                //Faz com que puxe o texto para cima porque redesenha as labels
                nameLabel.sizeToFit()
            }
        }
    }
    
    

    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "frozen");
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Disney Build It: Fronzen"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$3.99"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
    }()
    
    
    func setupViews(){
//        backgroundColor = .green
        
        addSubview(imageView)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        
        addSubview(nameLabel)
        nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        
        addSubview(categoryLabel)
        categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
        
        addSubview(priceLabel)
        priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
    }
}
