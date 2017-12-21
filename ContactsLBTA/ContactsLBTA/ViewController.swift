//
//  ViewController.swift
//  ContactsLBTA
//
//  Created by Nuno Pereira on 14/11/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let cellId = "cellId"
    
    let names = ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"]
    let cNames = ["Carl", "Chris", "Christina", "Cameron"]
    let dNames = ["David", "Dan"]
    
    var twoDimensionalArray = [
        ExpandableNames(isExpanded: true, names: ["Amy", "Bill", "Zack", "Steve", "Jack", "Jill", "Mary"].map{Contact(name: $0, hasFavourited: false)}),
            ExpandableNames(isExpanded: true, names: ["Carl", "Chris", "Christina", "Cameron"].map{Contact(name: $0, hasFavourited: false)}),
            ExpandableNames(isExpanded: true, names: ["David", "Dan"].map{Contact(name: $0, hasFavourited: false)}),
        ExpandableNames(isExpanded: true, names: [Contact(name: "Patrick", hasFavourited: false), Contact(name: "Patty", hasFavourited: false)])
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        Contact(name: <#T##String#>, hasFavourited: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show IndexPath", style: .plain, target: self, action: #selector(handleShowIndexPath))
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ContactCell.self, forCellReuseIdentifier: cellId)
        
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
//        print("We are on VC...")
        
        //We are going to figure out which name we are clicking on
        guard let indexPathTapped = tableView.indexPath(for: cell) else {return}
//        print(indexPathTapped)
        
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
//        if section == 0 {
//            return names.count
//        }
//        return cNames.count
        return twoDimensionalArray[section].isExpanded ? twoDimensionalArray[section].names.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactCell
//        let name = indexPath.section == 0 ? names[indexPath.row] : cNames[indexPath.row]
        cell.link = self
        let contact = twoDimensionalArray[indexPath.section].names[indexPath.row]
        
        cell.textLabel?.text = contact.name
        
        cell.accessoryView?.tintColor = contact.hasFavourited ? UIColor.red : .lightGray
        
        if showIndexPaths{
            cell.textLabel?.text = "\(contact.name) Section: \(indexPath.section) Row: \(indexPath.row)"
            
        }
        return cell
    }

}

