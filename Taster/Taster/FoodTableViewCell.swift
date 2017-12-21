//
//  FoodTableViewCell.swift
//  Taster
//
//  Created by Nuno Pereira on 30/03/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var food : Food? {
        didSet {
            self.foodNameLabel.text = self.food?.name;
            self.locationLabel.text = self.food?.local;
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
