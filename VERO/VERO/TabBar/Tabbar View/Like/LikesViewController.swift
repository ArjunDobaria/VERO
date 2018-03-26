//
//  LikesViewController.swift
//  VERO
//
//  Created by Lcom32 on 3/12/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import SDWebImage

class LikesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblView: UITableView!
    
    var postId : Int = Int()
    var postData : NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(postId)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.title = "Likes"
        
        let leftBarButton = UIButton(type: .system)
        leftBarButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        leftBarButton.setTitle("Cancle", for: .normal)
        leftBarButton.addTarget(self, action: #selector(cancleBtn), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButton)
        
        tblView.register(UINib(nibName: "LikesCellTableViewCell", bundle: nil), forCellReuseIdentifier: "LikesCellTableViewCell")
        
        getLikes()
    }
    
    //MARK:- Table view delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "LikesCellTableViewCell", for: indexPath) as! LikesCellTableViewCell
        let data = postData[indexPath.row] as! NSDictionary
        
        cell.userProfilePic.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(data["userProfilePhoto"] as! String)"), placeholderImage: #imageLiteral(resourceName: "userPic"), options: SDWebImageOptions.progressiveDownload, completed: { (img, err, cache, url) in})
        cell.displayName.text = data["displayName"] as? String
        cell.numberOfLikes.text = "Do " + String(describing: data["count(likes.likeId)"]!) + " Likes to your post."
        
        return cell
    }
    
    @objc func cancleBtn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Sercvice call
    func getLikes()
    {
        Service_Call.sharedInstance.serviceGet(WebApi.API_USER_LIKES+"\(postId)", successBlock:
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
