//
//  JoinViewController.swift
//  FOAV
//
//  Created by hoon Kim on 30/09/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import NotificationCenter
import IQKeyboardManagerSwift


class JoinViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var inputViewBottomAnchor: NSLayoutConstraint!
  @IBOutlet var JoinIdText: UITextField!
  @IBOutlet var joinPasswordText: UITextField!
  @IBOutlet var checkPasswordText: UITextField!
  @IBOutlet var nameText: UITextField!
  @IBOutlet var birthdayText: UITextField!
  @IBOutlet var cellphoneNum: UITextField!
  @IBOutlet weak var AgreeBtnUI: UIButton!
  
  @IBOutlet var authNumText: UITextField!{
    didSet{
      if #available(iOS 12.0, *) {
        authNumText.textContentType = .oneTimeCode
      } else {
        // Fallback on earlier versions
      }
    }
  }
  
  @IBOutlet var femaleCheckBtn: UIButton!
  @IBOutlet var maleCheckBtn: UIButton!
  @IBOutlet var emailText: UITextField!
  
  var femaleCheck = true
  var maleCheck = false
  var authNumber = "123456"
  var overlapID = "hoon"
  var gender = "F"
  var checkAgree = false
  var checkAgree2 = false
  var checkAgree3 = false
  
  private var phoneCode = -1
  private var isPhoneConfirm = false
  private var phoneNumber = ""
  var hashCode = ""
  var confirmTime = ""
  var message = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationController?.isNavigationBarHidden = false
    if #available(iOS 11.0, *) {
      self.navigationItem.hidesSearchBarWhenScrolling = true
    } else {
      // Fallback on earlier versions
    }
    sendPhoneCodeType = "join"
    registerTextFieldDelegate()
    registerForKeyboardNotification()
    removeRegisterForKeyboardNotification()
    
    // 화면 터치 했을때 키보드 내려가는 제스쳐
    self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    
    // Do any additional setup after loading the view.
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 키보드가 텍스트필드를 가리는 현상 해결
    IQKeyboardManager.shared.enableAutoToolbar = true
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
  
  // MARK: - textField 관련 함수
  
  func registerTextFieldID() {
    JoinIdText.resignFirstResponder()
    joinPasswordText.resignFirstResponder()
    checkPasswordText.resignFirstResponder()
    nameText.resignFirstResponder()
    birthdayText.resignFirstResponder()
    cellphoneNum.resignFirstResponder()
    authNumText.resignFirstResponder()
    emailText.resignFirstResponder()
  }
  // 텍스트 필드 딜리게이트 등록
  func registerTextFieldDelegate() {
    JoinIdText.delegate = self
    joinPasswordText.delegate = self
    checkPasswordText.delegate = self
    nameText.delegate = self
    birthdayText.delegate = self
    cellphoneNum.delegate = self
    authNumText.delegate = self
    emailText.delegate = self
  }
  //
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
  
  @objc func endEditing(){
    registerTextFieldID()
  }
  
  @objc func keyboardHide(_ notification: Notification){
    self.view.transform = .identity
  }
  
  @objc func keyBoardShow(notification: NSNotification){
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue
    
    if JoinIdText.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: JoinIdText)
    }
    else if joinPasswordText.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: joinPasswordText)
    }
    else if checkPasswordText.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: checkPasswordText)
    }
    else if nameText.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: nameText)
    }
    else if emailText.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: emailText)
    }
    else if birthdayText.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: birthdayText)
    }
    else if cellphoneNum.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: cellphoneNum)
    }
    else if authNumText.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: authNumText)
    }
    else if emailText.isEditing == true{
      keyboardAnimate(keyboardRectangle: keyboardRectangle, textField: emailText)
    }
  }
  
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
  
  func keyboardAnimate(keyboardRectangle: CGRect ,textField: UITextField){
    if keyboardRectangle.height > (self.view.frame.height - textField.frame.maxY){
      self.view.transform = CGAffineTransform(translationX: 0, y: (self.view.frame.height - keyboardRectangle.height - textField.frame.maxY))
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification){
    print("Keyboard hide")
    handleKeyboardIssue(notification: notification, isAppearing: false)
  }
  
  @objc func keyboardWillShow(_ notification: Notification){
    print("Keyboard show")
    handleKeyboardIssue(notification: notification, isAppearing: true)
  }
  
  fileprivate func handleKeyboardIssue(notification: Notification, isAppearing: Bool) {
    guard let userInfo = notification.userInfo as? [String:Any] else {return}
    guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
    guard let keyboardShowAnimateDuartion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {return}
    let keyboardHeight = keyboardFrame.cgRectValue.height
    
    let heightConstant = isAppearing ? keyboardHeight : 0
    inputViewBottomAnchor.constant = heightConstant
    UIView.animate(withDuration: keyboardShowAnimateDuartion.doubleValue) {
      self.view.layoutIfNeeded()
    }
  }
  
  // MARK: - 액션 오브젝트 함수들 및 서버 연동 함수
  
  @IBAction func femaleBtn(_ sender: Any) {
    gender = "F"
    if maleCheck == true {
      femaleCheckBtn.setImage(#imageLiteral(resourceName: "female"), for: .normal)
      femaleCheck = true
      maleCheckBtn.setImage(#imageLiteral(resourceName: "male2"), for: .normal)
      maleCheck = false
    }
  }
  @IBAction func maleBtn(_ sender: UIButton) {
    gender = "M"
    if femaleCheck == true {
      femaleCheckBtn.setImage(#imageLiteral(resourceName: "female2"), for: .normal)
      femaleCheck = false
      maleCheckBtn.setImage(#imageLiteral(resourceName: "male"), for: .normal)
      maleCheck = true
    }
  }
  // 회원가입 =
  func signUp() {
    
    
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
    } else {
      sender.isSelected = true
      checkAgree = true
    }
  }
  
  @IBAction func checkAgree2Btn(_ sender: UIButton) {
    if sender.isSelected {
      sender.isSelected = false
      checkAgree2 = false
    } else {
      sender.isSelected = true
      checkAgree2 = true
    }
  }
  
  @IBAction func checkAgree3Btn(_ sender: UIButton) {
    if sender.isSelected {
      sender.isSelected = false
      checkAgree3 = false
    } else {
      sender.isSelected = true
      checkAgree3 = true
    }
  }
  
  
  // 회원가입 눌렀을 때 확인 해주는 코드.
  @IBAction func finishJoinBtn(_ sender: Any) {
    if JoinIdText.text!.isEmpty {
      doAlert(message: "Please enter your ID")
      return
    }
    if JoinIdText.text!.count <= 5 || JoinIdText.text!.count > 20 {
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
      doAlert(message: "Please enter a confirm password.")
      return
    }
    if joinPasswordText.text!.count < 8 || joinPasswordText.text!.count > 13 {
      doAlert(message: "Please enter a password between 8 and 13 characters.")
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
    if nameText.text!.isEmpty {
      doAlert(message: "Input your name, please.")
      return
    }
    if birthdayText.text!.isEmpty {
      doAlert(message: "Please enter your birthday.")
      return
    }
    
    if cellphoneNum.text!.isEmpty {
      doAlert(message: "Please enter your cell phone number.")
      return
    }
    if isPhoneConfirm  {
      doAlert(message: "Please proceed with mobile phone verification.")
      return
    }
    if !checkAgree {
      doAlert(message: "Please proceed to agree to the Privacy Policy.")
      return
    }
    if !checkAgree2 {
      doAlert(message: "Please proceed to agree to the Terms of Use.")
      return
    }
    if !checkAgree3 {
      doAlert(message: "Please proceed with the consent to use the location-based service.")
      return
    }
    
    if emailText.text!.isEmpty {
      let param = SignUpRequest(
        loginId: JoinIdText.text!,
        password: joinPasswordText.text!,
        name: nameText.text!,
        birth: birthdayText.text!,
        tel: cellphoneNum.text!,
        gender: gender
      )
      ApiService.request(router: AuthApi.SignUp(param: param), success: { (response: ApiResponse<SignupResponse>) in
        guard let value = response.value else {
          return
        }
        if value.result {
          let storyBoard = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "finishJoinVC") as! FinishJoinViewController
          storyBoard.modalPresentationStyle = .fullScreen
          self.present(storyBoard, animated: true, completion: nil)
        }
        else if !value.result {
          self.doAlert(message: value.resultMsg)
        }
        
      }) { (error) in
        self.doAlert(message: "Unknown error\nPlease try again later.")
      }
    } else {
      let param = SignUpRequest(
        loginId: JoinIdText.text!,
        password: joinPasswordText.text!,
        name: nameText.text!,
        birth: birthdayText.text!,
        tel: cellphoneNum.text!,
        gender: gender,
        // 특정 문자 제거 후 다시 스트링 값으로 붙이는 법
        email: emailText.text!//.components(separatedBy: " ").joined()
      )
      ApiService.request(router: AuthApi.SignUp(param: param), success: { (response: ApiResponse<SignupResponse>) in
        guard let value = response.value else {
          return
        }
        if value.result {
          let storyBoard = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "finishJoinVC") as! FinishJoinViewController
          storyBoard.modalPresentationStyle = .fullScreen
          self.present(storyBoard, animated: true, completion: nil)
        }
        else if !value.result {
          self.doAlert(message: value.resultMsg)
        }
        
      }) { (error) in
        self.doAlert(message: "Unknown error\nPlease try again later.")
      }
    }
  }
  
  @IBAction func backBtn(_ sender: Any) {
    self.navigationController!.popViewController(animated: true)
  }
  
  
  @IBAction func checkOverlapID(_ sender: Any) {
    if JoinIdText.text!.count < 6 || JoinIdText.text!.count > 20{
      doAlert(message: "Please enter your ID between 6 and 20 letters and numbers.")
    } else {
      if JoinIdText.text!.isIdValidate() {
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
      } else {
        doAlert(message: "Please enter your ID in the correct format.")
      }
      
    }
  }
  
  @IBAction func getAuthNumBtn(_ sender: UIButton) {
    print(sendPhoneCodeType)
    
    if cellphoneNum.text! == "" {
      self.doAlert(message: "Please enter your mobile phone number.")
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
        } else {
          self.doAlert(message: value.resultMsg)
        }
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
    }) { (error) in
      self.doAlert(message: "Phone number is empty or formatted incorrectly.")
    }
    
    
    
  }
  @IBAction func checkAuthNumBtn(_ sender: UIButton) {
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
        }
      } else if !value.result  {
        self.doAlert(message: value.resultMsg)
      }
      
    }) { (error) in
      self.doAlert(message: "The verification code format is incorrect")
    }
    
  }
  
  
  
}
