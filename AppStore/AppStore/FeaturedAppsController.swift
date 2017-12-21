//
//  ViewController.swift
//  AppStore
//
//  Created by Nuno Pereira on 09/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class FeaturedAppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellId = "cellId"
    let largeCategoryCell = "largeCategoryCell"
    let headerId = "headerId"
    
    var featuredApps: FeaturedApps?
    var appCategories = [AppCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Featured Apps"
        
        AppCategory.fetchAppCategories { (featuredApps) in
            self.featuredApps = featuredApps
            self.appCategories = featuredApps.appCategories!
            self.collectionView?.reloadData()
        }
        
        collectionView?.backgroundColor = .white
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCategoryCell)
        
        //registar o header
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appCategories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCategoryCell, for: indexPath) as! LargeCategoryCell
            cell.appCategory = appCategories[indexPath.item]
            cell.featuredAppsController = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.appCategory = appCategories[indexPath.item]
        cell.featuredAppsController = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 {
            return CGSize(width: view.frame.width, height: 160)
        }
        
        return CGSize(width: view.frame.width, height: 230)
    }

    
    //Metodo que retorna a view do header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
        header.appCategory = featuredApps?.bannerCategory
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let appDetailController = UIViewController()
//        navigationController?.pushViewController(appDetailController, animated: true)
//    }
    
    func showAppDetailForApp(app: App){
        let layout = UICollectionViewFlowLayout()
        let appDetailController = AppDetailController(collectionViewLayout: layout)
        appDetailController.app = app
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}

class Header: CategoryCell {
    
    let bannerCellId = "bannerCellId"
    
    override func setupViews() {
//        super.setupViews()
//
//
//        appsCollectionView.delegate = self
//        appsCollectionView.dataSource = self
        
        appsCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: bannerCellId);
        
        addSubview(appsCollectionView)
        

        
        appsCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        appsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        appsCollectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        appsCollectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        

    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2 + 50, height: frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellId, for: indexPath) as! BannerCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    private class BannerCell: AppCell {
        override func setupViews() {
            addSubview(imageView)
            
            //Para colocar umas bordas nas imagens, necessario definir a cor e a largura da vorda
            imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            imageView.layer.borderWidth = 0.5
            
            imageView.layer.cornerRadius = 0
            imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
}

class LargeCategoryCell: CategoryCell {
    
    let largeAppCellId = "largeAppCellId"
    
    override func setupViews() {
        super.setupViews()
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeAppCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 32)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCellId, for: indexPath) as! LargeAppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    private class LargeAppCell: AppCell {
        override func setupViews() {
            addSubview(imageView)
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
}


