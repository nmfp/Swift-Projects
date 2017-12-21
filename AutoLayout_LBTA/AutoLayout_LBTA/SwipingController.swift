//
//  SwipingController.swift
//  AutoLayout_LBTA
//
//  Created by Nuno Pereira on 29/10/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    var pages: [Page] = [
        Page(imageName: "bear_first", headerString: "Join us today in our fun and games!", bodyText: "Are you ready for loads and loads of fun? Dont wait any longer! We hope to seee you in out stores soon!"),
        Page(imageName: "heart_second", headerString: "Subscribe and get coupons on our daily events", bodyText: "Get notified of the savings immediatly when we announce them on our website. Make sure to also you give us any feedback you have."),
        Page(imageName: "leaf_third", headerString: "VIP members special services", bodyText: ""),
        Page(imageName: "bear_first", headerString: "Join us today in our fun and games!", bodyText: "Are you ready for loads and loads of fun? Dont wait any longer! We hope to seee you in out stores soon!"),
        Page(imageName: "heart_second", headerString: "Subscribe and get coupons on our daily events", bodyText: "Get notified of the savings immediatly when we announce them on our website. Make sure to also you give us any feedback you have."),
        Page(imageName: "leaf_third", headerString: "VIP members special services", bodyText: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        //define a paginacao
        collectionView?.isPagingEnabled = true
        
        setupBottomControls()
    }
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrevious), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    @objc private func handleNext() {
        //Evita a aplicacao crashar por index out of bounds
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
    }
    
    @objc private func handlePrevious() {
        //Evita a aplicacao crashar por index out of bounds
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .mainPink
        pc.pageIndicatorTintColor = UIColor(red: 249/255, green: 207/255, blue: 224/255, alpha: 1)
        return pc
    }()
    
    private func setupBottomControls() {
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
    
    //Metodo chamado quando e feito o scroll e este termina
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let x = targetContentOffset.pointee.x

        //o x da o valor em pixeis do fim da pagina, acumulando sempre mais um valor identico a largura da frame cada vez que se faz scroll
        //o que quer dizer que se se dividir x pela largura da frame obtem o valor da pagina correcta
//        375.0 375.0 1.0
//        750.0 375.0 2.0
//        1125.0 375.0 3.0
//        1500.0 375.0 4.0
//        1875.0 375.0 5.0
        print(x, view.frame.width, x/view.frame.width)
        pageControl.currentPage = Int(x/view.frame.width)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()

            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            }
            else {
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
                
            }
        }, completion: nil)
    }

    
    //Define o minimo de margem entre as celulas. Sem este metodo, ao fazer scroll ficava uma lista branca no ecra de 10 pixeis que e o valor por defeiro
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    //Metodo que define o tamanho da celula
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
}
