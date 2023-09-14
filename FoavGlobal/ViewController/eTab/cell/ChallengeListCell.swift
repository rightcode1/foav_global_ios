//
//  ChallengeListCell.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/16.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class ChallengeListCell: UITableViewCell {
  
  @IBOutlet var titleLb: UILabel!
  @IBOutlet var dateLb: UILabel!
  @IBOutlet var activeLb: UILabel!
  
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var statusView: UIView!{
    didSet{
      statusView.layer.cornerRadius = 5
    }
  }
  
  @IBOutlet var peopleCountLabel: UILabel!
  @IBOutlet var peopleCountView: UIView! {
    didSet{
      peopleCountView.layer.cornerRadius = 4
    }
  }
  @IBOutlet var commentCountLabel: UILabel!
  @IBOutlet var commentCountView: UIView! {
    didSet{
      commentCountView.layer.cornerRadius = 4
    }
  }
  
  @IBOutlet var firstView: UIView!{
    didSet{
      // 뷰 그림자 주기
      firstView.layer.cornerRadius = 5
      firstView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      firstView.layer.shadowOpacity = 1
      firstView.layer.shadowOffset = CGSize(width: 0, height: 1)
      firstView.layer.shadowRadius = 2
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    
  }
  
  
  
}
