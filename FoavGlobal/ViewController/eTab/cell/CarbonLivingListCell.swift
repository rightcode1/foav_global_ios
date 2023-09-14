//
//  ActivityLIstCell.swift
//  FOAV
//
//  Created by hoon Kim on 2021/12/02.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class CarbonLivingListCell: UITableViewCell {
  
  @IBOutlet var thumbnailImageView: UIImageView!
  @IBOutlet var thumbnailImageViewWidth: NSLayoutConstraint!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var contentLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func initWithCarbonLivingList(_ data: CarbonLivingList) {
    let imageUrl = URL(string: "\(ApiEnvironment.baseUrl)/img/\(data.thumbnail ?? "")")!
    thumbnailImageView.kf.setImage(with: imageUrl)
    thumbnailImageView.layer.cornerRadius = 8
    
    let width = (UIScreen.main.bounds.size.width - 40) / 2
    thumbnailImageViewWidth.constant = width
    
    titleLabel.text = data.title
    contentLabel.text = data.content
    dateLabel.text = data.createdAt
  }
  
  func initWithFoavNewsList(_ data: FoavNewsResponse.FoavNews) {
//    \(ApiEnvironment.baseUrl)/img/
    let imageUrl = URL(string: "\(data.thumbnail ?? "")")!
    thumbnailImageView.kf.setImage(with: imageUrl)
    thumbnailImageView.layer.cornerRadius = 8
    
    let width = (UIScreen.main.bounds.size.width - 40) / 2
    thumbnailImageViewWidth.constant = width
    
    titleLabel.text = data.title
    contentLabel.text = data.content
    dateLabel.text = data.createdAt
  }
  
  func initWithCarbonCampany(_ data: CarbonCompany) {
    let imageUrl = URL(string: "\(ApiEnvironment.baseUrl)/img/\(data.thumbnail ?? "")")!
    thumbnailImageView.kf.setImage(with: imageUrl)
    thumbnailImageView.layer.cornerRadius = 8
    
    let width = (UIScreen.main.bounds.size.width - 40) / 2
    thumbnailImageViewWidth.constant = width
    
    titleLabel.text = data.title
//    contentLabel.text = data.content
    dateLabel.text = data.createdAt
  }
  
}
