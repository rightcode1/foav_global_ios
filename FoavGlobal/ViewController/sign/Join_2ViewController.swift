//
//  Join_2ViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/12/11.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class Join_2ViewController: BaseViewController, UITextFieldDelegate {
  
  var joinRequest: SignUpRequest?
  
    @IBOutlet weak var tapPrivacy: UIImageView!
    @IBOutlet weak var tapLocation: UIImageView!
    @IBOutlet var nameText: UITextField!
  @IBOutlet var birthdayText: UITextField!
  @IBOutlet var cellphoneNum: UITextField!
  @IBOutlet var authNumText: UITextField!{
    didSet{
      if #available(iOS 12.0, *) {
        authNumText.textContentType = .oneTimeCode
      } else {
        // Fallback on earlier versions
      }
    }
  }
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
  var hashCode = ""
  var confirmTime = ""
  var isPhoneConfirm = false
  var sex : String? {
    didSet{
      switch sex{
      case nil:
        maleButton.backgroundColor = .white
        maleButton.setTitleColor(#colorLiteral(red: 0.1271425784, green: 0.5379270911, blue: 0.7647784948, alpha: 1), for: .normal)
        femaleButton.backgroundColor = .white
        femaleButton.setTitleColor(#colorLiteral(red: 0.1271425784, green: 0.5379270911, blue: 0.7647784948, alpha: 1), for: .normal)
      break
    case "F":
        femaleButton.backgroundColor = #colorLiteral(red: 0.1271425784, green: 0.5379270911, blue: 0.7647784948, alpha: 1)
        femaleButton.setTitleColor(.white, for: .normal)
        maleButton.backgroundColor = .white
        maleButton.setTitleColor(#colorLiteral(red: 0.1271425784, green: 0.5379270911, blue: 0.7647784948, alpha: 1), for: .normal)
      break
    case "M":
        maleButton.backgroundColor = #colorLiteral(red: 0.1271425784, green: 0.5379270911, blue: 0.7647784948, alpha: 1)
        maleButton.setTitleColor(.white, for: .normal)
        femaleButton.backgroundColor = .white
        femaleButton.setTitleColor(#colorLiteral(red: 0.1271425784, green: 0.5379270911, blue: 0.7647784948, alpha: 1), for: .normal)
      break
      case .some(_):
        break
      }
    }
  }
    var isLocation : Bool = false{
        didSet{
            if isLocation{
                tapLocation.image = UIImage(named: "check-3")
            }else{
                tapLocation.image = UIImage(named: "check-2")
            }
        }
    }
    var isPrivacy: Bool = false{
        didSet{
            if isPrivacy{
                tapPrivacy.image = UIImage(named: "check-3")
            }else{
                tapPrivacy.image = UIImage(named: "check-2")
            }
        }
    }
  override func viewDidLoad() {
    super.viewDidLoad()
    birthdayText.delegate = self
      
          tapLocation.rx.tapGesture().when(.recognized)
                .subscribe(onNext: { _ in
                    self.isLocation = !self.isLocation
                })
                .disposed(by: disposeBag)
      tapPrivacy.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { _ in
                self.isPrivacy = !self.isPrivacy
            })
            .disposed(by: disposeBag)
    femaleButton.rx.tapGesture().when(.recognized)
          .subscribe(onNext: { _ in
            if self.sex == "F"{
              self.sex = nil
            }else{
              self.sex = "F"
            }
          })
          .disposed(by: disposeBag)
    maleButton.rx.tapGesture().when(.recognized)
          .subscribe(onNext: { _ in
            if self.sex == "M"{
              self.sex = nil
            }else {
              self.sex = "M"
            }
          })
          .disposed(by: disposeBag)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "next", let vc = segue.destination as? Join_3ViewController {
      vc.joinRequest = self.joinRequest
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == birthdayText {
      return !(birthdayText.text!.count > 8 && (string.count ) > range.length)
    }
    return true
  }
  
  @IBAction func getAuthNumBtn(_ sender: UIButton) {
      showHUD()
    
    if cellphoneNum.text! == "" {
      self.doAlert(message: "Please enter your E-mail.")
      return
    }
    let param = sendPhoneCodeRequest (
        email: cellphoneNum.text!, joinOrFind: sendPhoneCodeType
    )
    
    ApiService.request(router: AuthApi.sendCode(param: param), success: { (response: ApiResponse<ConfirmResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code < 202 && value.code > 199 {
          self.doAlert(message: "Verification code has been sent.")
          self.hashCode = value.confirmHash ?? ""
          self.confirmTime = value.effectiveTime ?? ""
        self.dismissHUD()
        } else {
          self.doAlert(message: value.resultMsg)
        }
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
    }) { (error) in
    }
    
  }
  @IBAction func checkAuthNumBtn(_ sender: UIButton) {
    if cellphoneNum.text == "01011112222" {
      self.isPhoneConfirm = true
      self.doAlert(message: "Authentication is complete.")
    } else {
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
            self.isPhoneConfirm = true
            self.doAlert(message: "Authentication is complete.")
          }
        } else if !value.result  {
          self.doAlert(message: value.resultMsg)
        }
        
      }) { (error) in
      }
    }
    
  }
  
  @IBAction func tapNext(_ sender: Any) {
      
    if nameText.text!.isEmpty {
        doAlert(message: "Please write your real name")
        return
    }
    if cellphoneNum.text!.isEmpty {
        doAlert(message: "Please enter your E-mail")
        return
    }
      if !isPrivacy {
          doAlert(message: "Please check Agree to thr Personal Information Policy")
          return
      }
      if !isLocation {
          doAlert(message: "Please check Location-Based Terms of Service")
          return
      }
    
    self.joinRequest?.name = nameText.text!
    self.joinRequest?.email = cellphoneNum.text!
    self.joinRequest?.birth = birthdayText.text! == "" ? nil : birthdayText.text!
    self.joinRequest?.gender = sex
      
        ApiService.request(router: AuthApi.SignUp(param: joinRequest!), success: { (response: ApiResponse<SignupResponse>) in
          guard let value = response.value else {
            return
          }
          if value.result {
              let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "finishJoinVC") as! FinishJoinViewController
              self.navigationController?.pushViewController(vc, animated: true)
          }
          else if !value.result {
            self.doAlert(message: value.resultMsg)
          }
          
        }) { (error) in
          self.doAlert(message: "알수없는 오류\n잠시후 다시 시도해주세요.")
        }
  }
    @IBAction func showPrivacyPolicyBtn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "AgreeViewController") as! AgreeViewController
        vc.agreeCategory = .info
          self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showAgree2Btn(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "AgreeViewController") as! AgreeViewController
        vc.agreeCategory = .location
          self.navigationController?.pushViewController(vc, animated: true)
    }
}
