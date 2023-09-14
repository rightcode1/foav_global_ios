//
//  SnsCommentListCell.swift
//  FOAV
//
//  Created by hoonKim on 2020/08/27.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class SnsCommentListCell: UITableViewCell {
  @IBOutlet var backView: UIView!
  
  @IBOutlet var isMineImageView: UIImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var likeCountLabel: UILabel!
  
  @IBOutlet var menuImageview: UIImageView!
  @IBOutlet var menuButton: UIButton!
  
  @IBOutlet var contentLabel: UILabel!
  @IBOutlet var wishImageView: UIImageView!
  
  @IBOutlet var likeButton: UIButton!
  
  @IBOutlet var tagButton: UIButton!
  let html = """
  <html>
  <body>
  <p style="color: blue;">This is blue!</p>
  </body>
  </html>
  """
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    backView.layer.borderWidth = 1
    backView.layer.borderColor = #colorLiteral(red: 0.9377817512, green: 0.9571166635, blue: 0.9828757644, alpha: 1)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func initWithList(_ list: SnsCommentList) {
    nameLabel.text = list.user.loginId
    dateLabel.text = list.createdAt
    likeCountLabel.text = "\(list.wishCount)"
    
    contentLabel.attributedText = list.content.html2Attributed
    
    if list.isWish {
      wishImageView.image = #imageLiteral(resourceName: "heart_little")
    } else {
      wishImageView.image = #imageLiteral(resourceName: "heart_little-1")
    }
  }
  
  func initWithChallengeUserCommentList(_ list: ChallengeUserCommentList) {
    nameLabel.text = list.user.loginId
    dateLabel.text = list.createdAt
    likeCountLabel.text = "\(list.wishCount)"
    
    contentLabel.text = list.content
    
    if list.isWish {
      wishImageView.image = #imageLiteral(resourceName: "heart_little")
    } else {
      wishImageView.image = #imageLiteral(resourceName: "heart_little-1")
    }
  }
  
}
