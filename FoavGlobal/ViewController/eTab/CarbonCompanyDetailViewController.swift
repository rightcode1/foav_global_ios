//
//  CarbonCompanyDetailViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/15.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class CarbonCompanyDetailViewController: UIViewController {
  @IBOutlet var contentLabel: UILabel!
  @IBOutlet var imageView: UIImageView!
  
  @IBOutlet var imageViewHeight: NSLayoutConstraint!
  @IBOutlet var linkView: UIView!
  @IBOutlet var youtubeBackView: UIView!
  @IBOutlet weak var youtubePlayer: WKYTPlayerView!{
    didSet{
      youtubePlayer.delegate = self
    }
  }
  
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
  
  func initWithDetail(_ data: CarbonCompanyDetail) {
    contentLabel.text = data.content
    linkString = data.link ?? ""
    linkView.isHidden = data.link != nil ? false : true
    if data.images != nil && (data.images?.count ?? 0) > 0{
      let urlString = "\(ApiEnvironment.baseUrl)/img/\(data.images![0] ?? "")"
      let url = URL(string: urlString)
      imageView.kf.setImage(with: url)
      figureOutHeight(urlString: urlString, height: imageViewHeight)
    }
    
    if data.youtube != nil {
      youtubeBackView.isHidden = false
      let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "autoplay": 1, "modestbranding": 0]
      let videoId = data.youtube ?? ""
      self.youtubePlayer.load(withVideoId: videoId, playerVars: playvarsDic)
    } else {
      youtubeBackView.isHidden = true
    }
  }
  
  func getCompanyDetail() {
    ApiService.request(router: CarbonLivingApi.carbonCompanyDetail(id: self.id ?? 0), success: { (response: ApiResponse<CarbonCompanyDetailResponse>) in
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
    if let url = URL(string: linkString ?? "") {
      UIApplication.shared.open(url, options: [:])
    }
  }
}

extension CarbonCompanyDetailViewController: WKYTPlayerViewDelegate {
  func playerView(_ playerView: WKYTPlayerView, didChangeTo state: WKYTPlayerState) {
    //  print(state)
  }
  func playerView(_ playerView: WKYTPlayerView, didPlayTime playTime: Float) {
    //  print(playTime)
  }
  func playerViewDidBecomeReady(_ playerView: WKYTPlayerView) {
    //        youtubePlayer.playVideo()
  }
}

