//
//  AddFriendViewController.swift
//  VERO
//
//  Created by Lcom32 on 3/13/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import SDWebImage

class AddFriendViewController: UIViewController {

    
    @IBOutlet weak var imgContainerView: UIView!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var profileBlurBackImg: UIImageView!
    
    @IBOutlet var userDisplayName: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var userEmailTxt: UITextField!
    @IBOutlet weak var userMobileNumberTxt: UITextField!
    
    @IBOutlet weak var statustxt: UILabel!
    @IBOutlet weak var shortProfileContainerView: UIView!
    
    @IBOutlet var addFriendBtn: UIButton!
    var usermnumber = ""
    var username = ""
    var data : NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(usermnumber)
        print(username)
        self.title = username
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = profileBlurBackImg.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        profileBlurBackImg.addSubview(blurEffectView)
        
        let leftBarButton = UIButton(type: .system)
        leftBarButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        leftBarButton.setTitle("Back", for: .normal)
        leftBarButton.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        getUserProfile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.view.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addFriendBtn(_ sender: Any) {
        //Add friend api call
    }
    
    @objc func backBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Add Friend API call
    func addFriend()
    {
//        let param : [String : Any] = ["userId" : "91"+UserDefaults.standard.object(forKey: "userId") as! String]
    }
    
    //MARK:- Get User Profile
    func getUserProfile(){
        
        let param :[String : Any] = ["userId" : usermnumber]
        Service_Call.sharedInstance.servicePost(WebApi.API_USER_PROFILE, param: param, successBlock:
            {(response) in
                
                DispatchQueue.main.async {
                    AppDelegate().sharedDelegate().otherData = ((response as! NSDictionary)["message"] as! NSArray)[0] as! NSDictionary
                    if(AppDelegate().sharedDelegate().otherData != [:])
                    {
                        let mnumber = AppDelegate().sharedDelegate().otherData["userId"] as! String
                        self.data = AppDelegate().sharedDelegate().otherData
                        
                        self.userDisplayName.text = AppDelegate().sharedDelegate().otherData["displayName"] as? String
                        self.usernameTxt.text = AppDelegate().sharedDelegate().otherData["userName"] as? String
                        self.userEmailTxt.text = AppDelegate().sharedDelegate().otherData["email"] as? String
                        self.statustxt.text = AppDelegate().sharedDelegate().otherData["status"] as? String
                        self.userMobileNumberTxt.text = "+" + mnumber[...mnumber.index(mnumber.startIndex, offsetBy: 1)] + " " + mnumber[mnumber.index(mnumber.startIndex, offsetBy: 2)...]
                        self.userProfilePic.contentMode = .scaleAspectFit
                        self.profileBlurBackImg.contentMode = .scaleAspectFit
                        let imgCache = SDImageCache.shared().imageFromDiskCache(forKey: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().otherData["userProfilePhoto"] as! String)")
                        if(imgCache != nil){
                            self.userProfilePic.image = imgCache
                            self.profileBlurBackImg.image = imgCache
                        }else{
                            self.userProfilePic.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().otherData["userProfilePhoto"] as! String)"), completed: { (postimg, err, img, url) in
                                if postimg != nil
                                {
                                    SDImageCache.shared().store(postimg, forKey: "\(url!)", toDisk: true, completion: nil)
                                }
                            })
                        }
                        
                        self.userProfilePic.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().otherData["userProfilePhoto"] as! String)"), placeholderImage: #imageLiteral(resourceName: "userPic"))
                    }
                }
        }, failureBlock:
            {(error) in
                AppDelegate().sharedDelegate().myWarnningAlert(error)
        })
    }
    
}
