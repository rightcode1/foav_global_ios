//
//  ChallengeListViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/02.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit
import Kingfisher

enum ChallengeListDiff: String, Codable {
  case 전체보기
  case 기업기관 = "기업/기관"
  case 봉사센터
  case 지자체
  case 기타
}

class ChallengeListViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  
  @IBOutlet var collectionView: UICollectionView!
  
  @IBOutlet var rankButton: UIButton!
  
  @IBOutlet var selectView1: UIView!
  @IBOutlet var selectView2: UIView!
  
  let cellIdentifier = "ChallengeListCell"
  
  let diffList: [(String, UIImage, UIImage)] = [("전체보기", #imageLiteral(resourceName: "challengeDiff1On"), #imageLiteral(resourceName: "challengeDiff1Off")), ("기업/기관", #imageLiteral(resourceName: "challengeDiff2On"), #imageLiteral(resourceName: "challengeDiff2Off")), ("봉사센터", #imageLiteral(resourceName: "challengeDiff3On"), #imageLiteral(resourceName: "challengeDiff3Off")),
                                                           ("지자체", #imageLiteral(resourceName: "challengeDiff4On"), #imageLiteral(resourceName: "challengeDiff4Off")), ("기타", #imageLiteral(resourceName: "challengeDiff5On"), #imageLiteral(resourceName: "challengeDiff5Off"))]
  var selectedDiff: ChallengeListDiff = .전체보기
  var challengeList: [ChallengeList] = []
  
  let date = Date()
  let dateFormatter = DateFormatter()
  
  var userId: Int?
  var companyId: Int?
  var userLoginId: String?
  
  var isActive: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initChallengeDiffCollectionViewLayout()
//    
    tableView.delegate = self
    tableView.dataSource = self
    
    registerXib()
    getUserInfo()
    
    
    if companyId != nil {
      navigationItem.title = "Employee Exclusive Challenge"
      rankButton.isHidden = true
    } else {
      navigationItem.title = "Challenge together"
      rankButton.isHidden = false
    }
    
    self.collectionView.reloadData()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        getList()
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "challengeDetail", let vc = segue.destination as? ChallengeDetailViewController, let challengeId = sender as? Int {
      vc.id = challengeId
      vc.isCompany = companyId != nil
      vc.userId = userId
      vc.userLoginId = userLoginId
      vc.companyId = companyId 
    }
    
    if segue.identifier == "rank", let vc = segue.destination as? ChallengeRankViewController {
      vc.myId = userLoginId
    }
  }
  
  private func registerXib() {
    let nibName = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
  }
  
  func initChallengeDiffCollectionViewLayout() {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let width = 47
    let height = 60
    
    layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 0, right: 15)
    layout.itemSize = CGSize(width: width, height: height)
    
    let spacing = ((Int(UIScreen.main.bounds.size.width) - 30) - (width * 5)) / 4
    layout.minimumInteritemSpacing = CGFloat(spacing)
    layout.minimumLineSpacing = CGFloat(spacing)
    collectionView.collectionViewLayout = layout
  }
  
  func getList() {
    if companyId == nil || companyId == 0 {
      getChallengeList()
    } else {
      getEmployeesChallengeList()
    }
  }
  
  func stringToChallengeListDiff(_ string: String) -> ChallengeListDiff {
    switch string {
    case "전체보기":
      return .전체보기
    case "기업/기관":
      return .기업기관
    case "봉사센터":
      return .봉사센터
    case "지자체":
      return .지자체
    case "기타":
      return .기타
    default:
      return .전체보기
    }
  }
  
  func getChallengeList() {
    let param = ChallengeListRequest(diff: selectedDiff == .전체보기 ? nil : selectedDiff.rawValue)
    ApiService.request(router: CarbonLivingApi.challengeList(param: param), success: { (response: ApiResponse<ChallengeListResponse>) in
      guard let value = response.value else {
        return
      }
        print("!!!!")
      if value.result {
        self.challengeList = value.list
        self.tableView.reloadData()
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  func getEmployeesChallengeList() {
    let param = ChallengeListRequest(companyId: companyId ?? 0, category: "전체", diff: selectedDiff == .전체보기 ? nil : selectedDiff.rawValue)
    ApiService.request(router: CarbonLivingApi.employeesChallengeList(param: param), success: { (response: ApiResponse<ChallengeListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.challengeList = value.list
        self.tableView.reloadData()
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  func getUserInfo() {
    // 유저 정보 불러오는 곳
    ApiService.request(router: UserApi.userInfo, success: { (response:  ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.userId = value.user.id
        self.userLoginId = value.user.loginId
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
    getList()
  }
  
  @IBAction func tapGetEndList(_ sender: UIButton) {
    selectView1.isHidden = true
    selectView2.isHidden = false
    isActive = false
    getList()
  }
  
}

extension ChallengeListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return diffList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = UICollectionViewCell()
    
    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    let imageView = cell.viewWithTag(1) as! UIImageView
    let dict = diffList[indexPath.row]
    
    if selectedDiff.rawValue == dict.0 {
      imageView.image = dict.1
    } else {
      imageView.image = dict.2
    }
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let dict = diffList[indexPath.row]
    selectedDiff = stringToChallengeListDiff(dict.0)
    self.collectionView.reloadData()
    getList()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let size = self.collectionView.frame.size
//    let width = (size.width - 105) / 6
    return CGSize(width: 47, height: 60)
    
  }
  
}

extension ChallengeListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return challengeList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChallengeListCell
    let dict = challengeList[indexPath.row]
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: date)
    cell.titleLb.text = dict.title

    cell.dateLb.text = "\(dict.startDate) ~ \(dict.endDate)"

    let downsamplingImageProcessor = DownsamplingImageProcessor(size: cell.thumbnailImageView.bounds.size)
    cell.thumbnailImageView.kf.setImage(with: URL(string: "https://d2twzv77g3c69u.cloudfront.net/fit-in/400x400/\(dict.thumbnail ?? "")"), options: [.processor(downsamplingImageProcessor)])

    cell.peopleCountLabel.text = "\(dict.join)명"
    cell.commentCountLabel.text = "\(dict.challengeUserCommentCount)개"

    if !dict.active {
      if isActive {
        if Int(today.components(separatedBy: "-").joined())! < Int(dict.startDate.components(separatedBy: "-").joined())! {
          cell.activeLb.text = "scheduled"
          cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else if Int(today.components(separatedBy: "-").joined())! > Int(dict.endDate.components(separatedBy: "-").joined())! {
          cell.activeLb.text = "deadline"
          cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
          cell.activeLb.text = "Ongoing"
          cell.statusView.backgroundColor = #colorLiteral(red: 0.9998399615, green: 0.7317306399, blue: 0.02152590081, alpha: 1)
        }
      } else {
        if Int(today.components(separatedBy: "-").joined())! < Int(dict.startDate.components(separatedBy: "-").joined())!{
          cell.activeLb.text = "진행예정"
          cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else {
          cell.activeLb.text = "deadline"
          cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
      }
    } else if dict.active {
      if Int(today.components(separatedBy: "-").joined())! < Int(dict.startDate.components(separatedBy: "-").joined())! {
        cell.activeLb.text = "scheduled"
        cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      } else if Int(today.components(separatedBy: "-").joined())! > Int(dict.endDate.components(separatedBy: "-").joined())! {
        cell.activeLb.text = "deadline"
        cell.statusView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      } else {
        cell.activeLb.text = "Ongoing"
        cell.statusView.backgroundColor = #colorLiteral(red: 0.9998399615, green: 0.7317306399, blue: 0.02152590081, alpha: 1)
      }
    }

    cell.thumbnailImageView.layer.cornerRadius = cell.thumbnailImageView.bounds.height / 2
    cell.selectionStyle = .none
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dict = challengeList[indexPath.row]
    performSegue(withIdentifier: "challengeDetail", sender: dict.id)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let dict = challengeList[indexPath.row]
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: date)

    if isActive {
      if !dict.active {
        if Int(today.components(separatedBy: "-").joined())! < Int(dict.startDate.components(separatedBy: "-").joined())! {
          return 105
        } else if  Int(today.components(separatedBy: "-").joined())! > Int(dict.endDate.components(separatedBy: "-").joined())! {
          return 0
        } else {
          return 105
        }
      } else if dict.active {
        if Int(today.components(separatedBy: "-").joined())! <= Int(dict.startDate.components(separatedBy: "-").joined())! {
          return 105
        } else if Int(today.components(separatedBy: "-").joined())! > Int(dict.startDate.components(separatedBy: "-").joined())! &&
                    Int(today.components(separatedBy: "-").joined())! <= Int(dict.endDate.components(separatedBy: "-").joined())! {
          return 105
        } else if  Int(today.components(separatedBy: "-").joined())! > Int(dict.endDate.components(separatedBy: "-").joined())! {
          return 0
        } else {
          return 0
        }
      } else {
        return 0
      }
    } else {
      if !dict.active {
        if Int(today.components(separatedBy: "-").joined())! < Int(dict.startDate.components(separatedBy: "-").joined())! {
          return 0
         }else if Int(today.components(separatedBy: "-").joined())! > Int(dict.endDate.components(separatedBy: "-").joined())! {
          return 105
        } else {
          return 0
        }
      } else if dict.active {
        if Int(today.components(separatedBy: "-").joined())! < Int(dict.startDate.components(separatedBy: "-").joined())! {
          return 0
        } else if Int(today.components(separatedBy: "-").joined())! > Int(dict.endDate.components(separatedBy: "-").joined())! {
          return 105
        } else {
          return 0
        }
      } else {
        return 0
      }
    }
  }


}
