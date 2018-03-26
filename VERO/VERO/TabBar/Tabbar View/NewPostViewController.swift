//
//  NewPostViewController.swift
//  VERO
//
//  Created by lanet on 07/03/18.
//  Copyright © 2018 lanet. All rights reserved.

import UIKit
import SDWebImage	

class NewPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var postData : NSArray = NSArray()
    var LCData : NSArray = NSArray()
    let tblView : UITableView = UITableView()
    let tempArrayLikes : NSMutableArray = NSMutableArray()
    let tempArrayComments : NSMutableArray = NSMutableArray()
    let tempArrayPhoto : NSMutableArray = NSMutableArray()
    
    var imgData : Data = Data()
    var Url : URL!
    var tag : Int = Int()
    var like : Int?
    var activityIndecator : UIActivityIndicatorView = UIActivityIndicatorView()
    var likeBool : Bool = false
    var pullToRefresh : UIRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndecator.isHidden = false
        activityIndecator.startAnimating()
        
        activityIndecator.color = UIColor.black
        pullToRefresh.addTarget(self, action: #selector(ref), for: .valueChanged)
        tableViewLoad()
        
        self.tblView.addSubview(activityIndecator)
        self.tblView.addSubview(pullToRefresh)
        self.tblView.rowHeight = 510
        self.tblView.rowHeight = UITableViewAutomaticDimension
        
        self.tblView.tableFooterView = UIView()
        self.hideKeyboardWhenTappedAround() 
    }
    
    override func viewDidLayoutSubviews() {
        activityIndecator.center = CGPoint(x: tblView.frame.size.width / 2, y: tblView.frame.size.height / 2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ServiceCall(0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem()
        self.title = "New Feeds"
        let rightButton = UIButton(type: .system)
        rightButton.setImage(#imageLiteral(resourceName: "newFeeds"), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        rightButton.addTarget(self, action: #selector(rightBarButton), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    //MARK:- Custome Function
    @objc func ref(){
        ServiceCall(0)
    }
    
    func tableViewLoad()
    {
        tblView.delegate = self
        tblView.dataSource = self
        tblView.frame = CGRect(x: 0, y: (navigationController?.navigationBar.bounds.height)!, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (navigationController?.navigationBar.bounds.height)!)
        tblView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        self.view.addSubview(tblView)
    }
    
    //MARK:- Button Click Events
    @objc func rightBarButton(){
        //Render to create post page
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController") as! CreatePostViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func likesClick(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LikesViewController") as! LikesViewController
        vc.postId =  (postData[Int(sender.accessibilityHint!)!] as! NSDictionary)["postId"] as! Int
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func commentsClick(_ sender : UIButton){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        vc.postId = (postData[Int(sender.accessibilityHint!)!] as! NSDictionary)["postId"] as! Int
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createLike(_ sender : UIButton){
        print("Create Like")
        
        print((postData[Int(sender.accessibilityHint!)!] as! NSDictionary)["likes"] as! Int)
        like = (postData[Int(sender.accessibilityHint!)!] as! NSDictionary)["likes"] as! Int + 1
        self.tempArrayLikes[Int(sender.accessibilityHint!)!] = like!
        print(self.tempArrayLikes[Int(sender.accessibilityHint!)!])
        
        print(like!)
        let userId = "91"+(UserDefaults.standard.object(forKey: "userId") as! String)
        let param : [String : Any] = ["userId" : userId,
                                      "postId" : (postData[Int(sender.accessibilityHint!)!] as! NSDictionary)["postId"] as! Int
                                      ]
        Service_Call.sharedInstance.servicePost(WebApi.API_LIKES, param: param, successBlock:
            {(response) in
                print(response)
                self.likeBool = true
                self.ServiceCall(Int(sender.accessibilityHint!)!)
        }, failureBlock:
            {(error) in
                AppDelegate().sharedDelegate().myWarnningAlert(error)
        })
    }
    
    @objc func createComment(_ sender : UIButton){
        print("Create Comment")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        vc.postId = (postData[Int(sender.accessibilityHint!)!] as! NSDictionary)["postId"] as! Int
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        pullToRefresh.endRefreshing()
//        activityIndecator.stopAnimating()
        activityIndecator.isHidden = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.postImgActivityIndecator.isHidden = true
        let data = postData[indexPath.row] as! NSDictionary
        let postType : String = data["postType"] as! String
        self.tempArrayLikes.add(data["likes"] as! Int)


        cell.backgroundColor = UIColor.white
        if data["privacy"] as! Int == 0 {
            //Public Img
            cell.privacyBtn.setImage(#imageLiteral(resourceName: "public"), for: .normal)
        }
        else{
            //Private Img
            cell.privacyBtn.setImage(#imageLiteral(resourceName: "private"), for: .normal)
        }


        cell.tag = indexPath.row
        tag = cell.tag

        cell.numberOfLikes.setTitle(String(data["likes"] as! Int) + " Likes", for: .normal)
        cell.numberOfComments.setTitle(String(data["coments"] as! Int) + " Comments", for: .normal)

        cell.numberOfComments.addTarget(self, action: #selector(commentsClick(_:)), for: .touchUpInside)
        cell.numberOfLikes.addTarget(self, action: #selector(likesClick(_:)), for: .touchUpInside)

        cell.numberOfLikes.accessibilityHint = "\(indexPath.row)"
        cell.numberOfLikes.tag = indexPath.section
        cell.numberOfComments.accessibilityHint = "\(indexPath.row)"
        cell.numberOfComments.tag = indexPath.section

        cell.commentBtn.addTarget(self, action: #selector(createComment(_:)), for: .touchUpInside)
        cell.commentBtn.accessibilityHint = "\(indexPath.row)"
        cell.commentBtn.tag = indexPath.section

        cell.likeBtn.addTarget(self, action: #selector(createLike(_:)), for: .touchUpInside)
        cell.likeBtn.accessibilityHint = "\(indexPath.row)"
        cell.likeBtn.tag = indexPath.section
        cell.postImg.isHidden = true;
        cell.postTxt.isHidden = true;
        
        switch postType {
        case "text":
            cell.postTxt.isHidden = false
            cell.userNameTxt.text = data["displayName"] as? String
            cell.postTxt.text = data["postText"] as? String
            cell.secondViewHeight.constant = 50
            cell.secondView.layoutIfNeeded()
            cell.thirdViewHeight.constant = 0
            cell.thirdView.layoutIfNeeded()
            break
        case "image":
            cell.userNameTxt.text = data["displayName"] as? String
            cell.secondViewHeight.constant = 0
            cell.secondView.layoutIfNeeded()
            cell.thirdViewHeight.constant = 300
            cell.thirdView.layoutIfNeeded()
            cell.postImg.sd_setImage(with: URL(string: WebApi.POST_IMG+"\(data["postUrl"] as! String)"), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (img, err, cache, url) in

            })

            let manager = SDWebImageManager.shared()
            manager.loadImage(with: URL(string: WebApi.POST_IMG+"\(data["postUrl"] as! String)"), options: SDWebImageOptions.cacheMemoryOnly, progress: nil, completed: { (img, data, err, cach, bul, url) in
//                cell.postImg.image = img
            })
            cell.postImg.isHidden = false;
            break
        case "video":
            cell.userNameTxt.text = data["displayName"] as? String
            cell.postImg.backgroundColor = UIColor.black
            cell.postImg.isHidden = false;
            break
        case "gif":
            cell.userNameTxt.text = data["displayName"] as? String
            cell.postImg.backgroundColor = UIColor.blue
            cell.postImg.isHidden = false;
            break
        case "text/img":
            cell.postImg.isHidden = false;
            cell.postTxt.isHidden = false
            cell.userNameTxt.text = data["displayName"] as? String
            cell.postTxt.text = data["postText"] as? String
            cell.secondViewHeight.constant = 50
            cell.secondView.layoutIfNeeded()
            cell.thirdViewHeight.constant = 300
            cell.thirdView.layoutIfNeeded()
            cell.postImg.sd_setImage(with: URL(string: WebApi.POST_IMG+"\(data["postUrl"] as! String)"), placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (img, err, cache, url) in})
            break
        default:
            print("default")
        }
        
        cell.selectionStyle = .default
        cell.userProfilePicImg.contentMode = .scaleAspectFit
        cell.postImg.isUserInteractionEnabled = true

        cell.userProfilePicImg.sd_setImage(with: URL(string: WebApi.PROFILE_IMG+"\(data["userProfilePhoto"] as! String)"), placeholderImage: #imageLiteral(resourceName: "userPic"), options: SDWebImageOptions.progressiveDownload, completed: { (img, err, cache, url) in})

        //If there is any Image in post then zoom it and show the image to user on full view
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.postImg.addGestureRecognizer(tap)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Selected row : \(indexPath.row)")
    }
    
    //MARK:- Zoom Image
    //To zoom the image when user tap on image
    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    //MARK:- Serveice Call
    func ServiceCall(_ row : Int) {
        let number : String = "91"+(UserDefaults.standard.object(forKey: "userId") as! String)
        Service_Call.sharedInstance.serviceGet(WebApi.API_POST+"/\(number)", successBlock:
            {(response) in
                self.postData = ((response as! NSDictionary)["message"] as! NSArray)
                print(self.postData)
                
                DispatchQueue.main.async {
                    if self.likeBool
                    {
                        let indexPath = IndexPath(row: row, section: 0)
                        self.tblView.reloadRows(at: [indexPath], with: .none)
                        print((self.postData[row] as! NSDictionary)["likes"] as! Int)
                        
                    }else{
                       self.tblView.reloadData()
                        self.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    }
                    self.likeBool = false
                }
                
        }, failureBlock:
            {(error) in
                print(error)
        })
    }
    
    //MARK:- Download Image
    func downloadImage(url : URL) {
        let imgCache = SDImageCache.shared().imageFromDiskCache(forKey: "\(url)/thumbnail")
        if(imgCache != nil){
            return
        }else{
            let data = try? Data(contentsOf: url)
            if let imageData = data {
                
                let options = [
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary
                let source = CGImageSourceCreateWithData(imageData as CFData, nil)!
                let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
                let thumbnail = UIImage(cgImage: imageReference)
                SDImageCache.shared().store(thumbnail, forKey: "\(url)/thumbnail", toDisk: true, completion: nil)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }

}
