////
////  SettingCell.swift
////  Youtube
////
////  Created by Nuno Pereira on 02/11/2017.
////  Copyright © 2017 Nuno Pereira. All rights reserved.
////
//
import UIKit

class SettingCell: BaseCell {


    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.darkGray
        }
    }


    var setting: Setting? {
        didSet{
            guard let setting = setting else {return}
            nameLabel.text = setting.name.rawValue;
            iconImageView.image = UIImage(named: setting.imageName)?.withRenderingMode(.alwaysTemplate)
            //Ao colocar o renderingMode .alwaysTemplate para permitir alteracoes as imagens ficam azuis e para isso tem que se alterar agora a por para cinzento escuro
            iconImageView.tintColor = .darkGray
        }
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()

    let iconImageView: UIImageView = {
        let iv = UIImageView();
        iv.image = UIImage(named: "settings")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()


    override func setupViews() {
        super.setupViews()

        addSubview(nameLabel)
        addSubview(iconImageView)

        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

//        nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true



    }

}


