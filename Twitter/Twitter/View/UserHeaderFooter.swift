//
//  Cells.swift
//  Twitter
//
//  Created by Nuno Pereira on 23/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import LBTAComponents
import UIKit

let twitterBlue = UIColor(r: 61, g: 167, b: 244)

//class que representa o rodape
class UserFooter: DatasourceCell {
    
    var textLabel : UILabel = {
        let label = UILabel()
        label.text = "Show me more"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = twitterBlue
        return label
    }()
    
    
    override func setupViews() {
        super.setupViews()
        
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = .white
        
        addSubview(whiteBackgroundView)
        addSubview(textLabel)
        
        whiteBackgroundView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 14, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        //Acrescenta-se 14 pixeis para se dar a sensacao de que as seccoes estao separadas por uma linha azul alta
        //Vai-se alterar na constraint para o texto aparecer 14 pixeis acima na constante da bottomAnchor para centrar
        //Depois acrescentar uma view com background branco que tem a altura do footer menos os 14 pixeis
        textLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 14, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}
//class que representa o cabecalho
class UserHeader: DatasourceCell {
    
    var textLabel : UILabel = {
        let label = UILabel()
        label.text = "WHO TO FOLLOW"
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        
        
        addSubview(textLabel)
//        textLabel.fillSuperview()
        textLabel.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
}

