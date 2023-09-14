//
//  ChallengeCommentDetailViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/04/13.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class ChallengeCommentDetailViewController: UIViewController {
  
  @IBOutlet weak var userImageView: UIImageView!
  
  @IBOutlet var imageBackView1: UIView!
  @IBOutlet var imageBackView2: UIView!
  
  @IBOutlet var detailImageView1: UIImageView! {
    didSet{
      detailImageView1.layer.cornerRadius = 12
    }
  }
  @IBOutlet var detailImageView2: UIImageView!{
    didSet{
      detailImageView2.layer.cornerRadius = 12
    }
  }
  @IBOutlet var detailImageView3: UIImageView!{
    didSet{
      detailImageView3.layer.cornerRadius = 12
    }
  }
  @IBOutlet var detailImageView4: UIImageView! {
    didSet{
      detailImageView4.layer.cornerRadius = 12
    }
  }
  @IBOutlet var detailImageView5: UIImageView!{
    didSet{
      detailImageView5.layer.cornerRadius = 12
    }
  }
  @IBOutlet var detailImageView6: UIImageView!{
    didSet{
      detailImageView6.layer.cornerRadius = 12
    }
  }
  
  @IBOutlet weak var tableView: UITableView!{
    didSet{
      tableView.delegate = self
      tableView.dataSource = self
    }
  }
  @IBOutlet var tableViewHeight: NSLayoutConstraint!
  
  @IBOutlet var imageCountLabel: UILabel!{
    didSet{
      imageCountLabel.clipsToBounds = true
      imageCountLabel.layer.cornerRadius = imageCountLabel.frame.height / 2
    }
  }
  
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var nickNameLabel: UILabel!
  
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var wishCountLabel: UILabel!
  @IBOutlet var commentLabel: UILabel!
  
  @IBOutlet var contentLabel: UILabel!
  
  @IBOutlet var commentView: UIView!
  @IBOutlet var commentNickNameLabel: UILabel!
  @IBOutlet var commentDateLabel: UILabel!
  @IBOutlet var commentContentTextView: UITextView!{
    didSet{
      commentContentTextView.delegate = self
    }
  }
  @IBOutlet var registButton: UIButton!{
    didSet{
      registButton.layer.cornerRadius = 8
    }
  }
  
  @IBOutlet var isWishButton: UIButton!
  @IBOutlet var rightBarButtonItem: UIBarButtonItem!
  @IBOutlet var moreReviewButtonView: UIView!
  
  let cellIdentifier: String = "SnsCommentListCell"
  
  var videoId: String = ""
  var youtubeUrl: String = ""
  var userLoginId: String?
  
  var companyId: Int?
  
  var isCompany: Bool?
  
  var userChallengeId: Int?
  var userId: Int?
  
  var isWish: Bool = false
  
  var commentList: [ChallengeUserCommentList] = []
  
  var imageList: [Image] = []
  
  var date = Date()
  let dateformatter = DateFormatter()
  
  var htmlText: String?
  
  var isTag: Bool = false
  
  var beforeIsTagContentTextCount: Int?
  var contentTextCount: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    commentNickNameLabel.text = userLoginId
    dateformatter.dateFormat = "yyyy.MM.dd"
    commentDateLabel.text = dateformatter.string(from: date)
    
    registerXib()
    initCommentView()
    getUserChallengeDetail()
    getUserChallengeCommentList(isMore: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    self.tableViewHeight.constant = self.tableView.contentSize.height
  }
  
  private func registerXib() {
    let nibName = UINib(nibName: cellIdentifier, bundle: nil)
    tableView.register(nibName, forCellReuseIdentifier: cellIdentifier)
  }
  
  func initCommentView() {
    commentView.layer.cornerRadius = 8
    if commentContentTextView.text.isEmpty {
      commentView.layer.borderColor = #colorLiteral(red: 0.9278690733, green: 0.9278690733, blue: 0.9278690733, alpha: 1)
      commentView.layer.borderWidth = 1
    } else {
      commentView.layer.borderColor = #colorLiteral(red: 0.09076217562, green: 0.5362609625, blue: 0.7687024474, alpha: 1)
      commentView.layer.borderWidth = 2
    }
  }
  
  func initWithDetail(_ data: ChallengeUserDetail) {
    if data.profile == "" {
      self.userImageView.layer.cornerRadius = 0
      self.userImageView.image = #imageLiteral(resourceName: "icon_profile")
    } else {
      self.userImageView.layer.cornerRadius = self.userImageView.layer.bounds.width / 2
      self.userImageView.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/\(data.profile)"))
    }
    
    nameLabel.text = data.name
    nameLabel.isHidden = (isCompany ?? false) ? false : true
    
    nickNameLabel.text = data.userName
    dateLabel.text = data.createdAt
    
    wishCountLabel.text = "\(data.like)"
    commentLabel.text = "\(data.commentCount)"
    
    contentLabel.text = data.content
    
    if data.isLike {
      isWish = true
      isWishButton.setImage(#imageLiteral(resourceName: "heart_full"), for: .normal)
    } else {
      isWish = false
      isWishButton.setImage(#imageLiteral(resourceName: "heart_blank"), for: .normal)
    }
    
    imageList = data.challengeUserImages
    
    imageBackView1.isHidden = imageList.count <= 0
    imageBackView2.isHidden = imageList.count <= 3

    if imageList.count == 1 {
      detailImageView1.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[0].name))
    } else if imageList.count == 2 {
      detailImageView1.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[0].name))
      detailImageView2.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[1].name))
    } else if imageList.count == 3 {
      detailImageView1.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[0].name))
      detailImageView2.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[1].name))
      detailImageView3.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[2].name))
    } else if imageList.count == 4 {
      detailImageView1.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[0].name))
      detailImageView2.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[1].name))
      detailImageView3.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[2].name))
      detailImageView4.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[3].name))
    } else if imageList.count == 5 {
      detailImageView1.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[0].name))
      detailImageView2.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[1].name))
      detailImageView3.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[2].name))
      detailImageView4.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[3].name))
      detailImageView5.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[4].name))
    } else if imageList.count == 6 {
      detailImageView1.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[0].name))
      detailImageView2.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[1].name))
      detailImageView3.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[2].name))
      detailImageView4.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[3].name))
      detailImageView5.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[4].name))
      detailImageView6.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/" + imageList[5].name))
    }
    imageCountLabel.text = "1/\(imageList.count)"
  }
  
  func showDetailImage(imageURL: String) {
    let vc = UIStoryboard(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "reviewImageVC") as! ShowReviewImageViewController
    vc.imageUrl = imageURL
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .crossDissolve
    self.present(vc, animated: true)
  }
  
  // 디테일 데이터
  func getUserChallengeDetail() {
    ApiService.request(router: CarbonLivingApi.challengeUserDetail(id: userChallengeId ?? 0), success: { (response: ApiResponse<ChallengeUserDetailResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.initWithDetail(value.data)
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  // 댓글 리스트
  func getUserChallengeCommentList(isMore: Bool) {
    ApiService.request(router: CarbonLivingApi.challengeUserCommentList(challengeUserId: userChallengeId ?? 0), success: { (response: ApiResponse<ChallengeUserCommentListResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.commentList = value.list
          
          if self.commentList.count <= 0 {
            self.moreReviewButtonView.isHidden = true
            self.tableViewHeight.constant = 0
          } else {
            if isMore {
              self.moreReviewButtonView.isHidden = true
              self.tableView.reloadData()
              self.tableViewHeight.constant = self.tableView.contentSize.height
              
            } else {
              if self.commentList.count > 3 {
                self.moreReviewButtonView.isHidden = false
              } else {
                self.moreReviewButtonView.isHidden = true
              }
              
              var commentListIndex: Int = 0
              for i in 0..<self.commentList.count {
                if i > 3 {
                  commentListIndex += 1
                }
              }
              
              if commentListIndex > 0 {
                for _ in 0..<commentListIndex {
                  self.commentList.removeLast()
                }
              }
              
              self.tableView.reloadData()
              self.tableViewHeight.constant = self.tableView.contentSize.height
            }
            
            print("self.tableView.contentSize.height: \(self.tableView.contentSize.height)")
          }
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  // 좋아요 보내기
  func registWish() {
    ApiService.request(router: CarbonLivingApi.challengeUserRegistWish(challengeUserId: userChallengeId ?? 0), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.getUserChallengeDetail()
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  func removeWish() {
    ApiService.request(router: CarbonLivingApi.challengeUserRemoveWish(challengeUserId: userChallengeId ?? 0), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.getUserChallengeDetail()
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  // 댓글 등록
  func registComment(content: String) {
    ApiService.request(router: CarbonLivingApi.challengeUserCommentRegist(content: content, challengeUserId: userChallengeId ?? 0), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.okActionAlert(message: "리뷰가 등록되었습니다.") {
            self.commentContentTextView.text = ""
            self.getUserChallengeCommentList(isMore: false)
          }
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  // 댓글 삭제
  func removeComment(commentId: Int) {
    ApiService.request(router: CarbonLivingApi.challengeUserCommentRemove(commentId: commentId), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.okActionAlert(message: "댓글이 삭제되었습니다.") {
            self.getUserChallengeCommentList(isMore: false)
          }
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  // 댓글 좋아요
  
  func registCommentWish(commentId: Int) {
    ApiService.request(router: CarbonLivingApi.challengeUserCommentRegistWish(challengeUserCommentId: commentId), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.getUserChallengeCommentList(isMore: true)
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  func removeCommentWish(commentId: Int) {
    ApiService.request(router: CarbonLivingApi.challengeUserCommentRemoveWish(challengeUserCommentId: commentId), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.getUserChallengeCommentList(isMore: true)
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  @objc
  func modifyComment(_ sender: UIButton) {
    if let index = Int(sender.accessibilityHint!) {
      let dict = commentList[index]
      let vc = UIStoryboard(name: "SNS", bundle: nil).instantiateViewController(withIdentifier: "commentPopup") as! CommentManagementPopupViewController
      vc.commentId = dict.id
      vc.content = dict.content
      vc.commentDelegate = self
      vc.modalTransitionStyle = .crossDissolve
      vc.modalPresentationStyle = .overCurrentContext
      
      present(vc, animated: true)
    }
  }
  
  @objc
  func likeComment(_ sender: UIButton) {
    if let index = Int(sender.accessibilityHint!) {
      let dict = commentList[index]
      if dict.isWish {
        removeCommentWish(commentId: dict.id)
      } else {
        registCommentWish(commentId: dict.id)
      }
    }
  }
  
  @IBAction func tapImage1(_ sender: UIButton) {
    if imageList.count >= 1 {
      showDetailImage(imageURL: "\(ApiEnvironment.baseUrl)/img/" + imageList[0].name)
    }
  }
  @IBAction func tapImage2(_ sender: UIButton) {
    if imageList.count >= 2 {
      showDetailImage(imageURL: "\(ApiEnvironment.baseUrl)/img/" + imageList[1].name)
    }
  }
  @IBAction func tapImage3(_ sender: UIButton) {
    if imageList.count >= 3 {
      showDetailImage(imageURL: "\(ApiEnvironment.baseUrl)/img/" + imageList[2].name)
    }
  }
  
  @IBAction func tapImage4(_ sender: UIButton) {
    if imageList.count >= 4 {
      showDetailImage(imageURL: "\(ApiEnvironment.baseUrl)/img/" + imageList[3].name)
    }
  }
  @IBAction func tapImage5(_ sender: UIButton) {
    if imageList.count >= 5 {
      showDetailImage(imageURL: "\(ApiEnvironment.baseUrl)/img/" + imageList[4].name)
    }
  }
  @IBAction func tapImage6(_ sender: UIButton) {
    if imageList.count >= 6 {
      showDetailImage(imageURL: "\(ApiEnvironment.baseUrl)/img/" + imageList[5].name)
    }
  }
  
  
  @IBAction func tabWishButton(_ sender: UIButton) {
    if isWish {
      removeWish()
    } else {
      registWish()
    }
  }
  
  @IBAction func tabRegistComment(_ sender: UIButton) {
    
    registComment(content: commentContentTextView.text!)
  }
  
  @IBAction func tabMoreCommentButton(_ sender: UIButton) {
    getUserChallengeCommentList(isMore: true)
  }
  
  @IBAction func tabModifySns(_ sender: Any) {
    
  }
  
}
extension ChallengeCommentDetailViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    initCommentView()
  }
}

extension ChallengeCommentDetailViewController: CommentModifyDelegate {
  func finish() {
    getUserChallengeCommentList(isMore: false)
  }
}

extension ChallengeCommentDetailViewController: CommentDelegate {
  func choice(isModify: Bool, commentId: Int, content: String) {
    if isModify {
      let vc = UIStoryboard(name: "SNS", bundle: nil).instantiateViewController(withIdentifier: "modifyComment") as! ModifySnsCommentViewController
      vc.commentId = commentId
      vc.content = content
      vc.isChallenge = true
      vc.delegate = self
      
      self.navigationController?.pushViewController(vc, animated: true)
    } else {
      removeComment(commentId: commentId)
    }
  }
  
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ChallengeCommentDetailViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commentList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SnsCommentListCell
    let dict = commentList[indexPath.row]
    cell.initWithChallengeUserCommentList(dict)
    cell.backView.layer.cornerRadius = 6
    
    if userId == dict.userId {
      cell.menuButton.accessibilityHint = String(indexPath.row)
      cell.menuButton.addTarget(self, action: #selector(modifyComment(_ :)), for: .touchUpInside)
      cell.menuImageview.isHidden = false
      cell.isMineImageView.isHidden = false
    } else {
      cell.menuImageview.isHidden = true
      cell.isMineImageView.isHidden = true
    }
    
//    cell.tagButton.accessibilityHint = String(indexPath.row)
//    cell.tagButton.addTarget(self, action: #selector(reviewTagId(_ :)), for: .touchUpInside)
    
    cell.likeButton.accessibilityHint = String(indexPath.row)
    cell.likeButton.addTarget(self, action: #selector(likeComment(_ :)), for: .touchUpInside)
    
    
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let dict = commentList[indexPath.row]
    let width = (UIScreen.main.bounds.width - 46)
    let height = dict.content.height(withConstrainedWidth: width, font: .systemFont(ofSize: 15))
    
    return height + 82
  }
  
}
