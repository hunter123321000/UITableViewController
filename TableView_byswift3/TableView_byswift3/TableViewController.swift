//
//  TableViewController.swift
//  TableView_byswift3
//
//  Created by hunterchen on 2017/1/19.
//  Copyright © 2017年 hunterchen. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let identifier = "cell"
    var i_selectedRow:Int = 0,i_rows=15
    var refreshcontroller:UIRefreshControl = UIRefreshControl()
    let lb_hint:UILabel=UILabel(frame: CGRect(x:100, y:0, width:200, height:50))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshcontroller.addTarget(self, action: #selector(TableViewController.refreshAction), for: .valueChanged)
        
        self.tableView.addSubview(refreshcontroller)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func refreshAction(){
        i_rows = i_rows + 10
        self.tableView.reloadData()
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
        return i_rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "This is Row at \(indexPath.row+1)"
        cell.detailTextLabel?.text = "This is RowDetail at \(indexPath.row+1)"
        refreshcontroller.endRefreshing()
        lb_hint.removeFromSuperview()
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        i_selectedRow = indexPath.row
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        debugPrint("cell.tag=\(currentCell.tag)")
        self.performSegue(withIdentifier: "changeScreen", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !(indexPath.row + 1 < self.i_rows) {
            // hint for load more
            lb_hint.text = "Load More..."
            lb_hint.textAlignment = .center
            cell.addSubview(lb_hint)
            
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            i_rows = i_rows + 10
            self.tableView.reloadData()
            cell.willRemoveSubview(lb_hint)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        if segue.identifier == "changeScreen" {
            let vc = segue.destination as! ViewController
            vc.txt_title = "This is Row at \(i_selectedRow+1)"
            vc.txt_detail = "This is Detail at Row \(i_selectedRow+1)"
        }
    }
}
