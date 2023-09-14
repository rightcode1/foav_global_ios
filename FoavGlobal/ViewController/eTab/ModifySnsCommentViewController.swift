//
//  ModifySnsCommentViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/08/27.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

protocol CommentModifyDelegate {
  func finish()
}

class ModifySnsCommentViewController: UIViewController {
  @IBOutlet var contentTextView: UITextView!
  
  var commentId: Int?
  var content: String? 
  var isChallenge: Bool = false
  
  var delegate: CommentModifyDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    contentTextView.text = content ?? ""
  }
  
  func updateComment() {
    updateCommentId = commentId ?? 0
    ApiService.request(router: SnsApi.updateSnsComment(content: contentTextView.text ?? ""), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.okActionAlert(message: "수정이 완료되었습니다.") {
            self.backPress()
            self.delegate?.finish()
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
  
  func updateChallengeComment() {
    updateIdWithApi = commentId ?? 0
    ApiService.request(router: CarbonLivingApi.challengeUserCommentModify(content: contentTextView.text ?? ""), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.okActionAlert(message: "수정이 완료되었습니다.") {
            self.backPress()
            self.delegate?.finish()
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
  
  @IBAction func tabRegist(_ sender: UIButton) {
    if contentTextView.text.isEmpty {
      self.doAlert(message: "내용을 입력해 주세요.")
      return
    } else {
      if isChallenge {
        updateChallengeComment()
      } else {
        updateComment()
      }
     
    }
    
  }
  
}
