//
//  ChallengeDetailViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/03.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit
import Kingfisher
import YoutubePlayer_in_WKWebView

class ChallengeDetailViewController: BaseViewController {
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var contentStackView: UIStackView!
  
  @IBOutlet weak var contentDiffButton: UIButton!
  @IBOutlet weak var challengeDiffButton: UIButton!
  
  @IBOutlet weak var bannerBackView: UIView!
  @IBOutlet weak var bannerImageView: UIImageView!
  
  @IBOutlet weak var youtubeBackView: UIView!
  @IBOutlet weak var youtubeView: WKYTPlayerView!
  @IBOutlet weak var linkView: UIView!
  
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var dDayLabel: UILabel!
  @IBOutlet weak var peopleCountLabel: UILabel!
  
  @IBOutlet weak var missionNameLabel: UILabel!
  @IBOutlet weak var wayLabel: UILabel!
  @IBOutlet weak var dateLabel2: UILabel!
  
  @IBOutlet weak var needPeopleCountLabel: UILabel!
  @IBOutlet weak var memberLabel: UILabel!
  @IBOutlet weak var addInfoLabel: UILabel!
  
  @IBOutlet weak var goChallengeButton: UIButton!
  @IBOutlet weak var isMoreView: UIView!
  @IBOutlet weak var isMoreButton: UIButton!{
    didSet{
      isMoreButton.layer.cornerRadius = 5
      isMoreButton.layer.borderWidth = 1
      isMoreButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
  }
  
  let cellIdentifier = "UserChallengeListCell"
  
  
  let date = Date()
  let dateFormatter = DateFormatter()
  
  var userId: Int?
  var companyId: Int?
  var userLoginId: String?
  
  var isCompany: Bool?
  
  var id: Int?
  
  var isLimit: Bool = true
  
  var isEnd: Bool = false
  
  var isIntroduce: Bool = true
  
  var addChallengeDataCallCount: Int = 1
  
  var challengeDataCallMaximumCount: Int = 0
  
  var challengeList: [ChallengeUserList] = []
  
  var bannerUrl: String?
  var bannerImageUrl: String?
  
  var videoId: String?
  var link: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    clearImageCache()
    initDiffButton()
    tableView.delegate = self
    tableView.dataSource = self
    //    tableView.prefetchDataSource = self
    
    registerXib()
    
    print("companyId : \(companyId ?? 0)")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    addChallengeDataCallCount = 1
    
    getChallengeDetail()
    addChallengeListData()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if segue.identifier == "registChallenge", let vc = segue.destination as? RegistChallengeViewController {
//      vc.id = id
//      vc.isModify = false
//    }
//
//    if segue.identifier == "modifyChallenge", let vc = segue.destination as? RegistChallengeViewController, let userChallengeId = sender as? Int {
//      vc.id = id
//      vc.challengeUserId = userChallengeId
//      vc.isModify = true
//    }
//
//    if segue.identifier == "detail", let vc = segue.destination as? ChallengeCommentDetailViewController, let userChallengeId = sender as? Int {
//      vc.userChallengeId = userChallengeId
//      vc.userId = userId
//      vc.userLoginId = userLoginId
//      vc.isCompany = isCompany
//      vc.companyId = companyId
//    }
//
//    if segue.identifier == "list", let vc = segue.destination as? UserChallengeListViewController {
//      vc.id = id
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
  
  func initSelectedButton(_ button: UIButton) {
    button.backgroundColor = #colorLiteral(red: 0.9988905787, green: 0.7325363755, blue: 0.01344237383, alpha: 1)
    button.layer.borderWidth = 0
    button.setTitleColor(.white, for: .normal)
  }
  
  func initNormalButton(_ button: UIButton) {
    button.backgroundColor = .white
    button.layer.borderWidth = 1
    button.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    button.setTitleColor(.black, for: .normal)
  }
  
  func initDiffButton() {
    if isIntroduce {
      initSelectedButton(contentDiffButton)
      initNormalButton(challengeDiffButton)
    } else {
      initSelectedButton(challengeDiffButton)
      initNormalButton(contentDiffButton)
    }
  }
  
  func reloadRows(index: Int) {
    let indexPath = IndexPath(row: index, section: 0)
    tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
  func initWithDetailData(_ data: ChallengeDetail) {
    let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(data.thumbnail ?? "")")
    thumbnailImageView.kf.setImage(with: url)
    
    bannerBackView.isHidden = data.banner == nil
    bannerUrl = data.url
    bannerImageUrl = "\(ApiEnvironment.baseUrl)/img/\(data.bannerDetail ?? "")"
    
    if let bannerUrl = URL(string: "\(ApiEnvironment.baseUrl)/img/\(data.banner ?? "")") {
      bannerImageView.kf.setImage(with: bannerUrl)
    }
    
    titleLabel.text = data.title
    dateLabel.text = "\(data.startDate) ~ \(data.endDate)"
    dateLabel2.text = "\(data.startDate) ~ \(data.endDate)"
    dDayLabel.text = data.dDay > 0 ? "D-\(data.dDay)" : "End"
    missionNameLabel.text = data.mission
    wayLabel.text = data.way
    needPeopleCountLabel.text = data.people
    memberLabel.text = data.condition
    addInfoLabel.text = data.note
    videoId = data.youtube
    
    if data.youtube != nil && data.youtube != "" && isIntroduce {
      youtubeBackView.isHidden = false
      let playvarsDic = ["controls": 1, "playsinline": 1, "autohide": 1, "autoplay": 1, "modestbranding": 0]
      youtubeView.load(withVideoId: data.youtube!, playerVars: playvarsDic)
    } else {
      youtubeBackView.isHidden = true
    }
    
    link = data.link ?? ""
    linkView.isHidden = data.link == nil ? true : false
    
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: date)
    if Int(today.components(separatedBy: "-").joined())! < Int(data.startDate.components(separatedBy: "-").joined())! ||
        Int(today.components(separatedBy: "-").joined())! > Int(data.endDate.components(separatedBy: "-").joined())! {
      goChallengeButton.isHidden = true
    } else {
      goChallengeButton.isHidden = false
    }
    
  }
  
  func setTableViewHeight() {
    if challengeList.count > 0 && !isIntroduce {
      let imageList = challengeList.filter{ $0.challengeUserImages.count > 0 }
      let noImageList = challengeList.filter{ $0.challengeUserImages.count <= 0 }
      var textHeight: CGFloat = 0
      
      
      for i in 0..<challengeList.count {
        let dict = challengeList[i]
        let width = dict.challengeUserImages.count > 0 ? (UIScreen.main.bounds.width - 50) / 3 : 0
        let height = dict.content.height(withConstrainedWidth: UIScreen.main.bounds.width - 30, font: .systemFont(ofSize: 13, weight: .medium))
        textHeight += (height + width)
      }
      
      tableViewHeight.constant = CGFloat((129 * imageList.count) + (131 * noImageList.count)) + textHeight + 55
    } else {
      tableViewHeight.constant = 45
    }
  }
  
  
  func getChallengeDetail() {
    ApiService.request(router: CarbonLivingApi.challengeDetail(id: id ?? 0), success: { (response: ApiResponse<ChallengeDetailResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.initWithDetailData(value.data)
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류 입니다./n다시 시도해주세요.")
    }
  }
  
  func addChallengeListData(isRefresh: Bool = false) {
    self.showHUD()
    let param = ChallengeUserListRequest(page: addChallengeDataCallCount, limit: 5, challengeId: id ?? 0)
    ApiService.request(router: CarbonLivingApi.challengeUserList(param: param), success: { (response: ApiResponse<ChallengeUserListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.peopleCountLabel.text = "\(value.list.count)명"
        
        if self.addChallengeDataCallCount == 1 {
          self.challengeList.removeAll()
          self.challengeList = value.list.rows
        } else {
          self.challengeList += value.list.rows
        }
        
        self.tableView.reloadData()
        self.setTableViewHeight()
        
        if value.list.count > 15 && self.challengeList.count < value.list.count {
          self.isMoreView.isHidden = false
        } else {
          self.isMoreView.isHidden = true
        }
        
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
  
  func removeUserChallenge(id: Int, index: Int) {
    
    ApiService.request(router: CarbonLivingApi.challengeUserRemove(id: id), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      
      if value.result {
        self.okActionAlert(message: "삭제되었습니다.") {
          self.challengeList.remove(at: index)
          self.tableView.reloadData()
        }
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류 입니다./n다시 시도해주세요.")
    }
  }
  
  func registUserChallengeLike(id: Int, index: Int) {
    ApiService.request(router: CarbonLivingApi.registUserChallengeLike(challengeUserId: id), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.challengeList[index].isLike = true
        self.challengeList[index].like += 1
        self.reloadRows(index: index)
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류 입니다./n다시 시도해주세요.")
    }
  }
  
  func removeUserChallengeLike(id: Int, index: Int) {
    ApiService.request(router: CarbonLivingApi.removeUserChallengeLike(challengeUserId: id), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.challengeList[index].isLike = false
        if self.challengeList[index].like > 0 {
          self.challengeList[index].like -= 1
        }
        self.reloadRows(index: index)
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
        self.removeUserChallenge(id: dict.id, index: index)
      }
    }
  }
  
  @objc
  func tapLikeButton(_ sender: UIButton) {
    if let index = Int(sender.accessibilityHint!) {
      let dict = challengeList[index]
      if dict.isLike {
        removeUserChallengeLike(id: dict.id, index: index)
      } else {
        registUserChallengeLike(id: dict.id, index: index)
      }
    }
  }
  
  @IBAction func tapBanner(_ sender: UIButton) {
    if bannerUrl == nil {
      let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "advertisementVC") as! AdvertisementViewController
      
      vc.imageUrl = bannerImageUrl ?? ""
      self.navigationController?.pushViewController(vc, animated: true)
    } else {
      if let url = URL(string: bannerUrl!) {
        UIApplication.shared.open(url, options: [:])
      }
    }
  }
  
  @IBAction func tapMore(_ sender: UIButton) {
    self.addChallengeDataCallCount += 1
    self.addChallengeListData()
  }
  
  @IBAction func tabShowLink(_ sender: UIButton) {
    if let url = URL(string: link ?? "") {
      UIApplication.shared.open(url, options: [:])
    }
  }
  
  @IBAction func tapIntroduce(_ sender: UIButton) {
    isIntroduce = true
    
    contentStackView.isHidden = false
    if videoId != nil && videoId != "" {
      youtubeBackView.isHidden = false
    } else {
      youtubeBackView.isHidden = true
    }
    
    initDiffButton()
    tableView.isHidden = true
    isMoreView.isHidden = true
    
    tableViewHeight.constant = 45
  }
  
  @IBAction func tapList(_ sender: UIButton) {
    if isIntroduce {
      isIntroduce = false
      
      
      initDiffButton()
      contentStackView.isHidden = true
      youtubeBackView.isHidden = true
      tableView.isHidden = false
      addChallengeListData()
    }
  }
}

extension ChallengeDetailViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let height: CGFloat = scrollView.frame.size.height
    let contentYOffset: CGFloat = scrollView.contentOffset.y
    let scrollViewHeight: CGFloat = scrollView.contentSize.height
    let distanceFromBottom: CGFloat = scrollViewHeight - contentYOffset
    
    //    if distanceFromBottom < height && !isIntroduce && !isEnd {
    //      self.addChallengeListData()
    //    }
  }
}
// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChallengeDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return challengeList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! UserChallengeListCell
    let dict = challengeList[indexPath.row]
    
    cell.vc = self
    cell.initWithChallengeList(dict)
    
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat  {
    let dict = challengeList[indexPath.row]
    
    let width = dict.challengeUserImages.count > 0 ? (UIScreen.main.bounds.width - 50) / 3 : 0
    let height = dict.content.height(withConstrainedWidth: UIScreen.main.bounds.width - 30, font: .systemFont(ofSize: 13, weight: .medium))
    
    return dict.challengeUserImages.count > 0 ? (width + height + 129) : 131
  }
  
  
}

// MARK: - UITableViewDataSourcePrefetching
extension ChallengeDetailViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    print("prefetchRowsAt \(indexPaths)")
    
    for indexPath in indexPaths {
      //      if challengeList.count == indexPath.row {
      //        self.addChallengeListData()
      //      }
    }
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    print("cancelPrefetchingForRowsAt \(indexPaths)")
  }
}
