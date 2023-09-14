//
//  AdvertisementViewController.swift
//  FOAV
//
//  Created by hoon Kim on 30/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import Kingfisher

class AdvertisementViewController: UIViewController {
  
  var advertisementId = 0
  var url = ""
  var imageUrl = ""
  @IBOutlet var adImgHeight: NSLayoutConstraint!
  
  @IBOutlet weak var adImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setImage()
    
  }
  override func viewWillAppear(_ animated: Bool) {
//    navigationController?.navigationBar.isHidden = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setImage()
  }
  
  func setImage() {
    if imageUrl != "" {
      print("imageUrl : \(imageUrl)")
      let url2 = URL(string: imageUrl)
      if let data = try? Data(contentsOf: url2!) {
        if let image = UIImage(data: data) {
          // 현재 뷰 width에 맞게 이미지 높이 조정해주기
          self.adImageView.image = image
          
          let diff = (self.view.frame.width / image.size.width)
          let h = image.size.height * diff
          self.adImgHeight.constant = h
        }
      }
    }
  }
  
  @IBAction func backBtn(_ sender: Any) {
    self.navigationController!.popViewController(animated: true)
  }
  
  
}
