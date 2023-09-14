//
//  Join_1ViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/12/11.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class Join_1ViewController: UIViewController {
  @IBOutlet var JoinIdText: UITextField!
  @IBOutlet var joinPasswordText: UITextField!
  @IBOutlet var checkPasswordText: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.navigationBar.isHidden = false
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "next", let vc = segue.destination as? Join_2ViewController {
      let request = SignUpRequest(loginId: JoinIdText.text!, password: joinPasswordText.text!)
      vc.joinRequest = request
    }
  }
  
  @IBAction func checkOverlapID(_ sender: UIButton) {
      if JoinIdText.text!.count < 7 || JoinIdText.text!.count > 20{
          doAlert(message: "Please enter your ID between 6 and 20 letters and numbers.")
      } else {
          let param = CheckloginId (
              loginId: JoinIdText.text!
          )
          ApiService.request(router: AuthApi.checkId(id: param), success: { (response: ApiResponse<CheckIdResponse>) in
              guard let value = response.value else {
                  return
              }
              if value.result {
                  self.doAlert(message: "This ID is usable.")
              } else if !value.result {
                  self.doAlert(message: value.resultMsg)
              }
          }) { (error) in
              self.doAlert(message: "The ID is duplicated or formatted incorrectly.")
          }
      }
  }
  
  @IBAction func tapNext(_ sender: Any) {
    if JoinIdText.text!.isEmpty {
        doAlert(message: "Please enter your ID")
        return
    }
    if JoinIdText.text!.count < 6 || JoinIdText.text!.count > 20 {
        doAlert(message: "Please enter your ID between 6 and 20 letters and numbers.")
        return
    }
    if !JoinIdText.text!.isIdValidate() {
        doAlert(message: "Please enter your ID in the correct format.")
        return
    }
    if joinPasswordText.text!.isEmpty {
        doAlert(message: "Please enter a password.")
        return
    }
    if checkPasswordText.text!.isEmpty {
        doAlert(message: "Please enter a password.")
        return
    }
    if joinPasswordText.text!.count < 8 || joinPasswordText.text!.count > 13 {
        doAlert(message: "Please enter a password between 8 and 13 characters. ")
        return
    }
    if checkPasswordText.text != joinPasswordText.text {
        doAlert(message: "Your password has been entered differently.")
        return
    }
    if !joinPasswordText.text!.isPasswordValidate() {
        doAlert(message: "Please enter your password in the correct format.")
        return
    }
    
    performSegue(withIdentifier: "next", sender: nil)
  }
  
}
