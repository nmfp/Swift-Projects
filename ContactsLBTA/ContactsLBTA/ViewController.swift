//
//  ViewController.swift
//  ContactsLBTA
//
//  Created by Nuno Pereira on 14/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UITableViewController {

    let cellId = "cellId"
    
    let names = ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"]
    let cNames = ["Carl", "Chris", "Christina", "Cameron"]
    let dNames = ["David", "Dan"]
    
//    var twoDimensionalArray = [
//        ExpandableNames(isExpanded: true, names: ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"].map{FavoritableContact(name: $0, hasFavourited: false)}),
//            ExpandableNames(isExpanded: true, names: ["Carl", "Chris", "Christina", "Cameron"].map{FavoritableContact(name: $0, hasFavourited: false)}),
//            ExpandableNames(isExpanded: true, names: ["David", "Dan"].map{FavoritableContact(name: $0, hasFavourited: false)}),
//        ExpandableNames(isExpanded: true, names: [FavoritableContact(name: "Patrick", hasFavourited: false), FavoritableContact(name: "Patty", hasFavourited: false)])
//    ]

    var twoDimensionalArray = [ExpandableNames]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        
        fetchContacts()
        
    }
    
    fileprivate func fetchContacts() {
        let store = CNContactStore()
        
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err {
                print("Failed to request access: ", err)
                return
            }
            
            if granted {
                print("Acess granted")
                
                //So as keys que se definem, e que se podem aceder quando sao carregados os contactos
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    
                    var favoritableContacts = [FavoritableContact]()
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        print(contact.givenName)
                        print(contact.familyName)
                        print(contact.phoneNumbers.first?.value.stringValue ?? "")
                        
                        favoritableContacts.append(FavoritableContact(contact: contact, hasFavourited: false))
                    })
                    
                    let names = ExpandableNames(isExpanded: true, names: favoritableContacts)
                    self.twoDimensionalArray = [names]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                catch let err {
                    print("Failed to enumerate contacts: ", err)
                }
            }
            else {
                print("Acess denied")
            }
        }
    }
    
    var showIndexPaths = false
    
    @objc func handleShowIndexPath() {
        
        var indexPathsToReload = [IndexPath]()
        for section in twoDimensionalArray.indices {
            for row in twoDimensionalArray[section].names.indices {
                let indexPath = IndexPath(row: row, section: section)
                indexPathsToReload.append(indexPath)
            }
        }
        
        showIndexPaths = !showIndexPaths
        
        let animationStyle = showIndexPaths ? UITableViewRowAnimation.right : .left
        
        tableView.reloadRows(at: indexPathsToReload, with: animationStyle)
        
        
    }
    
    @objc func handleExpandClose(button: UIButton) {
        
        let section = button.tag;
        
        var indexPaths = [IndexPath]()
        for row in twoDimensionalArray[section].names.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = twoDimensionalArray[section].isExpanded
        twoDimensionalArray[section].isExpanded = !isExpanded
        
        if !isExpanded {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    
    func someMethod(cell: UITableViewCell) {

        //We are going to figure out which name we are clicking on
        guard let indexPathTapped = tableView.indexPath(for: cell) else {return}
        
        let contact = twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row]
        print(contact)
        
        let hasFavourite = contact.hasFavourited
        twoDimensionalArray[indexPathTapped.section].names[indexPathTapped.row].hasFavourited = !hasFavourite
        
        //Pode-se fazer reload ao index da tabela ou alterar mesmo a cor da accessoryView da linha
//        tableView.reloadRows(at: [indexPathTapped], with: .fade)
        cell.accessoryView?.tintColor = hasFavourite ? UIColor.lightGray : .red
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.yellow
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return twoDimensionalArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimensionalArray[section].isExpanded ? twoDimensionalArray[section].names.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
        
        //Para a linha acima, a celula nao tinha acesso a detailTextLabel para mostrar o numero de telefone,
        //para isso instancia-se a celula directamente passando o tipo subtitle ao construtor
        let cell = ContactCell(style: .subtitle, reuseIdentifier: cellId)
        
//        let name = indexPath.section == 0 ? names[indexPath.row] : cNames[indexPath.row]
        cell.link = self
        let favoritableContact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = favoritableContact.contact.givenName + " " + favoritableContact.contact.familyName
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        cell.detailTextLabel?.text = favoritableContact.contact.phoneNumbers.first?.value.stringValue
        
        cell.accessoryView?.tintColor = favoritableContact.hasFavourited ? UIColor.red : .lightGray
        
        if showIndexPaths{
//            cell.textLabel?.text = "\(contact.name) Section: \(indexPath.section) Row: \(indexPath.row)"
            
        }
        return cell
    }

}

