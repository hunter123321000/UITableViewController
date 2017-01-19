//
//  ViewController.swift
//  TableView_byswift3
//
//  Created by hunterchen on 2017/1/19.
//  Copyright © 2017年 hunterchen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lb_title: UILabel!
    var txt_title = "", txt_detail=""
    @IBOutlet weak var lb_detail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lb_title.text = txt_title
        lb_detail.text = txt_detail
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

