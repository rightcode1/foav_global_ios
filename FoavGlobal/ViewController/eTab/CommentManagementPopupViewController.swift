//
//  CommentManagementPopupViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/08/27.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

protocol CommentDelegate {
  func choice(isModify: Bool, commentId: Int, content: String)
}

class CommentManagementPopupViewController: UIViewController {
  @IBOutlet var cornerView: UIView!{
    didSet{
      cornerView.layer.cornerRadius = 10
    }
  }
  @IBOutlet var modifyButton: UIButton!{
    didSet{
      modifyButton.layer.cornerRadius = 6
    }
  }
  @IBOutlet var deleteButton: UIButton!{
    didSet{
      deleteButton.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
      deleteButton.layer.borderWidth = 0.5
      deleteButton.layer.cornerRadius = 6
    }
  }
  
  var commentId: Int?
  var content: String? 
  var commentDelegate: CommentDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  @IBAction func tabModify(_ sender: UIButton) {
    backPress()
    commentDelegate?.choice(isModify: true, commentId: commentId ?? 0, content: content ?? "")
  }
  @IBAction func tabDelete(_ sender: UIButton) {
    backPress()
    commentDelegate?.choice(isModify: false, commentId: commentId ?? 0, content: content ?? "")
  }
  
  
}
