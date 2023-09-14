//
//  CharityListViewController.swift
//  FOAV
//
//  Created by hoon Kim on 13/01/2020.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class CharityListViewController: UIViewController, UIGestureRecognizerDelegate {
  
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var CharityTableView: UITableView!
  
  let cellIdentifier = "DonationStoreCell"
  var charityList = [CharityList]()
  let date = Date()
  let dateFormatter = DateFormatter()
  var status: Bool = false
  
  @IBOutlet var selectView1: UIView!
  @IBOutlet var selectView2: UIView!
  
  let categoryList: [(String, UIImage, UIImage)] = [("전체보기", #imageLiteral(resourceName: "charityCategoryOff1"), #imageLiteral(resourceName: "charityCategoryOn1")), ("아동-청소년", #imageLiteral(resourceName: "charityCategoryOff2"), #imageLiteral(resourceName: "charityCategoryOn2")) , ("어르신", #imageLiteral(resourceName: "charityCategoryOff3"), #imageLiteral(resourceName: "charityCategoryOn3")), ("장애인", #imageLiteral(resourceName: "charityCategoryOff4"), #imageLiteral(resourceName: "charityCategoryOn4")),
                                                    ("다문화", #imageLiteral(resourceName: "charityCategoryOff5"), #imageLiteral(resourceName: "charityCategoryOn5")), ("지구촌", #imageLiteral(resourceName: "charityCategoryOff6"), #imageLiteral(resourceName: "charityCategoryOn6")) , ("가족-여성", #imageLiteral(resourceName: "charityCategoryOff7"), #imageLiteral(resourceName: "charityCategoryOn7")), ("시민사회", #imageLiteral(resourceName: "charityCategoryOff8"), #imageLiteral(resourceName: "charityCategoryOn8")),
                                                    ("동물", #imageLiteral(resourceName: "charityCategoryOff9"), #imageLiteral(resourceName: "charityCategoryOn9")), ("환경", #imageLiteral(resourceName: "charityCategoryOff10"), #imageLiteral(resourceName: "charityCategoryOn10")) , ("기타", #imageLiteral(resourceName: "charityCategoryOff11"), #imageLiteral(resourceName: "charityCategoryOn11"))]
  var category: String = "전체보기"
  var isActive: Bool = true
  
  var myId: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    CharityTableView.delegate = self
    CharityTableView.dataSource = self
    getUserInfo()
    registerXib()
    initCharityList()
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.tabBarController?.tabBar.isHidden = true
    self.navigationController?.navigationBar.isHidden = false
    navigationController?.interactivePopGestureRecognizer?.delegate = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ranking", let vc = segue.destination as? DonationRankViewController {
      vc.myId = myId
    }
  }
  
  private func registerXib() {
    let nibName = UINib(nibName: "DonationStoreCell", bundle: nil)
    CharityTableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
  }
  
  func initCharityList() {
    let param = CharityListRequest(diff: "all", category: category)
    ApiService.request(router: DonationApi.charityList(param: param), success: { (response: ApiResponse<CharityListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code == 202 {
          self.doAlert(message: value.resultMsg)
        } else {
          self.charityList = value.charityList
        }
        self.collectionView.reloadData()
        self.CharityTableView.reloadData()
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
  }
  
  func getUserInfo() {
    // 유저 정보 불러오는 곳
    ApiService.request(router: UserApi.userInfo, success: { (response:  ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.myId = value.user.id
      }
      else {
        if !value.result {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
  }
  
  @IBAction func tapGetNormalList(_ sender: UIButton) {
    selectView1.isHidden = false
    selectView2.isHidden = true
    isActive = true
    CharityTableView.reloadData()
  }
  
  @IBAction func tapGetEndList(_ sender: UIButton) {
    selectView1.isHidden = true
    selectView2.isHidden = false
    isActive = false
    CharityTableView.reloadData()
  }
  
  @IBAction func backBtn(_ sender: Any) {
    self.navigationController!.popViewController(animated: true)
  }
  
}
extension CharityListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return charityList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0{
      let cell = CharityTableView.dequeueReusableCell(withIdentifier: "first", for: indexPath)
      
      let backView = cell.viewWithTag(1) as! UIView
      let label = cell.viewWithTag(2) as! UILabel
      
        // 뷰 그림자 주기
      backView.layer.cornerRadius = 10
      backView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      backView.layer.shadowOpacity = 1
      backView.layer.shadowOffset = CGSize(width: 0, height: 1)
      backView.layer.shadowRadius = 2
      
      label.text = "\(charityList[indexPath.row].totalUserCount) steps"
      return cell
    }else{
      
      let cell = CharityTableView.dequeueReusableCell(withIdentifier: "DonationStoreCell", for: indexPath) as! DonationStoreCell
      dateFormatter.dateFormat = "yyyy.MM.dd"
      let today = dateFormatter.string(from: date)
      
      cell.titleLb.text = self.charityList[indexPath.row].company
      cell.diffImageView.image = self.charityList[indexPath.row].companyCode == nil ? UIImage(named: "wholeDonationIcon")! : UIImage(named: "groupDonationIcon")!
      cell.contentLb.text = self.charityList[indexPath.row].title
      cell.dateLb.text = self.charityList[indexPath.row].createdAt
      cell.thumbnailImageView.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/\(self.charityList[indexPath.row].thumbnail ?? "")"))
      
      //    if !self.charityList[indexPath.row].active {
      //      if Int(today.components(separatedBy: ".").joined())! < Int(self.charityList[indexPath.row].startDate.components(separatedBy: ".").joined())! {
      //        cell.activeLb.text = "진행예정"
      //        cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      //      } else {
      //        cell.activeLb.text = "마감"
      //        cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      //      }
      //    } else if self.charityList[indexPath.row].active {
      //
      //    }
      
      if Int(today.components(separatedBy: ".").joined())! < Int(self.charityList[indexPath.row].startDate.components(separatedBy: ".").joined())! {
        cell.activeLb.text = "scheduled"
        cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      } else if Int(today.components(separatedBy: ".").joined())! > Int(self.charityList[indexPath.row].endDate.components(separatedBy: ".").joined())! {
        cell.activeLb.text = "onstop"
        cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      } else {
        cell.activeLb.text = "ongoing"
        cell.statusView.backgroundColor = #colorLiteral(red: 0.9998399615, green: 0.7317306399, blue: 0.02152590081, alpha: 1)
      }
      
  //    cell.progressLabel.text = "\(Int(Double((Double(self.charityList[indexPath.row].current) / Double(self.charityList[indexPath.row].goal)) * 100)))%"
      let percentage = Double((Double(self.charityList[indexPath.row].current) / Double(self.charityList[indexPath.row].goal)) * 100)
      cell.progressLabel.text = "\(percentage <= 0.0 ? "0" : String(format: "%.0f", percentage))%"
      cell.categoryImageView.image = self.charityList[indexPath.row].diff == "걸음" ? #imageLiteral(resourceName: "serviceList_work") : #imageLiteral(resourceName: "serviceList_time")
      
      cell.categoryLabel.text = self.charityList[indexPath.row].diff == "걸음" ? "volunteer step donation" : "Volunteer hour donation"
      
      cell.thumbnailImageView.layer.cornerRadius = 37
      cell.selectionStyle = .none
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "realDonationVC") as! RealDonationViewController
    dateFormatter.dateFormat = "yyyy.MM.dd"
    let today = dateFormatter.string(from: date)
        if Int(today.components(separatedBy: ".").joined())! < Int(self.charityList[indexPath.row].startDate.components(separatedBy: ".").joined())! ||
            Int(today.components(separatedBy: ".").joined())! > Int(self.charityList[indexPath.row].endDate.components(separatedBy: ".").joined())! {
          status = false
        } else {
          status = true
        }
    let dict = charityList[indexPath.row]
    charityId = dict.id
    vc.status = status
    if indexPath.row == 0{
      vc.charityDiff = true
    }else{
      vc.charityDiff = false
    }
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let dict = charityList[indexPath.row]
    
    dateFormatter.dateFormat = "yyyy.MM.dd"
    let today = dateFormatter.string(from: date)
    
    if isActive {
      if Int(today.components(separatedBy: ".").joined())! <= Int(dict.startDate.components(separatedBy: ".").joined())! {
        return 115
      } else if Int(today.components(separatedBy: ".").joined())! > Int(dict.startDate.components(separatedBy: ".").joined())! &&
                  Int(today.components(separatedBy: ".").joined())! <= Int(dict.endDate.components(separatedBy: ".").joined())! {
        return 115
      } else if  Int(today.components(separatedBy: ".").joined())! > Int(dict.endDate.components(separatedBy: ".").joined())! {
        return 0
      } else {
        return 0
      }
    } else {
      if Int(today.components(separatedBy: ".").joined())! <= Int(dict.startDate.components(separatedBy: ".").joined())! {
        return 0
      } else if Int(today.components(separatedBy: ".").joined())! > Int(dict.startDate.components(separatedBy: ".").joined())! &&
                  Int(today.components(separatedBy: ".").joined())! <= Int(dict.endDate.components(separatedBy: ".").joined())! {
        return 0
      } else if  Int(today.components(separatedBy: ".").joined())! > Int(dict.endDate.components(separatedBy: ".").joined())! {
        return 115
      } else {
        return 115
      }
    }
  }
  
  
}
extension CharityListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categoryList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = UICollectionViewCell()
    
    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
    let imageView = cell.viewWithTag(1) as! UIImageView
    let dict = categoryList[indexPath.row]
    
    if category == dict.0 {
      imageView.image = dict.2
    } else {
      imageView.image = dict.1
    }
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let dict = categoryList[indexPath.row]
    category = dict.0
    initCharityList()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 15
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = self.collectionView.frame.size
    let width = (size.width - 105) / 6
    return CGSize(width: width, height: size.height - 14)
    
  }
  
}
