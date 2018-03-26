//
//  SettingViewController.swift
//  VERO
//
//  Created by lanet on 07/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import SDWebImage

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var statusContainerView: UIView!
    
    @IBOutlet weak var imgContainerView: UIView!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var profileBlurBackImg: UIImageView!
    
    @IBOutlet var userProfilePicker: UIButton!
    @IBOutlet var userDisplayName: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var userEmailTxt: UITextField!
    @IBOutlet weak var userMobileNumberTxt: UITextField!
    
    @IBOutlet weak var statustxt: UITextField!
    @IBOutlet weak var shortProfileContainerView: UIView!
    
    @IBOutlet var tblView: UITableView!
    
    let rightButton = UIButton(type: .system)
    let rightButton1 = UIButton(type: .system)
    var data : NSDictionary = NSDictionary()
    var statusArray : [String] = ["Available","Busy","Only Vero","At meeting","Not available"]
    var imagePicker = UIImagePickerController()
    var pickedImage : UIImage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.hideKeyboardWhenTappedAround()
        
        tblView.register(UINib(nibName: "StatusCellTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusCellTableViewCell")
        tblView.delegate = self
        tblView.dataSource = self
        
        print(UserDefaults.standard.object(forKey: "UserProfile") ?? "Value is not available in User-Defaluts")
        
        //User Profile
        getUserProfile()
        
        self.navigationItem.title = "My Profile"
        
        rightButton.isSelected = false
        rightButton.setTitle("Edit", for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        rightButton1.isSelected = false
        rightButton1.setTitle("OK", for: .normal)
        rightButton1.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        rightButton1.addTarget(self, action: #selector(editProfile1), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = profileBlurBackImg.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        profileBlurBackImg.addSubview(blurEffectView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    
    
    @objc func editProfile(){
        rightButton.isSelected = true
        rightButton1.isSelected = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton1)
        shortProfileContainerView.isUserInteractionEnabled = true
        statustxt.isUserInteractionEnabled = true
        
    }
    
    @objc func editProfile1(){
        
        //Service call for update profile
        self.userDisplayName.resignFirstResponder()
        self.statustxt.resignFirstResponder()
        
        let number =  "91"+(UserDefaults.standard.object(forKey: "userId") as! String)
        let params : [String : Any] = ["userId" : number,
                                       "displayName" : userDisplayName.text!,
                                       "srtatus" : statustxt.text!,
                                       
        ]
        if let image = self.userProfilePic.image {
            Service_Call.sharedInstance.serviceUploadImgWithDataPost(image, url: WebApi.API_PROFILE,param: params,userId : number, successBlock:
                {(response) in
                    print(response)
                    DispatchQueue.main.async {
                        AppDelegate().sharedDelegate().myAlert("Profile update successfully.")
                    }
            }, failureBlock:
                {(error) in
                    AppDelegate().sharedDelegate().myWarnningAlert(error)
            })
        }
        
        rightButton.isSelected = false
        rightButton1.isSelected = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        shortProfileContainerView.isUserInteractionEnabled = false
        statustxt.isUserInteractionEnabled = false
    }
    
    //MARK:- Img Picker Dekegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        userProfilePic.contentMode = .scaleAspectFit
        userProfilePic.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    //MARK:- Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "StatusCellTableViewCell", for: indexPath) as! StatusCellTableViewCell
        cell.lblStatus.text = statusArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(statustxt.isUserInteractionEnabled)
        {
            self.statustxt.text = statusArray[indexPath.row]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func imgPicker(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- Get User Profile 
    func getUserProfile(){
        if(AppDelegate().sharedDelegate().userData != [:])
        {
            let mnumber = AppDelegate().sharedDelegate().userData["userId"] as! String
            self.data = AppDelegate().sharedDelegate().userData
            
            self.userDisplayName.text = AppDelegate().sharedDelegate().userData["displayName"] as? String
            self.usernameTxt.text = AppDelegate().sharedDelegate().userData["userName"] as? String
            self.userEmailTxt.text = AppDelegate().sharedDelegate().userData["email"] as? String
            self.statustxt.text = AppDelegate().sharedDelegate().userData["status"] as? String
            self.userMobileNumberTxt.text = "+" + mnumber[...mnumber.index(mnumber.startIndex, offsetBy: 1)] + " " + mnumber[mnumber.index(mnumber.startIndex, offsetBy: 2)...]
            self.userProfilePic.contentMode = .scaleAspectFit
            self.profileBlurBackImg.contentMode = .scaleAspectFit
            let imgCache = SDImageCache.shared().imageFromDiskCache(forKey: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().userData["userProfilePhoto"] as! String)")
            if(imgCache != nil){
                self.userProfilePic.image = imgCache
                self.profileBlurBackImg.image = imgCache
            }else{
                self.userProfilePic.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().userData["userProfilePhoto"] as! String)"), completed: { (postimg, err, img, url) in
                    if postimg != nil
                    {
                        SDImageCache.shared().store(postimg, forKey: "\(url!)", toDisk: true, completion: nil)
                    }
                })
            }
            
//            self.userProfilePic.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().userData["userProfilePhoto"] as! String)"), placeholderImage: #imageLiteral(resourceName: "userPic"))
        }
    }
}
