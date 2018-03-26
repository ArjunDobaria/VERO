//
//  NotificationViewController.swift
//  VERO
//
//  Created by lanet on 07/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        self.title = "Notification"
//        self.hideKeyboardWhenTappedAround()
    }
    
    //MARK:- Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell()
        cell.textLabel?.text = "Notification"
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
