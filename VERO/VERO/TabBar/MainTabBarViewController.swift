//
//  MainTabBarViewController.swift
//  VERO
//
//  Created by lanet on 07/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    var userData : NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        getUserProfile()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUserProfile(){
        let param :[String : Any] = ["userId" : "91"+(UserDefaults.standard.object(forKey: "userId") as! String)]
        Service_Call.sharedInstance.servicePost(WebApi.API_USER_PROFILE, param: param, successBlock:
            {(response) in
                
                DispatchQueue.main.async {
                    AppDelegate().sharedDelegate().userData = ((response as! NSDictionary)["message"] as! NSArray)[0] as! NSDictionary
                }
        }, failureBlock:
            {(error) in
                AppDelegate().sharedDelegate().myWarnningAlert(error)
        })
    }
}
