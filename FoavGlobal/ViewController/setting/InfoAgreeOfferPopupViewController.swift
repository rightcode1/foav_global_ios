//
//  InfoAgreeOfferPopupViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

protocol AgreeOfferDelegate {
  func agree()
}

class InfoAgreeOfferPopupViewController: UIViewController {
  @IBOutlet var registView: UIView!{
    didSet{
      registView.layer.cornerRadius = 10
    }
  }
  @IBOutlet var okBtn: UIButton! {
    didSet{
      okBtn.layer.cornerRadius = 5
    }
  }
  @IBOutlet var cancelBtnUI: UIButton!{
    didSet{
      cancelBtnUI.layer.cornerRadius = 5
    }
  }
  
  var delegate: AgreeOfferDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func tapOk(_ sender: UIButton) {
    backPress()
    delegate?.agree()
  }
}
