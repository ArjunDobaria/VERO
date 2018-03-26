//
//  PostTableViewCell.swift
//  VERO
//
//  Created by lanet on 08/03/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfilePicImg: UIImageView!
    @IBOutlet weak var userNameTxt: UILabel!
    @IBOutlet weak var timeOfPost: UILabel!
    @IBOutlet weak var privacyBtn: UIButton!
    @IBOutlet weak var postTxt: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet var postImgActivityIndecator: UIActivityIndicatorView!
    @IBOutlet weak var numberOfLikes: UIButton!
    @IBOutlet weak var numberOfComments: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var firstViewTop: NSLayoutConstraint!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondViewTop: NSLayoutConstraint!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdViewTop: NSLayoutConstraint!
    @IBOutlet weak var fourViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fourViewTop: NSLayoutConstraint!
    @IBOutlet weak var fiveViewTop: NSLayoutConstraint!
    @IBOutlet weak var fiveViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sixViewTop: NSLayoutConstraint!
    @IBOutlet weak var sixViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourView: UIView!
    @IBOutlet weak var fiveImgView: UIImageView!
    @IBOutlet weak var sixView: UIView!
    
    var imgView : UIImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.postImg.image = nil
        self.tag = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
