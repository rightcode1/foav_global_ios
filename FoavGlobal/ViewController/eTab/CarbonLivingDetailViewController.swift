//
//  CarbonLivingDetailViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/15.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class CarbonLivingDetailViewController: UIViewController {
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var contentLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  
  @IBOutlet var imageViewHeight: NSLayoutConstraint!
  @IBOutlet var linkView: UIView!
  
  var id: Int?
  var linkString: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    getCompanyDetail()
  }
  
  func figureOutHeight(urlString: String, height: NSLayoutConstraint) {
    if let url = URL(string: urlString) {
      if let data = try? Data(contentsOf: url) {
        if let img = UIImage(data: data) {
          print("img: \(img)")
          let diff = (self.view.frame.width / img.size.width)
          print("diff: \(diff)")
          print("viewWidth: \(self.view.frame.width)")
          let h = img.size.height * diff
          height.constant = h
        }
      }
    }
  }
  
  func initWithDetail(_ data: CarbonLivingDetail) {
    navigationItem.title = data.title
    dateLabel.text = data.createdAt
    titleLabel.text = data.title
    contentLabel.text = data.content
    linkString = data.link ?? ""
    linkView.isHidden = data.link != nil ? false : true
    if data.images != nil && (data.images?.count ?? 0) > 0{
      let urlString = "\(ApiEnvironment.baseUrl)/img/\(data.images![0])"
      let url = URL(string: urlString)
      imageView.kf.setImage(with: url)
      figureOutHeight(urlString: urlString, height: imageViewHeight)
    }
    
  }
  
  func getCompanyDetail() {
    ApiService.request(router: CarbonLivingApi.carbonLivingDetail(id: self.id ?? 0), success: { (response: ApiResponse<CarbonLivingDetailResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.initWithDetail(value.data)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  @IBAction func tapLink(_ sender: UIButton) {
    if let url = URL(string: linkString!) {
      UIApplication.shared.open(url, options: [:])
    }
  }
}
