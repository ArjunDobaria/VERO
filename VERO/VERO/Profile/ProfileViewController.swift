//
//  ProfileViewController.swift
//  VERO
//
//  Created by lanet on 07/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userProfilePIcImg: UIImageView!
    @IBOutlet weak var userProfilePicBtn: UIButton!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var userEmailTxt: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var pickedImage : UIImage = UIImage()
    var data : NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.hideKeyboardWhenTappedAround()
        getUserProfile()
        
    }

    @IBAction func choosePicBtn(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- Img Picker Dekegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        userProfilePIcImg.contentMode = .scaleAspectFit
        userProfilePIcImg.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        //Service Call Update details
        if(userEmailTxt.text!.isValidEmail == true && userNameTxt.text!.isEmpty == false){
            UpdateProfile()
        }
        else{
            AppDelegate().sharedDelegate().myWarnningAlert("Enter your name and valid email please..!!")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Service Call for Profile
    func UpdateProfile() {
        let number =  "91"+(UserDefaults.standard.object(forKey: "userId") as! String)
        let params : [String : Any] = ["userId" : number,
                                       "displayName" : userNameTxt.text!,
                                       "email" : userEmailTxt.text!
        ]
        if let image = self.userProfilePIcImg.image {
            Service_Call.sharedInstance.serviceUploadImgWithDataPost(image, url: WebApi.API_PROFILE,param: params,userId : number, successBlock:
                {(response) in
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(true, forKey: "isProfileSet")
                        UserDefaults.standard.synchronize()
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                        vc.userData = self.data
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
            }, failureBlock:
                {(error) in
                    UserDefaults.standard.set(false, forKey: "isProfileSet")
                    UserDefaults.standard.synchronize()
                    AppDelegate().sharedDelegate().myWarnningAlert(error)
            })
        }
        else
        {
            let params : [String : Any] = ["userId" : number,
                                           "displayName" : userNameTxt.text!,
                                           "email" : userEmailTxt.text!
            ]
            Service_Call.sharedInstance.servicePost(WebApi.API_PROFILE, param: params, successBlock:
                {(response) in
                    print(response)
            }, failureBlock:
                {(error) in
                    AppDelegate().sharedDelegate().myWarnningAlert(error)
            })
        }
    }
    
    func getUserProfile(){
        let param :[String : Any] = ["userId" : "91"+(UserDefaults.standard.object(forKey: "userId") as! String)]
        Service_Call.sharedInstance.servicePost(WebApi.API_USER_PROFILE, param: param, successBlock:
            {(response) in
                
                DispatchQueue.main.async {
                
                    AppDelegate().sharedDelegate().userData = ((response as! NSDictionary)["message"] as! NSArray)[0] as! NSDictionary
//                    UserDefaults.standard.set(AppDelegate().sharedDelegate().userData, forKey: "UserProfile")
                    
                    print("User Data from Appdelegate : \(AppDelegate().sharedDelegate().userData)")
                    print("User Data from User Defaults : \(UserDefaults.standard.object(forKey: "UserProfile") ?? "No value is defind in UserDefaults")")
                    
                    if(AppDelegate().sharedDelegate().userData != [:])
                    {
                        self.data = AppDelegate().sharedDelegate().userData
                        
                        self.userNameTxt.text = AppDelegate().sharedDelegate().userData["displayName"] as? String
                        self.userEmailTxt.text = AppDelegate().sharedDelegate().userData["email"] as? String
                        self.userProfilePIcImg.contentMode = .scaleAspectFit
                        
                        let imgCache = SDImageCache.shared().imageFromDiskCache(forKey: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().userData["userProfilePhoto"] as! String)")
                        if(imgCache != nil){
                            self.userProfilePIcImg.image = imgCache
                        }else{
                            self.userProfilePIcImg.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().userData["userProfilePhoto"] as! String)"), completed: { (postimg, err, img, url) in
                                if postimg != nil
                                {
                                    SDImageCache.shared().store(postimg, forKey: "\(url!)", toDisk: true, completion: nil)
                                }
                            })
                        }
                        
                        self.userProfilePIcImg.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().userData["userProfilePhoto"] as! String)"), placeholderImage: #imageLiteral(resourceName: "userPic"))
                    }
                    
                }
        }, failureBlock:
            {(error) in
                AppDelegate().sharedDelegate().myWarnningAlert(error)
        })
    }

}
