//
//  ExpandableNames.swift
//  ContactsLBTA
//
//  Created by Nuno Pereira on 20/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import Foundation

struct ExpandableNames {
    var isExpanded: Bool
    var names: [Contact]
}

struct Contact {
    var name: String
    var hasFavourited: Bool
}
