//
//  DonationStoreCell.swift
//  FOAV
//
//  Created by hoon Kim on 11/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class DonationStoreCell: UITableViewCell {
  @IBOutlet var titleLb: UILabel!
  @IBOutlet var contentLb: UILabel!
  @IBOutlet var dateLb: UILabel!
  @IBOutlet var progressLabel: UILabel!
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var categoryLabel: UILabel!
  @IBOutlet var statusView: UIView!{
    didSet{
      statusView.layer.cornerRadius = 5
    }
  }
  @IBOutlet var activeLb: UILabel!{
    didSet{
      activeLb.layer.cornerRadius = 5
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
  @IBOutlet var categoryImageView: UIImageView!
  @IBOutlet var diffImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
