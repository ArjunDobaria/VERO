//
//  CreatePostViewController.swift
//  VERO
//
//  Created by lanet on 09/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import SDWebImage

class CreatePostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var placeholderLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var imgPickerBtn: UIButton!
    @IBOutlet weak var removeImgBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var pickedImage : UIImage = UIImage()
    var privacy : Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfilePic()
        self.hideKeyboardWhenTappedAround()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let leftBarButton = UIButton(type: .system)
        leftBarButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        leftBarButton.setTitle("Cancle", for: .normal)
        leftBarButton.addTarget(self, action: #selector(cancleBtn), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        self.title = "Create Post"
        
        let rightBarButton = UIButton(type: .system)
        rightBarButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        rightBarButton.setTitle("Post", for: .normal)
        rightBarButton.addTarget(self, action: #selector(postBtn), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
        
        textView.delegate = self
        
        imagePicker.delegate = self
    }
    
    //MARK:- Text View Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("data")
        placeholderLbl.isHidden = true
    }
    
    //MARK:- ImagePicker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageUpload.contentMode = .scaleAspectFit
        imageUpload.image = pickedImage
        imgPickerBtn.setTitle("", for: .normal)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Button Actions
    @IBAction func privacyBtn(_ sender: Any) {
        if privacyBtn.isSelected {
            privacyBtn.isSelected = false
            //public
            privacy = 1
        }
        else{
            privacyBtn.isSelected = true
            //private
            privacy = 0
        }
    }
    
    @IBAction func removeImgBtn(_ sender: Any) {
        imageUpload.image = nil
        imgPickerBtn.setTitle("Upload Image", for: .normal)
    }
    @IBAction func imgPIckerBtn(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func cancleBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func postBtn() {
        //Service call for create Posts
        let number = "91"+(UserDefaults.standard.object(forKey: "userId") as! String)
        
        if let image = self.imageUpload.image {
            //MAEK:- Create thumbnail
//            let imageData = UIImagePNGRepresentation(image)!
//            let options = [
//                kCGImageSourceCreateThumbnailWithTransform: true,
//                kCGImageSourceCreateThumbnailFromImageAlways: true,
//                kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary
//            let source = CGImageSourceCreateWithData(imageData as CFData, nil)!
//            let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
//            let thumbnail = UIImage(cgImage: imageReference)
        
            var param : [String : Any] = [String : Any]()
            
            if(textView.text.isEmpty)
            {
                param = ["userId" : number,
                                              "postType" : "image",
                                              "postText" : "",
                                              "privacy" : privacy]
            }
            else{
                param = ["userId" : number,
                                              "postType" : "text/img",
                                              "postText" : textView.text!,
                                              "privacy" : privacy]
            }
            
            Service_Call.sharedInstance.serviceUploadImgWithDataPost(image, url: WebApi.API_CREATE_POST, param: param, userId: number, successBlock:
                {(response) in
                    print(response)
                    AppDelegate().sharedDelegate().myAlert("Your post is uploded.")
//                    self.navigationController?.popViewController(animated: true)
            }, failureBlock:
                {(error) in
                    AppDelegate().sharedDelegate().myWarnningAlert(error)
            })
        }
        else
        {
            let param : [String : Any] = ["userId" : number,
                                          "postType" : "text",
                                          "postText" : textView.text!,
                                          "privacy" : privacy]
            Service_Call.sharedInstance.servicePost(WebApi.API_CREATE_POST, param: param, successBlock:
                {(response) in
                    AppDelegate().sharedDelegate().myAlert("Your post is uploded.")
                    print(response)
//                    self.navigationController?.popViewController(animated: true)
            }, failureBlock:
                {(error) in
                    AppDelegate().sharedDelegate().myWarnningAlert(error)
            })
        }
    }
    
    func setProfilePic()
    {
        userProfileImg.contentMode = .scaleAspectFit
        let imgCache = SDImageCache.shared().imageFromDiskCache(forKey: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().userData["userProfilePhoto"] as! String)")
        if(imgCache != nil){
            self.userProfileImg.image = imgCache
        }else{
            self.userProfileImg.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(AppDelegate().sharedDelegate().userData["userProfilePhoto"] as! String)"), completed: { (postimg, err, img, url) in
                if postimg != nil
                {
                    SDImageCache.shared().store(postimg, forKey: "\(url!)", toDisk: true, completion: nil)
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
