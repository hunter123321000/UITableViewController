//
//  TableViewController.swift
//  TableView_byswift3
//
//  Created by hunterchen on 2017/1/19.
//  Copyright © 2017年 hunterchen. All rights reserved.
//

import UIKit
import Alamofire

class TableViewCell:UITableViewCell{
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_detail: UILabel!
    @IBOutlet weak var img_icon: UIImageView!
}
class TableViewController: UITableViewController {

    let identifier = "cell"
    var i_selectedRow:Int = 0,i_rows=15
    var refreshcontroller:UIRefreshControl = UIRefreshControl()
    let lb_hint:UILabel=UILabel(frame: CGRect(x:100, y:0, width:200, height:50))
    let str_jsonurl="http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=a3e2b221-75e0-45c1-8f97-75acbd43d613"
    var dataArray:[AnyObject] = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshcontroller.addTarget(self, action: #selector(TableViewController.refreshAction), for: .valueChanged)
        
        self.tableView.addSubview(refreshcontroller)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        Alamofire.request(str_jsonurl)
            .downloadProgress { progress in
                print("Download Progress: \(progress.fractionCompleted)")
                SwiftSpinner.show("Fetching data...")
            }
            .responseJSON { response in
//            debugPrint("response=\(response)")
            if let json:[String: AnyObject] = response.result.value as! [String : AnyObject]? {
//                print("JSON: \(json)")
                self.dataArray = json["result"]!["results"] as! [AnyObject]!
                self.tableView.reloadData()
                SwiftSpinner.hide()
            }
        }
        
        self.setEditing(true, animated: false)
        self.editButtonAction()
        
    }
    func refreshAction(){
        
        i_rows = i_rows + 10
        self.tableView.reloadData()
    }
    
    func editButtonAction (){
        self.setEditing(
            !self.isEditing, animated: true)
        if (!self.isEditing) {
            // 顯示編輯按鈕
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .edit,
                                target: self,
                                action:
                    #selector(self.editButtonAction))
        } else {
            // 顯示編輯完成按鈕
            self.navigationItem.leftBarButtonItem =
                UIBarButtonItem(barButtonSystemItem: .done,
                                target: self,
                                action:
                    #selector(self.editButtonAction))
            
            // 隱藏新增按鈕
            self.navigationItem.rightBarButtonItem = nil
        }
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
//        return i_rows
        return dataArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TableViewCell
//        cell.textLabel?.text = "This is Row at \(indexPath.row+1)"
//        cell.detailTextLabel?.text = "This is RowDetail at \(indexPath.row+1)"
        
//        cell.lb_title.text = "This is Row at \(indexPath.row+1)"
//        cell.lb_detail.text = "This is RowDetail at \(indexPath.row+1)"
//        refreshcontroller.endRefreshing()
//        lb_hint.removeFromSuperview()
        
        cell.lb_title.text = dataArray[indexPath.row]["A_Name_Ch"] as? String
        cell.lb_detail.text = dataArray[indexPath.row]["A_Location"] as? String
        let str_imgUrl = dataArray[indexPath.row]["A_Pic01_URL"] as? String
        Alamofire.request(str_imgUrl!)
            .responseImage { response in
                if let image = response.result.value {
                    DispatchQueue.main.async(execute: {
                        cell.img_icon.image=image
                        
                    })

                }
        }
        refreshcontroller.endRefreshing()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        i_selectedRow = indexPath.row
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        debugPrint("+++++cell.tag=\(currentCell.tag)   i_selectedRow=\(i_selectedRow)")
        //self.performSegue(withIdentifier: "changeScreen", sender: nil)
        self.performSegue(withIdentifier: "gotoTabBar", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        if let myCell = cell as? TableViewCell
//        {
//            if !(indexPath.row + 1 < self.i_rows) {
//                // hint for load more
//                lb_hint.text = "Load More..."
//                lb_hint.textAlignment = .center
//                myCell.addSubview(lb_hint)
//                if myCell.isDescendant(of: lb_hint){
//                    debugPrint("exist")
//                }else{
//                    debugPrint("Don't exist")
//                }
//                //            cell.textLabel?.text = ""
//                //            cell.detailTextLabel?.text = ""
//                myCell.lb_title?.text = ""
//                myCell.lb_detail?.text = ""
//                i_rows = i_rows + 10
//                self.tableView.reloadData()
//            }
//        }
//        
//    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
        if segue.identifier == "changeScreen" {
            let vc = segue.destination as! ViewController
    
            vc.txt_title = "This is Row at \(i_selectedRow+1)"
            vc.txt_detail = "This is Detail at Row \(i_selectedRow+1)"
            
            vc.txt_title = dataArray[i_selectedRow]["A_Name_Ch"] as! String
            vc.txt_detail = dataArray[i_selectedRow]["A_Location"] as! String
            vc.str_imgUrl = dataArray[i_selectedRow]["A_Pic01_URL"] as! String

        }
       */
        
         debugPrint("~~~~~ i_selectedRow=\(i_selectedRow)")
        if(segue.identifier == "gotoTabBar"){
        
            let tabvc = segue.destination as! TabBarViewController
            let vc = tabvc.viewControllers!.first as! detailController
            let vc2 = tabvc.viewControllers?.last as! changeDisplayView
        
            vc.txt_title = dataArray[i_selectedRow]["A_Name_Ch"] as! String
            vc.txt_detail = dataArray[i_selectedRow]["A_Location"] as! String
            vc.str_imgUrl = dataArray[i_selectedRow]["A_Pic01_URL"] as! String
            
            for i in dataArray{
                vc2.str_imgUrl.append(i["A_Pic01_URL"] as! String)
            }
            
        }
    }
 
}
