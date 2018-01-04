//
//  CustomCell.swift
//  ContactsLBTA
//
//  Created by Nuno Pereira on 29/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    var link: ViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
    
        //Todas as celulas da tabela a direita tem uma zona do tipo accessoryView que esta escondida e neste caso
        //pode ser usada para igualar a um botao para definir a celula como preferida
        let starButton = UIButton(type: .system)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.setImage(#imageLiteral(resourceName: "fav_star"), for: .normal)
        
        //mudar a cor do botao de azul para vermelho
        starButton.tintColor = .red
        starButton.addTarget(self, action: #selector(handleMarkAsFavourite), for: .touchUpInside)
        
        accessoryView = starButton
    }
    
    @objc func handleMarkAsFavourite() {
        link?.someMethod(cell: self)
    }
}
