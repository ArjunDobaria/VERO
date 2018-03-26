//
//  SearchViewController.swift
//  VERO
//
//  Created by lanet on 07/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var searchData : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.tblView.delegate = self
        self.tblView.dataSource = self
//        tblView.register(UINib(nibName: "StatusCellTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusCellTableViewCell")
//        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Find Friends"
    }
    
    //MARK:- Tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell()
        let data = searchData[indexPath.row] as! NSDictionary
        cell.textLabel?.text = data["displayName"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //When user click on the particuler person name then redirect user to that profile.
        self.searchBar.resignFirstResponder()
        let currentCell = tblView.cellForRow(at: indexPath)
        let data = searchData[indexPath.row] as! NSDictionary
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
        vc.username = (currentCell?.textLabel?.text)!
        vc.usermnumber = (data["userId"] as? String)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //service call for searching
        let param : [String : Any] = ["search" : searchText]
        if(searchText.description.count > 0)
        {
            Service_Call.sharedInstance.servicePost(WebApi.API_SEARCH, param: param, successBlock:
                {(response) in
                    self.searchData = []
                    self.searchData = ((response as! NSDictionary)["message"] as! NSArray)
                    DispatchQueue.main.async {
                        self.tblView.reloadData()
                    }
            }, failureBlock:
                {(error) in
                    AppDelegate().sharedDelegate().myWarnningAlert(error)
            })
        }
        else{
            self.searchData = []
            self.tblView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
