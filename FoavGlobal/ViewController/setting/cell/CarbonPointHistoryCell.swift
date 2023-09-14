//
//  CarbonPointHistoryCell.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class CarbonPointHistoryCell: UITableViewCell {
  
  @IBOutlet var shadowView: UIView!
  
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var diffLabel: UILabel!
  @IBOutlet var pointLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func initWithCarbonPointHistory(_ list: CarbonPointHistory) {
    dateLabel.text = list.createdAt
    nameLabel.text = list.carbonSaveStoreName
    diffLabel.text = list.content
    pointLabel.text = "\(list.point)p"
  }
  
}
