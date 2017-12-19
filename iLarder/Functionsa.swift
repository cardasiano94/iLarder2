//
//  ViewController.swift
//  SwiftExample
//
//  Created by Belal Khan on 18/11/17.
//  Copyright © 2017 Belal Khan. All rights reserved.
//

import UIKit
import SQLite3

class Functionsa: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var db: OpaquePointer?
    var productList = [Product]()
    
    
    @IBOutlet weak var tableViewProducts: UITableView!
    //@IBOutlet weak var textFieldName: UITextField!
    //@IBOutlet weak var textFieldRemaning: UITextField!
    
    //_ sender: UIButton
    
    func buttonSave(inputs: [String]) {
        let name = inputs[0]
        let remaning = inputs[1]
        let rate = inputs[2]

        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ProductDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        var stmt: OpaquePointer?
        
        let queryString = "INSERT INTO Product (name, remaning, rate) VALUES (?,?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 2, (remaning as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 3, (rate as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting product: \(errmsg)")
            return
        }
        
        //inputedName.text=""
        //textFieldRemaning.text=""
        
        //readValues()

        print("Product saved successfully")
    }
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let product: Product
        product = productList[indexPath.row]
        cell.textLabel?.text = product.name
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
    }
    
    
    
    
    func deleteprod(id: Int) {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ProductDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        var stmt: OpaquePointer?
        
        let queryString = "DELETE FROM Product WHERE id = " + String(id)
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting product: \(errmsg)")
            return
        }
        
        
    }
    
    func updateProduct(product: Product) {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ProductDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        var stmt: OpaquePointer?
        
        let name = product.name
        let rate = String(format:"%.1f", product.rate)
        let remaining = String(format:"%d", product.remaning)
        let id = String(format:"%d", product.id)
        
        
        let queryString = "UPDATE Product SET name = (?), rate = (?), remaning = (?) WHERE id = (?) "

        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: \(errmsg)")
            return
        }
        if sqlite3_bind_int(stmt, 4, (id as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 2, (rate as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_int(stmt, 3, (remaining as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }

        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure updating product: \(errmsg)")
            return
        }
        
        //inputedName.text=""
        //textFieldRemaning.text=""
        
        //readValues()
        
        print("Product updated successfully")
    }
    func historyinsert(product_old: Product, product_new: Product) {

        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ProductDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        var stmt: OpaquePointer?
    
        let rate = String(format:"%.1f", product_old.rate)
        let remaining_old = String(format:"%d", product_old.remaning)
        let remaining_new = String(format:"%d", product_new.remaning)
        
        let queryString = "INSERT INTO history (remaning, rate, new_remaning) VALUES (?,?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: \(errmsg)")
            return
        }
        if sqlite3_bind_int(stmt, 1, (remaining_old as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_double(stmt, 2, (rate as NSString).doubleValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        if sqlite3_bind_int(stmt, 3, (remaining_new as NSString).intValue) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure updating product: \(errmsg)")
            return
        }
        
        print("Product updated successfully")
    }
    
}

