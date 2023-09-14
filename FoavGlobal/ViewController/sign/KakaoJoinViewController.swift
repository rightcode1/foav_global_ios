//
//  KakaoJoinViewController.swift
//  FOAV
//
//  Created by hoon Kim on 13/11/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class KakaoJoinViewController: UIViewController {
    @IBOutlet weak var cellphoneNum: UITextField!
    @IBOutlet weak var authNum: UITextField!
    @IBOutlet weak var authFalseLB: UILabel!
    @IBOutlet weak var birthdayText: UITextField!
    @IBOutlet var femaleCheckBtn: UIButton!
    @IBOutlet var maleCheckBtn: UIButton!
    
    var hashCode = ""
    var confirmTime = ""
    var signupType: SignupType = .normal
    // 카카오 정보를 담기위한 변수들
    var kakaoId = ""
    var kakaoTel = ""
    var kakaoName = ""
    var kakaoBirth = ""
    var kakaoGender = ""
    
    var gender = ""
    var femaleCheck = true
    var maleCheck = false
    var checkAgree = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // 생일 입력시 자동으로 - 넣어주는 함수
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == birthdayText {
            if (birthdayText.text!.count == 4 || birthdayText.text!.count == 7) {
                if !(string == "") {
                    birthdayText.text = (birthdayText.text)! + "-"
                }
            }
            return !(birthdayText.text!.count > 9 && (string.count ) > range.length)
        }
        return true
    }
    
    @IBAction func checkAgreeBtn(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            checkAgree = false
        } else {
            sender.isSelected = true
            checkAgree = true
        }
        
    }
    
    @IBAction func femaleBtn(_ sender: Any) {
        gender = "F"
        if maleCheck == true {
            femaleCheckBtn.setImage(#imageLiteral(resourceName: "female"), for: .normal)
            femaleCheck = true
            maleCheckBtn.setImage(#imageLiteral(resourceName: "male2"), for: .normal)
            maleCheck = false
        }
        print("----\(gender)")
    }
    @IBAction func maleBtn(_ sender: UIButton) {
        gender = "M"
        if femaleCheck == true {
            femaleCheckBtn.setImage(#imageLiteral(resourceName: "female2"), for: .normal)
            femaleCheck = false
            maleCheckBtn.setImage(#imageLiteral(resourceName: "male"), for: .normal)
            maleCheck = true
        }
        print("----\(gender)")
    }

    @IBAction func getAuthNumBtn(_ sender: Any) {
        print(sendPhoneCodeType)
        
        if cellphoneNum.text! == "" {
            self.doAlert(message: "핸드폰번호를 입력해주세요.")
            return
        }
        let param = sendPhoneCodeRequest (
            email: cellphoneNum.text!, joinOrFind: sendPhoneCodeType
        )
        ApiService.request(router: AuthApi.sendCode(param: param), success: { (response: ApiResponse<ConfirmResponse>) in
            print("asdfasdf")
            guard let value = response.value else {
                return
            }
            
            if value.result {
                dump(value)
                    self.doAlert(message: "인증번호가 전송되었습니다.")
                    self.hashCode = value.confirmHash ?? ""
                    self.confirmTime = value.effectiveTime ?? ""
            } else if value.code == 202 {
                self.doAlert(message: value.resultMsg)
            } else if !value.result {
                self.doAlert(message: value.resultMsg)
            } else {
                self.doAlert(message: value.resultMsg)
                return
            }
        }) { (error) in
            self.doAlert(message: "전화번호가 비어있거나 형식에 맞지 않습니다.")
        }
        
        
    }
    @IBAction func checkAuthNumBtn(_ sender: Any) {
        let param = CheckphoneCodeRequest (
            code: authNum.text!, codeHash: hashCode, requestTime: confirmTime
        )
        ApiService.request(router: AuthApi.confirm(param: param), success: { (response: ApiResponse<FinighConfirmResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.doAlert(message: "인증이 완료되었습니다.")
            } else if value.code == 202 {
                self.doAlert(message: value.resultMsg)
            } else if !value.result  {
                    self.authFalseLB.isHidden = false
                    self.doAlert(message: value.resultMsg)
            }
            
        }) { (error) in
            self.doAlert(message: "인증번호 형식이 잘못되었습니다")
        }
        
    }
    

    
    @IBAction func finishJoinBtn(_ sender: Any) {
        
        if birthdayText.text!.isEmpty {
            doAlert(message: "생년월일을 입력해주세요.")
            return
        } else if cellphoneNum.text!.isEmpty {
            doAlert(message: "핸드폰번호를 입력해주세요.")
            return
        } else if authNum.text!.isEmpty {
            doAlert(message: "핸드폰번호를 입력해주세요.")
            return
        } else if !checkAgree {
            doAlert(message: "개인정보 처리방침 동의를 진행해주세요.")
            return
        } else {
        let param = KakaoJoinRequest(
            loginId: "kakao\(kakaoId)",
            password: "rightCode_Foav",
            name: kakaoName,
            birth: birthdayText.text!,
            tel: cellphoneNum.text!,
            gender: gender
        )
        ApiService.request(router: AuthApi.kakaoJoin(param: param), success: { (response: ApiResponse<KakaoJoinResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                let param = LoginRequest (
                    loginId: "kakao\(self.kakaoId)" , password: "rightCode_Foav"
                )
                ApiService.request(router: AuthApi.login(param: param), success: { (response: ApiResponse<LoginResponse>) in
                    guard let value = response.value else {
                        return
                    }
                    if value.result {
                        loginid = "kakao\(self.kakaoId)"
                        token = "bearer \(value.token!)"
                        ApiService.request(router: UserApi.userInfo, success: { (response: ApiResponse<UserInfoResponse>) in
                            guard let value = response.value else {
                                return
                            }
                            if value.result {
                                if value.user.type == "담당자" {
                                    self.signupType = .center
                                    
                                    let loginVC1 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC")
                                    loginVC1.modalPresentationStyle = .fullScreen
                                    self.present(loginVC1, animated: true, completion: nil)
                                } else if value.user.type == "일반" {
                                    
                                    self.signupType = .normal
                                    let loginVC2 = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "normalHomeVC")
                                    loginVC2.modalPresentationStyle = .fullScreen
                                    self.present(loginVC2, animated: true, completion: nil)
                                }
                                print("signupType\(self.signupType)")
                            }
                            
                        }) { (error) in
                            self.doAlert(message: "잠시 후 다시 시도해주세요.")
                        }
                    } else {
                        if !value.result {
                            self.doAlert(message: value.resultMsg)
                        }
                    }
                    
                }) { (error) in
                    self.doAlert(message: "잠시 후 다시 시도해주세요.")
                }
            }
            else {
                if !value.result{
                    self.doAlert(message: value.resultMsg)
                }
            }
        }) { (error) in
            self.doAlert(message: "알수없는 오류\n잠시후 다시 시도해주세요")
        }
    }
        
    }
    
    
}
