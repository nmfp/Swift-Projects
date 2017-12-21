//
//  ViewController.swift
//  AutoLayout_LBTA
//
//  Created by Nuno Pereira on 29/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

extension UIColor {
    static let mainPink = UIColor(red: 232/255, green: 68/255, blue: 133/255, alpha: 1)
}

class ViewController: UIViewController {

    
    let bearImageView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "bear_first"));
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
       let tv = UITextView()
        
        let attributedText = NSMutableAttributedString(string: "Join us today in our fun and games!", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)])
        attributedText.append(NSAttributedString(string: "\n\n\nAre you ready for loads and loads of fun? Dont wait any longer! We hope to seee you in out stores soon! ", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.gray]))
        
        tv.attributedText = attributedText
        
//        tv.text = "Join us today in our fun and games!"
        tv.translatesAutoresizingMaskIntoConstraints = false
//        tv.font = UIFont.boldSystemFont(ofSize: 18)
        tv.textAlignment = .center
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.mainPink, for: .normal)
        return button
    }()
    
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = 4
        pc.currentPageIndicatorTintColor = .mainPink
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
//        view.addSubview(bearImageView)
        view.addSubview(descriptionTextView)
        
        setupLayout()
        
        setupBottomControls()
    }

    private func setupBottomControls() {
//        view.addSubview(previousButton)
//        previousButton.backgroundColor = .red
//        previousButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        
        let yellowView = UIView()
        yellowView.backgroundColor = .yellow
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        
        let greenView = UIView()
        greenView.backgroundColor = .green
        
        let bottomControlsContainerView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        bottomControlsContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomControlsContainerView.distribution = .fillEqually
        bottomControlsContainerView.axis = .horizontal
        
        view.addSubview(bottomControlsContainerView)
        
        
//        NSLayoutConstraint.activate([
//            bottomControlsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            bottomControlsContainerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
//            bottomControlsContainerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
//            bottomControlsContainerView.heightAnchor.constraint(equalToConstant: 50)
//            ])
        NSLayoutConstraint.activate([
            bottomControlsContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomControlsContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomControlsContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomControlsContainerView.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    private func setupLayout() {
        let imageContainerView = UIView()
//        imageContainerView.backgroundColor = .blue
        view.addSubview(imageContainerView)
//        imageContainerView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        imageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        imageContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        imageContainerView.addSubview(bearImageView)
        
        bearImageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        bearImageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        bearImageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.6).isActive = true
        
//        bearImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
//        bearImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        bearImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        descriptionTextView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }

}

