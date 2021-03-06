//
//  ViewController.swift
//  iLarder
//
//  Created by Cristobal Galleguillos on 06-12-17.
//  Copyright © 2017 URSis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentProduct : Product?
    var prodId : Int = 0
    
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var weekRate: UITextField!
    @IBOutlet weak var remainingUnits: UITextField!
    
    override func viewDidLoad() {
        productName.text = currentProduct?.name
        weekRate.text = String(format:"%.1f", (currentProduct?.rate)!)
        remainingUnits.text = String(format:"%d", (currentProduct?.remaning)!)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateSegue" {
            var oldprod = Product(id: (currentProduct?.id)!, name: currentProduct?.name, rate: (currentProduct?.rate)!, remaning: (currentProduct?.remaning)!)
            
            currentProduct?.name = productName.text
            currentProduct?.rate = Double(weekRate.text!)!
            currentProduct?.remaning = Int(remainingUnits.text!)!
            // Pass the selected object to the new view controller.
            Functionsa().historyinsert(product_old: oldprod, product_new: currentProduct!)
            Functionsa().updateProduct(product: currentProduct!)
            ArticleTableViewController().readValues()
            var nextScene =  segue.destination as! ArticleTableViewController
            nextScene.navigationItem.hidesBackButton = true
        }
        if segue.identifier == "historialSegue" {
            prodId = (currentProduct?.id)!
            print(prodId)
            // Pass the selected object to the new view controller.
            Functionsa().updateProduct(product: currentProduct!)
            //ArticleTableViewController().readValues()
            var nextScene =  segue.destination as! HistorialTableViewController
            nextScene.currentId = prodId
        }
    }


}

