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
        
        cell.addArticle.tag = indexPath.row
        cell.addArticle.addTarget(self, action: #selector(ArticleTableViewController.buttonClicked), for: .touchUpInside)
        
        return cell
    }
    
    func buttonClicked(sender: Any){
        
        var articleNumber: Int
        articleNumber = (sender as AnyObject).tag
        let newprod = productList[articleNumber]
        

        
        let alert = UIAlertController(
            title: "Modificar cantidad de articulos",
            message: "Ingresar la nueva cantidad del articulo",
            preferredStyle: UIAlertControllerStyle.alert)

        alert.addTextField{(textField: UITextField) in
            textField.text = String(self.productList[articleNumber].remaning)
            
        }
        
        let addAction = UIAlertAction(
        title: "Modificar", style: UIAlertActionStyle.default){
            (action) -> Void in
            self.inputsa.append(alert.textFields![0].text!)
            var oldprod = Product(id: newprod.id, name: newprod.name, rate: newprod.rate, remaning: newprod.remaning)
            
            
            newprod.remaning = Int(alert.textFields![0].text!)!
            Functionsa().historyinsert(product_old: oldprod, product_new: newprod)
            Functionsa().updateProduct(product: newprod)
            self.readValues()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
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
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Product (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, rate DOUBLE, remaning INTEGER)", nil, nil, nil ) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS history (id INTEGER PRIMARY KEY AUTOINCREMENT, date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, prod_id INTEGER, rate DOUBLE, remaning INTEGER, new_remaning INTEGER)", nil, nil, nil) != SQLITE_OK {
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productSegue" {
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                var nextScene =  segue.destination as! ViewController
                var newProduct = productList[indexPath.row]
                nextScene.currentProduct = newProduct
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let newprod = productList[indexPath.row]
            Functionsa().deleteprod(id: newprod.id)
            readValues()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }



}
