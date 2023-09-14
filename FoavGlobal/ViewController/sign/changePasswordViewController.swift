//
//  changePasswordViewController.swift
//  FOAV
//
//  Created by hoon Kim on 01/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class changePasswordViewController: UIViewController, UIGestureRecognizerDelegate {
  
  @IBOutlet var cellphoneText: UITextField!
  @IBOutlet var authNumText: UITextField!{
    didSet{
      if #available(iOS 12.0, *) {
        authNumText.textContentType = .oneTimeCode
      } else {
        // Fallback on earlier versions
      }
    }
  }
  @IBOutlet var authFailLabel: UILabel!
  
  var hashCode = ""
  var confirmTime = ""
  var auth = false
  var phoneCodeType = "find"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = false
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    
  }
  
  @IBAction func backBtn(_ sender: Any) {
    self.navigationController!.popViewController(animated: true)
  }
  
  @IBAction func moveToNext(_ sender: Any) {
    if auth == false {
      if cellphoneText.text!.isEmpty {
        doAlert(message: "Please enter your e-mail.")
        return
      } else if authNumText.text!.isEmpty {
        doAlert(message: "Please enter your verification code.")
        return
      } else {
        doAlert(message: "Please try again after completing authentication.")
      }
      
      return
    }
    
    
//    let storyBoard = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ChangePWVC") as! changePassword_2ViewController
//    storyBoard.modalPresentationStyle = .fullScreen
//    self.present(storyBoard, animated: true, completion: nil)
    performSegue(withIdentifier: "next", sender: nil)
  }
  
  @IBAction func getAuthNumBtn(_ sender: Any) {
    print(phoneCodeType)
    showHUD()
    if cellphoneText.text! == "" {
      self.doAlert(message: "Please enter your e-mail.")
        dismissHUD()
      return
    }
    let param = sendPhoneCodeRequest (
        email: cellphoneText.text!, joinOrFind: phoneCodeType
    )
    ApiService.request(router: AuthApi.sendCode(param: param), success: { (response: ApiResponse<ConfirmResponse>) in
      
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code == 202 {
          self.doAlert(message: value.resultMsg)
        } else {
          self.doAlert(message: "Verification code has been sent.")
          self.hashCode = value.confirmHash ?? ""
          self.confirmTime = value.effectiveTime ?? ""
        }
          self.dismissHUD()
      } else if !value.result  {
        self.doAlert(message: value.resultMsg)
          self.dismissHUD()
      }
    }) { (error) in
        self.dismissHUD()
    }
    
    
  }
  @IBAction func checkAuthNumBtn(_ sender: Any) {
    
    let param = CheckphoneCodeRequest (
      code: authNumText.text!, codeHash: hashCode, requestTime: confirmTime
    )
    ApiService.request(router: AuthApi.confirm(param: param), success: { (response: ApiResponse<FinighConfirmResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code == 202 {
          self.doAlert(message: value.resultMsg)
        } else {
          self.doAlert(message: "Authentication is complete.")
          self.auth = true
        }
      } else if !value.result  {
        self.authFailLabel.isHidden = false
        self.doAlert(message: value.resultMsg)
      }
    }) { (error) in
      self.doAlert(message: "The verification code format is incorrect")
    }
    
  }
  
}
