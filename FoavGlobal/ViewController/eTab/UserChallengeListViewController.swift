//
//  UserChallengeListViewController.swift
//  FOAV
//
//  Created by hoon Kim on 2021/12/14.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class UserChallengeListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  let cellIdentifier = "UserChallengeListCell"
  
  var id: Int?
  
  var userId: Int?
  var userLoginId: String?
  
  var companyId: Int?
  var isCompany: Bool?
  
  var challengeList: [ChallengeUserList] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    addChallengeListData()
    registerXib()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "detail", let vc = segue.destination as? ChallengeCommentDetailViewController, let userChallengeId = sender as? Int {
//      vc.userChallengeId = userChallengeId
//      vc.userId = userId
//      vc.userLoginId = userLoginId
//      vc.isCompany = isCompany
//      vc.companyId = companyId
//    }
  }
  
  private func registerXib() {
    let nibName = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
  }
  
  func addChallengeListData() {
    self.showHUD()
    let param = ChallengeUserListRequest(page: nil, limit: nil, challengeId: id ?? 0)
    ApiService.request(router: CarbonLivingApi.challengeUserList(param: param), success: { (response: ApiResponse<ChallengeUserList_OnlyListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.challengeList = value.list
        
        self.tableView.reloadData()
        self.dismissHUD()
      } else if !value.result {
        self.dismissHUD()
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.dismissHUD()
      self.doAlert(message: "알수없는 오류 입니다./n다시 시도해주세요.")
    }
  }
  
  func removeUserChallenge(id: Int) {
    ApiService.request(router: CarbonLivingApi.challengeUserRemove(id: id), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.okActionAlert(message: "삭제되었습니다.") {
          //          self.getChallengeUserList(id: self.id ?? 0, isLimit: self.isLimit)
        }
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류 입니다./n다시 시도해주세요.")
    }
  }
  
  func registUserChallengeLike(id: Int) {
    ApiService.request(router: CarbonLivingApi.registUserChallengeLike(challengeUserId: id), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.addChallengeListData()
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류 입니다./n다시 시도해주세요.")
    }
  }
  
  func removeUserChallengeLike(id: Int) {
    ApiService.request(router: CarbonLivingApi.removeUserChallengeLike(challengeUserId: id), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        //        self.getChallengeUserList(id: self.id ?? 0,isLimit: self.isLimit)
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류 입니다./n다시 시도해주세요.")
    }
  }
  
  @objc
  func moveToUserSnsList(_ sender: UIButton) {
    if let index = Int(sender.accessibilityHint!) {
      //      let dict = challengeList[index]
      //      performSegue(withIdentifier: "snsList", sender: (dict.userName, dict.profile ?? "", dict.id ?? 0))
      //      let vc = UIStoryboard(name: "SNS", bundle: nil).instantiateViewController(withIdentifier: "userSns") as! UserSnsListViewController
      //
      //
      //      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @objc
  func tapModifyChallenge(_ sender: UIButton) {
    if let index = Int(sender.accessibilityHint!) {
      let dict = challengeList[index]
      performSegue(withIdentifier: "modifyChallenge", sender: dict.id)
    }
  }
  
  @objc
  func tapDeleteChallenge(_ sender: UIButton) {
    if let index = Int(sender.accessibilityHint!) {
      let dict = challengeList[index]
      choiceAlert(message: "인증하신 챌린지를\n삭제하시겠습니까?") {
        self.removeUserChallenge(id: dict.id)
      }
    }
  }
  
  @objc
  func tapLikeButton(_ sender: UIButton) {
    if let index = Int(sender.accessibilityHint!) {
      let dict = challengeList[index]
      if dict.isLike {
        removeUserChallengeLike(id: dict.id)
      } else {
        registUserChallengeLike(id: dict.id)
      }
    }
  }
  
  
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension UserChallengeListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return challengeList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserChallengeListCell
    let dict = challengeList[indexPath.row]
    cell.initWithChallengeList(dict)
    cell.listvc = self
    if userLoginId == dict.userName {
      cell.deleteButton.isHidden = false
      cell.modifyButton.isHidden = false
      
      cell.deleteButton.accessibilityHint = String(indexPath.row)
      cell.modifyButton.accessibilityHint = String(indexPath.row)
      
      cell.deleteButton.addTarget(self, action: #selector(tapDeleteChallenge(_:)), for: .touchUpInside)
      cell.modifyButton.addTarget(self, action: #selector(tapModifyChallenge(_:)), for: .touchUpInside)
    } else {
      cell.deleteButton.isHidden = true
      cell.modifyButton.isHidden = true
    }
    
    if (isCompany ?? false) {
      cell.userNameLabel.isHidden = false
      cell.userNameLabel.text = dict.name
    } else {
      cell.userNameLabel.isHidden = true
    }
    
    cell.userProfileButton.accessibilityHint = String(indexPath.row)
    cell.userProfileButton.addTarget(self, action: #selector(moveToUserSnsList(_:)), for: .touchUpInside)
    
    cell.likeButton.accessibilityHint = String(indexPath.row)
    cell.likeButton.addTarget(self, action: #selector(tapLikeButton(_:)), for: .touchUpInside)
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let dict = challengeList[indexPath.row]
    performSegue(withIdentifier: "detail", sender: dict.id)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let dict = challengeList[indexPath.row]
    
    let width = dict.challengeUserImages.count > 0 ? (UIScreen.main.bounds.width - 50) / 3 : 0
    let height = dict.content.height(withConstrainedWidth: UIScreen.main.bounds.width - 30, font: .systemFont(ofSize: 13, weight: .medium))
    
    return dict.challengeUserImages.count > 0 ? (width + height + 129) : 131
  }
  
  
}
