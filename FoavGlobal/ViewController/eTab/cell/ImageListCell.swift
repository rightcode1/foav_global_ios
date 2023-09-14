//
//  ImageListCell.swift
//  FOAV
//
//  Created by hoon Kim on 2021/12/13.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class ImageListCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
//    for subview in subviews {
//      subview.removeConstraints(subview.constraints)
//      subview.removeFromSuperview()
//    }
//    
//    self.removeFromSuperview()
  }
  
}
