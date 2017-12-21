////
////  FeedCell.swift
////  Youtube
////
////  Created by Nuno Pereira on 04/11/2017.
////  Copyright © 2017 Nuno Pereira. All rights reserved.
////
//
import UIKit

class FeedCell: BaseCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    let cellId = "cellId"
    var videos: [Video]?

    func fetchVideos() {
        ApiService.sharedInstance.fetchVideos { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }


    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        //Quando e especificada uma collectionView por exemplo dentro de uma celula e necessario especificar
        //o delegate e o datasource senao os metodos nem sequer sao chamados
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()


    override func setupViews() {
        super.setupViews()
        fetchVideos()


        backgroundColor = .brown

        addSubview(collectionView)

        collectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellId)
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0;
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! VideoCell
        cell.video = videos?[indexPath.item];

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //Aspect ratio is normally 16:9
        //We must calculate the correct height to fill all the image itself and the rest of components of the cell
        //Remove the margins from the screen width and divide by the aspect ratio and we have the height of the image
        let height = (frame.width - 16 - 16) /  16 * 9

        //Now to get the correct image of the cell we must add the height of the other components
        return CGSize(width: frame.width, height: height + 8 + 20 + 4 + 20 + 16)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoLauncher = VideoLauncher()
        videoLauncher.showVideoPlayer()
    }



}


