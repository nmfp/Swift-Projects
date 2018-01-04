//
//  ExpandableNames.swift
//  ContactsLBTA
//
//  Created by Nuno Pereira on 20/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation
import Contacts

struct ExpandableNames {
    var isExpanded: Bool
    var names: [FavoritableContact]
}

struct FavoritableContact {
    var contact: CNContact
    var hasFavourited: Bool
}
