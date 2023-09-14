//
//  SettingViewController.swift
//  FOAV
//
//  Created by hoon Kim on 01/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import SDWebImage
import Kingfisher

class SettingViewController: BaseViewController {
  
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var carbonBackView: UIView!{
    didSet{
      carbonBackView.layer.cornerRadius = 11
      carbonBackView.layer.shadowOpacity = 1
      carbonBackView.layer.shadowOffset = CGSize(width: 0, height: 2)
      carbonBackView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      carbonBackView.layer.shadowRadius = 2
    }
  }
  
  @IBOutlet var voucherView: UIView!{
    didSet{
      // 뷰에 그림자 주는 법
      voucherView.layer.cornerRadius = 11
      voucherView.layer.shadowOpacity = 1
      voucherView.layer.shadowOffset = CGSize(width: 0, height: 2)
      voucherView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      voucherView.layer.shadowRadius = 2
    }
  }
  
    @IBOutlet weak var campaignStatusButton: UIImageView!
    @IBOutlet weak var newNoticeImg: UIImageView!
  @IBOutlet weak var newNewsImg: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var serviceCenterNameLabel: UILabel!
  @IBOutlet weak var userNumLabel: UILabel!
  @IBOutlet weak var centerNameLabel: UILabel!
  @IBOutlet weak var counUIView: UIView! {
    didSet{
      counUIView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      counUIView.layer.cornerRadius = 11
      counUIView.layer.shadowOpacity = 1
      counUIView.layer.shadowOffset = CGSize(width: 0, height: 0)
      counUIView.layer.shadowRadius = 2
    }
  }
  @IBOutlet weak var centerCountLabel: UILabel!
  @IBOutlet weak var manegerCountLabel: UILabel!
  @IBOutlet weak var userCountLabel: UILabel!
  @IBOutlet weak var serviceCountLabel: UILabel!
  @IBOutlet weak var birthdayLb: UILabel!
  @IBOutlet var serviceListUIView: UIView!
  @IBOutlet var myMonthCarbonLabel: UILabel!
  @IBOutlet var myPointLabel: UILabel!
  
  var timer = Timer()
  var counter = 0
  var cardCheck = false
  var centerName = ""
  var centerNameValue = ""
  var settingAdVertisements = [AdVertisements]()
  var orderStatus: Bool = false
  var userId: Int!
  
  var foavNews = [FoavNewsResponse.FoavNews]()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = false
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    
    
    userCardCheck()
    initrx()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "refund", let vc = segue.destination as? PolicyViewController {
    } else if segue.identifier == "policy", let vc = segue.destination as? PolicyViewController {
        vc.getUrl = "https://foav.co.kr/userPolicyGlobal.html"
    } else if segue.identifier == "use" , let vc = segue.destination as? PolicyViewController {
        vc.getUrl = "http://foav.co.kr/policy/refund.html"
    } else if segue.identifier == "location" , let vc = segue.destination as? PolicyViewController {
      vc.getUrl = "https://foav.co.kr/locPolicyGlobal.html"
    }

    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    scrollView.scrollToTop()
    updateUI()
//    getNoticeInfo()
//    getNewsInfo()
    // 타이머 설정 #셀렉터 부분에 시간당 호출할 함수 넣어주기
//    timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
//    
//    if orderStatus {
//      let vc = UIStoryboard.init(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "orderList") as! PaymentHistoryViewController
//      orderStatus = false
//      order = false
//      self.navigationController?.pushViewController(vc, animated: true)
//    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    timer.invalidate()
  }
  
    func initrx(){
        campaignStatusButton.rx.tapGesture().when(.recognized)
              .subscribe(onNext: { _ in
              })
              .disposed(by: disposeBag)
    }
  
//  @objc func changeImage() {
//
//    if counter < settingAdVertisements.count {
//      let index = IndexPath.init(item: counter, section: 0)
//      self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//      sliderPageControl.currentPage = counter
//      counter += 1
//    } else {
//      counter = 0
//      let index = IndexPath.init(item: counter, section: 0)
//      self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//      sliderPageControl.currentPage = counter
//    }
//
//  }
  
  
  // 소식 불러옴
//  func getFoavNews() {
//    ApiService.request(router: HomeApi.foavNews , success: { (response: ApiResponse<FoavNewsResponse>) in
//      guard let value = response.value else {
//        return
//      }
//      if value.result {
//        self.foavNews = value.newsList
//        self.foavNewsTableView.reloadData()
//        self.initFoavNewsTableViewHeight()
//
//      } else if !value.result {
//        self.doAlert(message: value.resultMsg)
//      }
//    }) { (error) in
//
//    }
//  }
//
  // 소식 정보 불러오면서 새로운 소식이 있으면 new 이미지 히든 풀어주기.
  func getNewsInfo() {
    ApiService.request(router: SettingApi.news, success: { (response: ApiResponse<NewsResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        let compare = UserDefaults.standard.integer(forKey: "newsListIndex")
        if compare < value.newsList.count {
          self.newNewsImg.isHidden = false
        } else if compare >= value.newsList.count {
          self.newNewsImg.isHidden = true
        }
      }
    }) { (error) in
    }
  }
  // 공지사항 정보 불러오면서 새로운 공지사항이 있으면 new 이미지 히든 풀어주기.
    @IBAction func faovTab(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "NoticeList") as! newInfoViewController
            vc.diff = "foav"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func getNoticeInfo() {
    ApiService.request(router: SettingApi.notice, success: { (response: ApiResponse<NoticeResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        let compare = UserDefaults.standard.integer(forKey: "noticeListIndex")
        if compare < value.notices.count {
          self.newNoticeImg.isHidden = false
        } else if compare >= value.notices.count {
          self.newNoticeImg.isHidden = true
        }
      }
    }) { (error) in
      
    }
  }
  
  func userCardCheck() {
    ApiService.request(router: UserApi.userCardCheck, success: { (response: ApiResponse<UserCardCheckResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        print("value.isCard : \(value.isCard)")
        self.cardCheck = value.isCard
      }
    }) { (error) in
      
    }
    
  }
  
  func updateUI() {
    
    // 유저 정보 불러오는 곳
    ApiService.request(router: UserApi.userInfo, success: { (response:  ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      dump(response)
      print("-response: \(response)" )
      if value.result {
        self.userId = value.user.id
        self.nameLabel.text = "\(value.user.name)"
        self.userNumLabel.text = value.user.loginId
        self.birthdayLb.text = value.user.birth
        let changeSecond = ((value.user.totalServiceTime) / 1000)
        self.serviceCenterNameLabel.text = value.user.groupName
        self.centerCountLabel.text = "\(value.statistics.centerCount)+"
        self.manegerCountLabel.text = "\(value.statistics.ManagerCount)+"
        self.userCountLabel.text = "\(value.statistics.userCount)+"
        self.serviceCountLabel.text = "\(value.statistics.serviceCount)+"
        if value.user.type == "담당자" {
          self.serviceCenterNameLabel.isHidden = false
          self.centerNameLabel.isHidden = false
        } else if value.user.type == "일반"{
          self.serviceCenterNameLabel.isHidden = true
          self.centerNameLabel.isHidden = true
          self.serviceListUIView.isHidden = true
        }
        self.myMonthCarbonLabel.text = "\(String(format: "%.1f", value.user.monthCarbon ?? 0)) kg"
        self.myPointLabel.text = "\(value.user.point ?? 0)"
      }
      else {
        if !value.result {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
    // 콜렉션 뷰에 넣어줄 광고 불러옴
    let param = AdvertisementRequest (
      location: "setting"
    )
//    ApiService.request(router: HomeApi.getAdvertisement(param: param) , success: { (response: ApiResponse<AdvertisementResponse>) in
//      guard let value = response.value else {
//        return
//      }
//      if value.result {
//        self.settingAdVertisements = value.advertisements
//        self.sliderCollectionView.reloadData()
//
//
//      } else if !value.result {
//        self.doAlert(message: value.resultMsg)
//      }
//    }) { (error) in
//
//    }
  }
  
  @IBAction func persnalInfoBtn(_ sender: UIButton) {
    
  }
  
  
  
}
// MARK: - extension

extension SettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return settingAdVertisements.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingSliderCell", for: indexPath)
    if let imageView = cell.viewWithTag(111) as? UIImageView {
      let url = URL(string: settingAdVertisements[indexPath.row].thumbnail)
      imageView.kf.setImage(with: url!)
      imageView.layer.cornerRadius = 20
      
    } else if let ab = cell.viewWithTag(222) as? UIPageControl {
      ab.currentPage = indexPath.row
    }
    
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "advertisementVC") as! AdvertisementViewController
    clickToAdvertisementId = settingAdVertisements[indexPath.row].id
    vc.advertisementId = settingAdVertisements[indexPath.row].id
    if clickToAdvertisementId != 0 {
      ApiService.request(router: HomeApi.clickCount , success: { (response: ApiResponse<AdvertisementClinkCountResponse>) in
        guard let value = response.value else {
          return
        }
        if value.result {
          print("++++++++++++count")
        }
      }) { (error) in
        
      }
    } else {
      return
    }
    if settingAdVertisements[indexPath.row].url != "" {
      if let url = URL(string: settingAdVertisements[indexPath.row].url ?? "") {
        UIApplication.shared.open(url, options: [:])
      }
    }
    if settingAdVertisements[indexPath.row].url ?? "" == "" {
      vc.imageUrl = settingAdVertisements[indexPath.row].image ?? ""
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}
//
//extension SettingViewController: UICollectionViewDelegateFlowLayout {
//
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//  }
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let size = sliderCollectionView.frame.size
//    return CGSize(width: size.width, height: size.height)
//  }
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//    return 0.0
//  }
//  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//    return 0.0
//  }
//
//}
//
//extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return foavNews.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CarbonLivingListCell
//    let dict = foavNews[indexPath.row]
//
//    cell.initWithFoavNewsList(dict)
//    cell.selectionStyle = .none
//    return cell
//  }
//
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//    return 125
//  }
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////    let dict = foavNews[indexPath.row]
////    let vc1 = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "newsDetailVC") as! NewInfoDetailViewController
////    newsDetailId = dict.id
////    self.navigationController?.pushViewController(vc1, animated: true)
//  }
//}
