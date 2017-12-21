//
//  AppDetailController.swift
//  AppStore
//
//  Created by Nuno Pereira on 12/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {//}, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let headerId = "headerId"
    let cellId = "cellId"
    let descriptionCellId = "descriptionCellId"
    
    var app: App? {
        didSet {
            
            if app?.Screenshots != nil {
                return
            }
            
            if let id = app?.id {
                let urlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
                URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    do {
                        if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [String:AnyObject] {
                            
                            let appDetail = App()
                            appDetail.setValuesForKeys(jsonDictionaries)
                            
                            //Ao afectar a app nesta espressao cria um ciclo infinito porque esta
                            //sempre a chamar o didSet, para isso cria-se a validacao se o array
                            //das imagens e diferente de nil, se for o pedido ja foi feito com sucesso
                            //e o objecto criado
                            self.app = appDetail
                        }
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    catch let err {
                        print(err)
                    }
                }).resume()
            }
        }
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(ScreenshotsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
    }
  
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        header.app = app
        return header;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    
    private func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Description\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.string.count);
        attributedText.addAttributes([NSAttributedStringKey.paragraphStyle: style], range: range)
        
        if let desc = app?.desc {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 11), NSAttributedStringKey.foregroundColor: UIColor.darkGray]))
        }
        
        return attributedText
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotsCell
        cell.app = app
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            let size = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: size, options: options, context: nil)
            //Sem os 30 nao calcula bem. E necessario adicionar os 30
            return CGSize(width: view.frame.width, height: rect.height + 30)
        }
        
        return CGSize(width: view.frame.width, height: 170)
    }
}


class AppDetailDescriptionCell: BaseCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "SAMPLE DESCRIPTION"
        return tv
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textView)
        addSubview(dividerLineView)
        
        textView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
        dividerLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}

class AppDetailHeader: BaseCell {
    
    var app: App? {
        didSet {
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
            nameLabel.text = app?.name
            if let price = app?.price?.stringValue {
                buyButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkGray
        return sc
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderWidth = 1
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews() {
        super.setupViews()

//      backgroundColor = .blue
        
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true;
        segmentedControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 14).isActive = true
        
        
        buyButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -56).isActive = true
        buyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14).isActive = true
        buyButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        buyButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        dividerLineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerLineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        dividerLineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}


class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
