////
////  VideoCell.swift
////  Youtube
////
////  Created by Nuno Pereira on 31/10/2017.
////  Copyright © 2017 Nuno Pereira. All rights reserved.
////
//
import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    func setupViews() {

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoCell: BaseCell {

    var titleLabelHeightConstraint: NSLayoutConstraint?


    var video: Video? {
        didSet {
            titleLabel.text = video!.title

            setupThumbnailImage()
            setupProfileImage()
//            if let profileImageName = video?.channel?.profileImageName {
//                userProfileImageView.image = UIImage(named: profileImageName)
//            }

            if let channelName = video?.channel?.name, let numberViews = video?.number_of_views {

                //Make a number formatter so it appears the comas as US numbers correctly
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal

                let subtitleText = "\(channelName) - \(numberFormatter.string(from: numberViews)!) - 2 years ago"

                subtitleTextView.text = subtitleText
            }
//            thumbnailImageView.image = UIImage(named: video!.thumbnailImageName!)

            //mesaure title text to know the proper height for label and eventually whole cell
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesDeviceMetrics.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context: nil)
                if estimatedRect.size.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }

    func setupProfileImage() {
        if let profileImageUrl = video?.channel?.profile_image_name {
            userProfileImageView.loadingImageUsingUrlString(stringUrl: profileImageUrl)
        }
    }

    func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnail_image_name {
            thumbnailImageView.loadingImageUsingUrlString(stringUrl: thumbnailImageUrl)
        }
    }

    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "taylor_swift_blank_space")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = #imageLiteral(resourceName: "taylor_swift_profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    var separatorLineView: UIView = {
        let sep = UIView()
        sep.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        sep.translatesAutoresizingMaskIntoConstraints = false
        return sep
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //        label.backgroundColor = .purple
        label.text = "Taylor Swift - Blank space"
        label.numberOfLines = 2
        return label
    }()

    var subtitleTextView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        //        tv.backgroundColor = .orange
        tv.text = "TaylorSwiftVEVO - 1,604,684,607 - 2 years ago"
        //as TextView o texto tem sempre uma margem a esquerda e para eleminar essa margem
//        tv.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        tv.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        tv.textColor = UIColor.lightGray
        return tv
    }()

    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(separatorLineView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)

        thumbnailImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        thumbnailImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: userProfileImageView.topAnchor, constant: -8).isActive = true

        //         separatorLineView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        userProfileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        userProfileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        userProfileImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        userProfileImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true

        titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: userProfileImageView.trailingAnchor, constant: 8).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor).isActive = true


        titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 20)
        titleLabelHeightConstraint?.isActive = true

        subtitleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        subtitleTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        subtitleTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        subtitleTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    }
}



