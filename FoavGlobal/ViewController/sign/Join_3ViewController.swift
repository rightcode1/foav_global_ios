//
//  Join_3ViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/12/11.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class Join_3ViewController: UIViewController {
  @IBOutlet var emailTextField: UITextField!
  
  @IBOutlet var checkImageView1: UIImageView!
  @IBOutlet var checkImageView2: UIImageView!
  @IBOutlet var checkImageView3: UIImageView!
  var joinRequest: SignUpRequest?
  
  var checkAgree = false
  var checkAgree2 = false
  var checkAgree3 = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("joinRequest : \(joinRequest)")
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "info", let vc = segue.destination as? AgreeViewController {
      vc.agreeCategory = .info
    }
    if segue.identifier == "use", let vc = segue.destination as? AgreeViewController {
      vc.agreeCategory = .use
    }
    if segue.identifier == "location", let vc = segue.destination as? AgreeViewController {
      vc.agreeCategory = .location
    }
  }
  
  func join() {
    joinRequest?.email = emailTextField.text!
    print("joinRequest : \(joinRequest)")
    ApiService.request(router: AuthApi.SignUp(param: joinRequest!), success: { (response: ApiResponse<SignupResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        let dateFormmater = DateFormatter()
        dateFormmater.dateFormat = "yyyy.MM.dd"
        DataHelper.set(dateFormmater.string(from: Date()), forKey: .joinDate)
        self.performSegue(withIdentifier: "finish", sender: nil)
      }
      else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류\n잠시후 다시 시도해주세요.")
    }
  }
  
  
  @IBAction func showPrivacyPolicyBtn(_ sender: UIButton) {
    performSegue(withIdentifier: "info", sender: nil)
  }
  
  @IBAction func showAgree1Btn(_ sender: UIButton) {
    performSegue(withIdentifier: "use", sender: nil)
  }
  
  @IBAction func showAgree2Btn(_ sender: UIButton) {
    performSegue(withIdentifier: "location", sender: nil)
  }
  
  @IBAction func checkAgreeBtn(_ sender: UIButton) {
    if sender.isSelected {
      sender.isSelected = false
      checkAgree = false
      checkImageView2.image = #imageLiteral(resourceName: "check-2")
    } else {
      sender.isSelected = true
      checkAgree = true
      checkImageView1.image = #imageLiteral(resourceName: "check-3")
    }
  }
  
  @IBAction func checkAgree2Btn(_ sender: UIButton) {
    if sender.isSelected {
      sender.isSelected = false
      checkAgree2 = false
      checkImageView2.image = #imageLiteral(resourceName: "check-2")
    } else {
      sender.isSelected = true
      checkAgree2 = true
      checkImageView2.image = #imageLiteral(resourceName: "check-3")
    }
  }
  
  @IBAction func checkAgree3Btn(_ sender: UIButton) {
    if sender.isSelected {
      sender.isSelected = false
      checkAgree3 = false
      checkImageView3.image = #imageLiteral(resourceName: "check-2")
    } else {
      sender.isSelected = true
      checkAgree3 = true
      checkImageView3.image = #imageLiteral(resourceName: "check-3")
    }
  }
  
  @IBAction func tapOk(_ sender: UIButton) {
    if emailTextField.text!.isEmpty {
        doAlert(message: "이메일을 입력해주세요.")
        return
    }
    if !checkAgree {
      doAlert(message: "개인정보 처리방침 동의를 진행해주세요.")
      return
    }
    if !checkAgree2 {
      doAlert(message: "이용약관 동의를 진행해주세요.")
      return
    }
    if !checkAgree3 {
      doAlert(message: "위치기반 서비스 이용 동의를 진행해주세요.")
      return
    }
    
    join()
  }
}
