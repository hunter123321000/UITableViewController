//
//  ViewController.swift
//  TableView_byswift3
//
//  Created by hunterchen on 2017/1/19.
//  Copyright © 2017年 hunterchen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var lb_title: UILabel!
    var txt_title = "", txt_detail="",str_imgUrl=""
    @IBOutlet weak var lb_detail: UILabel!
    @IBOutlet weak var img_animal: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        lb_title.text = txt_title
        lb_detail.text = txt_detail
        // Do any additional setup after loading the view, typically from a nib.
         print("str_imgUrl=\(str_imgUrl)")

        Alamofire.request(str_imgUrl)
            .responseImage { response in
                debugPrint(response)
                debugPrint(response.result)
                if let image = response.result.value {
                    // Store the commit date in to our cache
//                    self.ImageCache[dishName!] = image
                    
                    // Update the cell
                    DispatchQueue.main.async(execute: {
                        self.img_animal.image = image
                    })
                    
                }
        }
        
        
    
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

