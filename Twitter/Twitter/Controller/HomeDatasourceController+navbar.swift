//
//  HomeDatasourceController+navbar.swift
//  Twitter
//
//  Created by Nuno Pereira on 26/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

extension HomeDatasourceController {
    
    func setupNavigationBarItems() {
        setupRemainingtNavItems()
        setupLeftNavItem()
        setupRightNavItems()
        
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        //Estas 2 linhas de codigo apagam a linha que separa a navbar do resto da VC
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        //Define-se uma linha mais clara
        let navSeparatorView = UIView()
        navSeparatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        
        view.addSubview(navSeparatorView)
        
        //Coloca-se essa linha no topo da tela para pertencer a navbar
        navSeparatorView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    func setupRemainingtNavItems() {
        let titleImageView = UIImageView(image: #imageLiteral(resourceName: "title_icon"))
        //So igualando a imageView a titleView vai fazer a imagem ficar muito grande, para isso tem que se especificar um CGRect
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        //igualar a titleView à view criada
        navigationItem.titleView = titleImageView
    }
    
    func setupLeftNavItem() {
        let followButton = UIButton(type: .system);
        followButton.setImage(#imageLiteral(resourceName: "follow").withRenderingMode(.alwaysOriginal), for: .normal)
        followButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: followButton)
    }
    
    func setupRightNavItems() {
        let searchButton = UIButton(type: .system)
        searchButton.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysOriginal), for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        let composeButton = UIButton(type: .system)
        composeButton.setImage(#imageLiteral(resourceName: "compose").withRenderingMode(.alwaysOriginal), for: .normal)
        composeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        
        
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: composeButton), UIBarButtonItem(customView: searchButton)]
    }
}
