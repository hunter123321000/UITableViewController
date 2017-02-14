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
        SwiftSpinner.show("Fetching Data...")
        
        
        
        
        lb_title.attributedText = convertSubStringColor(input: txt_title)
        lb_detail.text = txt_detail
        // Do any additional setup after loading the view, typically from a nib.
         print("str_imgUrl=\(str_imgUrl) \n lb_title=\(lb_title.attributedText) \n lb_detail=\(lb_detail)")

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
                        SwiftSpinner.hide()
                    })
                    
                }
        }
        
        
    
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func convertSubStringColor(input:String) -> NSMutableAttributedString {
        let color : [UIColor] = [.green, .blue, .red, .orange]
        let str = NSMutableAttributedString(string: input)
        
        for i in 0..<input.characters.count {
            let range =  NSMakeRange(i, 1)
            let newColor = color[i % color.count]
            
            str.addAttribute(NSForegroundColorAttributeName, value: newColor, range: range)
        }
        return str
    }
    
}

