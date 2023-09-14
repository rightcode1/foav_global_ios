//
//  RealDonationViewController.swift
//  FOAV
//
//  Created by hoon Kim on 08/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
class RealDonationViewController: UIViewController, UIGestureRecognizerDelegate {
  
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var donationBtnUI: UIButton!{
    didSet{
      self.donationBtnUI.layer.cornerRadius = 5
    }
  }
  @IBOutlet var youtubeView: WKYTPlayerView!
  @IBOutlet var contentImgHeight: NSLayoutConstraint!
  @IBOutlet var titleLb: UILabel!
  @IBOutlet var thumbnailImg: UIImageView!
  @IBOutlet var presentDonationLb: CountingLabel!
  
  @IBOutlet var goalPriceLb: UILabel!
  @IBOutlet var donationProgress: UIProgressView!
  @IBOutlet var dateLb: UILabel!
  @IBOutlet var DdayLb: UILabel!
  @IBOutlet var contentImg: UIImageView!
  @IBOutlet var InfoView: UIView!
  @IBOutlet var myDonationInfoView: UIView!
  @IBOutlet var workDonationInfoView: UIView!
  @IBOutlet var workDonationCountLabel: UILabel!
  @IBOutlet var youtubeHeight: NSLayoutConstraint!
  @IBOutlet var youtube_TopCon: NSLayoutConstraint!
  @IBOutlet var youtube_BottomCon: NSLayoutConstraint!
  @IBOutlet var blurView: UIView!
  @IBOutlet var goalLabel: UILabel!
  @IBOutlet var diffLabel1: UILabel!
  @IBOutlet var diffLabel2: UILabel!
  @IBOutlet var linkViewHeight: NSLayoutConstraint!
  @IBOutlet var linkView: UIView!
  @IBOutlet var diffImageView: UIImageView!
  
  @IBOutlet var goalLb: UILabel!
  @IBOutlet var currentDay: UILabel!
  @IBOutlet var donationButton: UIButton!
  @IBOutlet var diffImageView2: UIImageView!
  
  let dateFormatter = DateFormatter()
  let currentCalendar = NSCalendar.current
  var count = 0.0
  var total = 0.0
  var donationCompany = ""
  var url2:URL?
  var videoId = ""
  var donationId: Int = 0
  var diff: String?
  var status: Bool = false
  var link: String?
  var charityDiff: Bool = false
  
  var isCompanyDonation: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tabBarController?.tabBar.isHidden = true
    initShadow()
    initHidden()
    charityDetail()
    // 이미지에 블러 (모자이크) 주기
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = thumbnailImg.bounds
    blurEffectView.alpha = 0.5
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    thumbnailImg.addSubview(blurEffectView)
    // Do any additional setup after loading the view.
  }
  
//  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "donationVC", let vc = segue.destination as? PayViewController {
//      vc.donationCompany = donationCompany
//    }
//  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = true
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    
  }
  func initHidden() {
    if charityDiff {
      donationButton.isHidden = true
      goalLabel.isHidden = true
      currentDay.isHidden = true
      dateLb.isHidden = true
      goalLb.isHidden = true
      DdayLb.isHidden = true
      diffImageView2.isHidden = false
      diffImageView.isHidden = true
    }
  }
  func initShadow() {
    workDonationInfoView.layer.cornerRadius = 10
    workDonationInfoView.layer.applySketchShadow(color: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0), alpha: 0.15, x: 0, y: 1.5, blur: 3.5, spread: 0)
  }
    // CountingLabel 사용법
    // fromValue = 몇 부터 , to = 몇까지 , withDuration: 몇초 동안, andAnimationType = 애니메이션타입 , andCounterType = 타입
  
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
  
  func charityDetail() {
    DispatchQueue.main.async {
      self.dateFormatter.dateFormat = "yyyy.MM.dd"
      self.dateFormatter.timeZone = NSTimeZone(name:"UTC") as TimeZone?
      ApiService.request(router: DonationApi.charityDetail(id: charityId), success: { (response: ApiResponse<CharityDetailResponse>) in
        guard let value = response.value else {
          return
        }
        if value.result {
          if value.code == 202 {
            self.doAlert(message: value.resultMsg)
          } else {
            DispatchQueue.main.async {
              self.donationId = value.charity.id
              
              self.isCompanyDonation = value.charity.companyCode != nil
              self.diffImageView.image = self.isCompanyDonation ? UIImage(named: "groupDonationIcon")! : UIImage(named: "wholeDonationIcon")!
              self.diffImageView2.image = self.isCompanyDonation ? UIImage(named: "groupDonationIcon")! : UIImage(named: "wholeDonationIcon")!
              
              self.myDonationInfoView.isHidden = value.charity.totalUserCount ?? 0 <= 0
              
              self.videoId = value.charity.code ?? ""
              
              if self.videoId != "" {
                self.youtube_TopCon.constant = 10
                self.youtube_BottomCon.constant = 10
                self.youtubeHeight.constant = 250
                let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "autoplay": 1, "modestbranding": 0]
                self.youtubeView.load(withVideoId: self.videoId, playerVars: playvarsDic)
              } else {
                self.youtube_TopCon.constant = 0
                self.youtube_BottomCon.constant = 0
                self.youtubeHeight.constant = 0
              }
              // 두 데이트 타입의 -D 구하는법 D-day구하는법
              // 스트링을 데이트 타입으로 변환시키는 방법
              let date1: Date = self.dateFormatter.date(from: value.charity.startDate)!
              let date2: Date = self.dateFormatter.date(from: value.charity.endDate)!
              let diffInDays = Calendar.current.dateComponents([.day], from: date1, to: date2)
              print("diffInDays : \(diffInDays)")
              
              self.total = Double(value.charity.goal)
              if self.charityDiff{
                self.count = Double(value.charity.totalUserCount ?? 0)
                self.workDonationCountLabel.text = "현재 \(value.charity.totalUserCount?.formattedProductPrice() ?? "0")걸음이 버려집니다."
              }else{
                self.count = Double(value.charity.current)
                self.workDonationCountLabel.text = "We're currently donating \(value.charity.totalUserCount?.formattedProductPrice() ?? "0")"
              }
              
              self.presentDonationLb.count(fromValue: 0, to: Float(self.count), withDuration: 0.4,  andAnimationType: .EaseIn, andCounterType: .Int)
              UIView.animate(withDuration: 0.5) {
                // 프로그레스바는 맥시멈 값이 무조건 1.0 이기때문에
                // 백분율을 구하듯이 100을 곱해주지 않아도 된다 .
                let progress:Float = Float(self.count / self.total)
                
                self.donationProgress.setProgress(Float(progress > 1 ? 1 : progress), animated: true)
              }
              self.link = value.charity.link ?? ""
              self.linkViewHeight.constant = value.charity.link == nil ? 0 : 50
              self.linkView.isHidden = value.charity.link == nil ? true : false
              self.titleLb.text = value.charity.title
              self.donationCompany = value.charity.company
              self.dateLb.text = "\(value.charity.startDate)~\(value.charity.endDate)"
              self.DdayLb.text = "\(value.charity.dDay)"
              
              if !value.charity.active {
//                self.donationBtnUI.backgroundColor = .lightGray
//                self.donationBtnUI.isEnabled = false
              }
              if !self.status {
                self.donationBtnUI.backgroundColor = .lightGray
                self.donationBtnUI.isEnabled = false
              }
              
              let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(value.charity.thumbnail ?? "")")
              self.url2 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(value.charity.english ?? "")")
              
              self.figureOutHeight(urlString: "\(ApiEnvironment.baseUrl)/img/\(value.charity.english ?? "")", height: self.contentImgHeight)
              if url != nil {
                self.thumbnailImg.kf.setImage(with: url)
              }
              if self.url2 != nil {
                self.contentImg.kf.setImage(with: self.url2)
              }
              self.diff = value.charity.diff
              
              self.diffLabel1.text = "step"
                self.diffLabel2.text = "step"
              
              let goalPrice = value.charity.goalPrice
              self.goalPriceLb.isHidden = goalPrice == 0
              self.goalPriceLb.text = goalPrice == 0 ? nil : "\(goalPrice.formattedProductPrice() ?? "")원"
              self.goalLabel.text = "\(value.charity.goal.formattedProductPrice() ?? "")"
              
            }
          }
        }
      }) { (error) in
        self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
      }
    }
  }
  
  @IBAction func tabShowLink(_ sender: UIButton) {
        if let url = URL(string: link ?? "") {
          UIApplication.shared.open(url, options: [:])
    }
  }
  
  
  @IBAction func donationBtn(_ sender: UIButton) {
//    if let url = URL(string: "https://foav.co.kr/prepare/index.php") {
//      UIApplication.shared.open(url, options: [:])
//    }
    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "donationPopup") as! DonationPopupViewController
    vc.diff = diff
    vc.donationId = donationId
    vc.donationCompany = donationCompany
    vc.modalPresentationStyle = .overCurrentContext
    vc.modalTransitionStyle = .crossDissolve
    
    self.present(vc, animated: true, completion: nil)
  }
  
  @IBAction func backBtn(_ sender: Any) {
    // 네비게이션을 이용한 이전화면으로 돌아가기
    self.navigationController!.popViewController(animated: true)
  }
}

// 네비게이션 바 애니메이션 주는거 
//extension RealDonationViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        var offset = scrollView.contentOffset.y / 150
//
//        if offset > -0.5 {
//            UIView.animate(withDuration: 0.2, animations: {
//                offset = 1
//                let color = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
//                let navigationColor = UIColor(hue: 0, saturation: offset, brightness: 1, alpha: 1)
//                self.navigationController?.navigationBar.tintColor = navigationColor
//                self.navigationController?.navigationBar.backgroundColor = color
//
//                UIApplication.shared.statusBarView?.backgroundColor = color
//
//                self.navigationController?.navigationBar.barStyle = .default
//            })
//        }
//        else {
//            UIView.animate(withDuration: 0.2, animations: {
//                offset = 1
//                let color = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
//                self.navigationController?.navigationBar.tintColor = .white
//                self.navigationController?.navigationBar.backgroundColor = color
//                UIApplication.shared.statusBarView?.backgroundColor = color
//
//                self.navigationController?.navigationBar.barStyle = .black
//            })
//        }
//
//    }
//}
