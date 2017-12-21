//
//  TrendingCell.swift
//  Youtube
//
//  Created by Nuno Pereira on 04/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    override func fetchVideos() {
        ApiService.sharedInstance.fetchTrendingFeed { (videos) in
            self.videos = videos;
            self.collectionView.reloadData()
        }
    }
}
