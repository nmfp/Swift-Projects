//
//  FoodListTableViewController.swift
//  Taster
//
//  Created by Nuno Pereira on 31/03/2017.
//  Copyright © 2017 Nuno Pereira. All rights reserved.
//

import UIKit

class FoodListTableViewController: UITableViewController {
    
    
    var resultFood = [Food]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "foodTableCell");
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultFood.count;
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTableCell", for: indexPath) as! FoodTableViewCell;
        
        cell.food = resultFood[(indexPath as NSIndexPath).row];
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = resultFood[indexPath.row];
        self.performSegue(withIdentifier: "foodDetailSegue", sender: food);
    }
    
}
