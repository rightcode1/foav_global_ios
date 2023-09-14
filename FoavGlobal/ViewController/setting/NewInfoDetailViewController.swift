//
//  NewInfoDetailViewController.swift
//  FOAV
//
//  Created by hoon Kim on 28/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class NewInfoDetailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var newsHeight: NSLayoutConstraint!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
  @IBOutlet var contentLabel: UILabel!
  @IBOutlet var InfoView: UIView!
    
    var imageOnOff = false
    var imageHeight: CGFloat = -590
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        getNoticeDetailInfo()
        
        newsImageView.contentMode = .scaleAspectFit
    }
    override func viewDidAppear(_ animated: Bool) {
        getNoticeDetailInfo()
    }

    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func getNoticeDetailInfo() {
        ApiService.request(router: SettingApi.newsDetail, success: { (response: ApiResponse<NewsDetailResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {let url = URL(string: value.news.image ?? "")
                if url == nil {
                    self.newsHeight.constant = 0
                } else if url != nil {
                // 현재 뷰 width에 맞게 이미지 높이 조정해주기
                  let data = try! Data(contentsOf: url!)
                  if let image = UIImage(data: data) {
                    // 현재 뷰 width에 맞게 이미지 높이 조정해주기
                    self.newsImageView.image = image
                    
                    let diff = (self.view.frame.width / image.size.width)
                    let h = image.size.height * diff
                    self.newsHeight.constant = h
                  }
                }
                self.newsDateLabel.text = String(value.news.createdAt.unicodeScalars.prefix(10))
                self.newsTitleLabel.text = value.news.title
                self.contentLabel.text = value.news.content
                
            }
            
        }) { (error) in
            self.doAlert(message: "알수없는 오류 입니다.\n 다시 시도해주세요.")
        }
        
    }
    
    
}
