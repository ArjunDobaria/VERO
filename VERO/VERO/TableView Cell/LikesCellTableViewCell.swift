//
//  LikesCellTableViewCell.swift
//  VERO
//
//  Created by Lcom32 on 3/16/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class LikesCellTableViewCell: UITableViewCell {

    @IBOutlet var userProfilePic: UIImageView!
    @IBOutlet var displayName: UILabel!
    @IBOutlet var numberOfLikes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.numberOfLikes.text = ""
        self.displayName.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
