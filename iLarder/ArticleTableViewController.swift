//
//  ArticleTableViewController.swift
//  iLarder
//
//  Created by Cristobal Galleguillos on 06-12-17.
//  Copyright © 2017 URSis. All rights reserved.
//

import UIKit
import SQLite3

class ArticleTableViewController: UITableViewController {
    
    var db: OpaquePointer?
    var productList = [Product]()
    var textFieldName = UITextField()
    var inputsa = [String]()
    
    @IBOutlet weak var tableViewProducts: UITableView!
    //@IBOutlet weak var textFieldName: UITextField!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ArticuloTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticuloTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let product = productList[indexPath.row]
        
        cell.ArticleName?.text = product.name
        cell.ArticleQuantity?.text = String(product.remaning)
        //cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    
    func readValues(){
        productList.removeAll()
        
        let queryString = "SELECT * FROM Product"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let rate = sqlite3_column_double(stmt, 2)
            let remanings = sqlite3_column_int(stmt, 3)
            
            productList.append(Product(id: Int(id), name: String(describing: name), rate: Double(rate), remaning: Int(remanings) ))
        }
        
        self.tableViewProducts.reloadData()
        print("mas")
    }
    
    @IBAction func addProduct(_ sender: Any) {
        
        let alert = UIAlertController(
            title: "Nuevo Articulo",
            message: "Ingresar datos del articulo",
            preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addTextField{(textField: UITextField) in
            textField.placeholder = "Nombre"

        }
        alert.addTextField{(textField: UITextField) in
            textField.placeholder = "Cantidad"

        }
        alert.addTextField{(textField: UITextField) in
            textField.placeholder = "Consumo"

        }
        
        let addAction = UIAlertAction(
        title: "Agregar", style: UIAlertActionStyle.default){
            (action) -> Void in
            self.inputsa.append(alert.textFields![0].text!)
            self.inputsa.append(alert.textFields![1].text!)
            self.inputsa.append(alert.textFields![2].text!)

            Functionsa().buttonSave(inputs: self.inputsa)
            self.readValues()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ProductDatabase.sqlite")
        
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Product (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, remaning DOUBLE, rate INTEGER)", nil, nil, nil ) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        readValues()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ArticuloTableViewCell
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(myVC, animated: true)
        
    }


}
