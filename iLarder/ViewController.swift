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


}

