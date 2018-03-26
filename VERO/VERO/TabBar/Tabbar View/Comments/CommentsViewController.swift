//
//  CommentsViewController.swift
//  VERO
//
//  Created by Lcom32 on 3/12/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import SDWebImage

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblView: UITableView!
    @IBOutlet var commentText: UITextField!
    @IBOutlet var submitCommentBtn: UIButton!
    
    var postId : Int = Int()
    var postData : NSArray = NSArray()
    var commentData : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.hideKeyboardWhenTappedAround()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "Comments"
        
        let leftBarButton = UIButton(type: .system)
        leftBarButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        leftBarButton.setTitle("Cancle", for: .normal)
        leftBarButton.addTarget(self, action: #selector(cancleBtn), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        tblView.register(UINib(nibName: "LikesCellTableViewCell", bundle: nil), forCellReuseIdentifier: "LikesCellTableViewCell")
        getComments()
    }
    
    //MARK:- Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "LikesCellTableViewCell", for: indexPath) as! LikesCellTableViewCell
        let data = postData[indexPath.row] as! NSDictionary
        
        cell.userProfilePic.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(data["userProfilePhoto"] as! String)"), placeholderImage: #imageLiteral(resourceName: "userPic"), options: SDWebImageOptions.progressiveDownload, completed: { (img, err, cache, url) in})
        cell.displayName.text = data["displayName"] as? String
        cell.numberOfLikes.text = data["commentText"] as? String
        
        return cell
    }
    
    @objc func cancleBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitCommentBtn(_ sender: Any) {
        /*
         comment text,userId,postId
         */
        self.commentText.resignFirstResponder()
        if(!(commentText.text?.isEmpty)!)
        {
            
            
            let number : String = "91"+(UserDefaults.standard.object(forKey: "userId") as! String)
            let param : [String : Any] = ["userId" : number,
                                          "postId" : postId,
                                          "commentText" : commentText.text!
            ]
            
            Service_Call.sharedInstance.servicePost(WebApi.API_CREATE_COMMENTS, param: param, successBlock:
                {(response) in
                    print(response)
                    self.getComments()
            }, failureBlock:
                {(error) in
                    print(error)
            })
        }
        else
        {
            AppDelegate().sharedDelegate().myWarnningAlert("Please enter some comment text..!")
        }
        commentText.text = ""
        commentText.placeholder = "write your comment"
    }
    //MARK:- Sercvice call
    func getComments()
    {
        Service_Call.sharedInstance.serviceGet(WebApi.API_USER_COMMENTS+"\(postId)", successBlock:
            {(response) in
                self.postData = ((response as! NSDictionary)["message"] as! NSArray)
                print(self.postData)
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
        }, failureBlock:
            {(error) in
                print(error)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
