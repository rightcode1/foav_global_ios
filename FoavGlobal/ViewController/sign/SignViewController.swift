//
//  ViewController.swift
//  FOAV
//
//  Created by hoon Kim on 30/09/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import NotificationCenter

class SignViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var autoLoginUIView: UIView!
    @IBOutlet var iDTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    var signupType: SignupType = .normal
    var kakaoGender = ""
    var goUpdate = false
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiService.request(router: VersionApi.checkVersion, success: {  (response: ApiResponse<CheckVersioinResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                let version = UserDefaults.standard.integer(forKey: "version")
                if version == 0 || version == value.versions.iosGlobal {
                    UserDefaults.standard.set(value.versions.iosGlobal, forKey: "version")
                    
                    self.iDTextField.delegate = self
                    self.PasswordTextField.delegate = self
                    
                    self.registerForKeyboardNotification()
                    self.removeRegisterForKeyboardNotification()
                    
                    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endEditing)))
                    
                    print("version : \(UserDefaults.standard.integer(forKey: "version"))", value.versions.iosGlobal)
                } else if version < value.versions.iosGlobal {
                    self.timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.goUpdateNow), userInfo: nil, repeats: true)
                }
            }
        }) { (error) in
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
//      navigationController?.isNavigationBarHidden = true
    }
  
    // MARK: - TextField 관련 function
    @objc func goUpdateNow() {
        okActionAlert(message: "업데이트가 필요합니다") {
            if let url = URL(string: "https://apps.apple.com/kr/app/%ED%8F%AC%EC%95%84%EB%B8%8C/id1487589886") {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    func registerTextFieldID() {
        iDTextField.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        registerTextFieldID()
        return true
    }
    
    func registerForKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeRegisterForKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide(_ notification: Notification){
        self.view.transform = .identity
    }
    
    @objc func endEditing(){
        registerTextFieldID()
    }
    
    @objc func keyBoardShow(notification: NSNotification){
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        if iDTextField.isEditing == true{
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: iDTextField)
        }
        else if PasswordTextField.isEditing == true{
            keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: PasswordTextField)
        }
        
    }
    
    func keyboardAnimate(keyboardRectangle: CGRect ,textField: UITextField){
        if keyboardRectangle.height > (self.view.frame.height - textField.frame.maxY){
            self.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - keyboardRectangle.height - textField.frame.maxY))
        }
    }
    // MARK: - action obj
    
    @IBAction func foavLoginBtn(_ sender: Any) {
        if iDTextField.text!.isEmpty {
            self.doAlert(message: "아이디를 입력해주세요.")
            return
        } else if PasswordTextField.text!.isEmpty {
            self.doAlert(message: "비밀번호를 입력해주세요.")
            return
        }
        
        // 자동 로그인
        guard let autoLoginId = self.iDTextField.text else { return }
        guard let autoLoginPassword = self.PasswordTextField.text else { return }
        // 유저 티폴트에 로그인 할 값 세팅해주기
        UserDefaults.standard.set(autoLoginId, forKey: "autoLoginId")
        UserDefaults.standard.set(autoLoginPassword, forKey: "autoLoginPassword")
        
        let param = LoginRequest (
            loginId: iDTextField.text!, password: PasswordTextField.text!
        )
        ApiService.request(router: AuthApi.login(param: param), success: { (response: ApiResponse<LoginResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                token = "bearer \(value.token!)"
                let loginVC1 = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                self.registToken()
                loginVC1.modalPresentationStyle = .fullScreen
                self.present(loginVC1, animated: true, completion: nil)
            } else {
                if !value.result {
                    self.doAlert(message: value.resultMsg)
                }
            }
            
        }) { (error) in
            self.doAlert(message: "잠시 후 다시 시도해주세요.")
        }
        
    }
    // 카카오 로그인..

    
    @IBAction func foavJoinBtn(_ sender: Any) {
        
    }
}

