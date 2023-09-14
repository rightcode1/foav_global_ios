//
//  memberInfoChangeViewController.swift
//  FOAV
//
//  Created by hoon Kim on 15/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import RxGesture
import SwiftyJSON
import DropDown

class memberInfoChangeViewController: UIViewController, UITextFieldDelegate , UIGestureRecognizerDelegate {
  @IBOutlet weak var userImageView: UIImageView!{
    didSet{
      
    }
  }
  
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var birthTextField: UITextField!
  @IBOutlet weak var genderLabel: UILabel!
  @IBOutlet weak var emailTextField: UITextField!
    
  @IBOutlet var companyUserView: UIView!
  
  @IBOutlet var employeeNumberView: UIView!
  @IBOutlet var employeeNumberTextField: UITextField!
  
  @IBOutlet var InfoMessageView: UIView!
  @IBOutlet var InfoMessageTextField: UITextField!
  
  @IBOutlet var codeInfoLabel: UILabel!
  @IBOutlet var codeLabel: UILabel!
  @IBOutlet var codeTextField: UITextField!
  @IBOutlet var codeInffView: UIView!
    @IBOutlet var companyDropDownView: UIView!
    @IBOutlet var dropDownLabel: UILabel!
    @IBOutlet var stackDropDownView: UIView!
  
  var disposeBag = DisposeBag()
    let dropDown = DropDown()
//  var isFamily: Bool = false
  private var imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    birthTextField.delegate = self
    imagePicker.delegate = self
    navigationController?.interactivePopGestureRecognizer?.delegate = self
//    setSwitch()
    
    let image = UIImage(named: "back01")
    self.navigationItem.backBarButtonItem?.image = image
    self.navigationItem.title = "Update User"
    // Do any additional setup after loading the view.
    
    getUserInfo()
    initrx()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "agreePopup", let vc = segue.destination as? InfoAgreeOfferPopupViewController {
      vc.delegate = self
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == birthTextField {
      if (birthTextField.text!.count == 4 || birthTextField.text!.count == 7) {
        if !(string == "") {
          birthTextField.text = (birthTextField.text)! + "-"
        }
      }
      return !(birthTextField.text!.count > 9 && (string.count ) > range.length)
    }
    return true
  }
  
  func openImagePicker() {
    let alert =  UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
    let library =  UIAlertAction(title: "앨범", style: .default) { (action) in
      self.imagePicker.sourceType = .photoLibrary
      self.present(self.imagePicker, animated: true, completion: nil)
    }
    alert.addAction(library)
    
    let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
  }
  
//  func setSwitch() {
//    if (DataHelperTool.stepCountingStatus ?? true) {
//      workSwitch.isOn = true
//    } else {
//      workSwitch.isOn = false
//    }
//  }
  
  func getUserInfo() {
    ApiService.request(router: UserApi.userInfo, success: { (response: ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      self.idLabel.text = value.user.loginId
      self.nameLabel.text = value.user.name
      self.birthTextField.text = value.user.birth
      if value.user.gender == "M" {
        self.genderLabel.text = "MALE"
      } else if value.user.gender == "F" {
        self.genderLabel.text = "FEMALE"
      }
      self.emailTextField.text = value.user.email
      if self.emailTextField.text == "" {
        self.emailTextField.text = ""
      }
//      self.isFamily = value.user.isFamily
//      if self.isFamily{
//        self.familyCheckImageViewOff.image = #imageLiteral(resourceName: "check-1")
//        self.familyCheckImageView.image = #imageLiteral(resourceName: "checkOn")
//      }else{
//        self.familyCheckImageViewOff.image = #imageLiteral(resourceName: "checkOn")
//        self.familyCheckImageView.image = #imageLiteral(resourceName: "check-1")
//      }
      if value.user.profile == nil || value.user.profile == "" {
        self.userImageView.layer.cornerRadius = 0
        self.userImageView.image = #imageLiteral(resourceName: "icon_profile")
      } else {
        self.userImageView.layer.cornerRadius = self.userImageView.layer.bounds.width / 2
        self.userImageView.kf.setImage(with: URL(string: "\(ApiEnvironment.baseUrl)/img/\(value.user.profile ?? "")"))
      }
      if value.user.centerRole == "일반센터" {
//        self.companyUserView.isHidden = true
        self.employeeNumberTextField.text = value.user.staffNumber
        self.InfoMessageTextField.text = value.user.stateMessage
      } else {
        self.companyUserView.isHidden = false
        if value.user.code == nil {
          self.codeInfoLabel.text = "Enter corporate membership code"
          self.codeLabel.text = ""
          self.codeInffView.isHidden = false
          self.employeeNumberTextField.isEnabled = false
          self.InfoMessageTextField.isEnabled = false
            self.stackDropDownView.isHidden = true
        } else {
          self.codeInfoLabel.text = "corporate membership code"
            self.stackDropDownView.isHidden = false
          self.codeLabel.text = value.user.code
          self.codeInffView.isHidden = true
          self.employeeNumberTextField.isEnabled = true
          self.InfoMessageTextField.isEnabled = true
          
          self.employeeNumberTextField.text = value.user.staffNumber
          self.InfoMessageTextField.text = value.user.stateMessage
            
            let compnaySubId : Int? = value.user.companySubId
            
            ApiService.request(router: UserApi.companySubInfo(id: value.user.companyId ?? 0), success: { (response: ApiResponse<CompnaySubInfoResponse>) in
              guard let value = response.value else {
                return
              }
              var list : [String] = []
              list.append("select")
              list.append(contentsOf: value.list.map({$0.name}))
              self.dropDown.dataSource = list
              self.dropDown.anchorView = self.companyDropDownView
              self.dropDown.backgroundColor = .white
              self.dropDown.direction = .bottom
          
              if (compnaySubId != nil){
                for listcount in 0 ..< value.list.count{
                  if (value.list[listcount].id == compnaySubId){
                        self.dropDownLabel.text = value.list[listcount].name
                        self.dropDownLabel.textColor = .black
                      }
                  }
              }
              self.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
                guard let self = self else { return }
                if index == 0{
                  self.dropDownLabel.text = item
                  self.dropDownLabel.textColor = .gray
                }else{
                  self.dropDownLabel.text = item
                  self.dropDownLabel.textColor = .black
                  self.registSubCode(id: value.list[index-1].id)
                }
              }
              self.dropDown.reloadAllComponents()
              
            }) { (error) in
                self.doAlert(message: "Unknown error.\nPlease try again later.")
            }
          }
        }
      self.dismissHUD()
      
    }) { (error) in
      self.doAlert(message: "Unknown error.\nPlease try again later.")
    }
  }
  
  func registProfileImage(profileImage: UIImage) {
    let uploadGroup = DispatchGroup()
    
    uploadGroup.enter()
    ApiService.upload(router: UserApi.userProfilePhoto, multiPartFormHanler: { multipartFormData in
      let image = profileImage.jpegData(compressionQuality: 0.1)!
      multipartFormData.append(image, withName: "img", fileName:  "" + "_" + ".jpg", mimeType: "image/jpeg")
    }, success: { (response: ApiResponse<BoolResponse>) in
      print("imageListReponse : \(response)")
      uploadGroup.leave()
    }, failure: { (error) in
      print("imageListError : \(String(describing: error))")
    })
    uploadGroup.notify(queue: .main) {
      self.okActionAlert(message: "Your profile image has been changed.") {
        self.userImageView.image = profileImage
      }
    }
  }
    
    func registSubCode(id: Int) {
      let param = UpdateUserInfoRequest (companySubId: id)
      ApiService.request(router: UserApi.updateUserInfo(param: param), success: { (response: ApiResponse<DefaultResponse>) in
        guard let value = response.value else {
          return
        }
      }) { (error) in
        self.performSegue(withIdentifier: "isNotCorrect", sender: nil)
      }
    }
  
  func registCode() {
    let param = UpdateUserInfoRequest (
      code: codeTextField.text!
    )
    ApiService.request(router: UserApi.updateUserInfo(param: param), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.okActionAlert(message: "Your corporate membership code has been registered.") {
          self.getUserInfo()
        }
      }
      else {
        self.performSegue(withIdentifier: "isNotCorrect", sender: nil)
      }
    }) { (error) in
      self.performSegue(withIdentifier: "isNotCorrect", sender: nil)
    }
  }
  
  func registEmployeeNumber() {
    let param = UpdateUserInfoRequest (
      staffNumber: employeeNumberTextField.text!
    )
    ApiService.request(router: UserApi.updateUserInfo(param: param), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.okActionAlert(message: "Your serial number has been saved.") {
          self.getUserInfo()
        }
      }
      else {
        self.doAlert(message: value.resultMsg)
      }
    }) { (error) in
      self.doAlert(message: "Unknown error.\nPlease try again later.")
    }
  }
//  func registFamily() {
//    let param = UpdateUserInfoRequest (
//      isFamily: isFamily
//    )
//    self.showHUD()
//        let apiUrl = "/user/update"
//        let url = URL(string: "\(ApiEnvironment.baseUrl)\(apiUrl)")!
//        let requestURL = url
//        var request = URLRequest(url: requestURL)
//
//        request.httpMethod = HTTPMethod.post.rawValue
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("\(token )", forHTTPHeaderField: "Authorization")
//
//        request.httpBody = try! JSONSerialization.data(withJSONObject: param.dictionary ?? [:], options: .prettyPrinted)
//        Alamofire.request(request).responseJSON { [self] (response) in
//          switch response.result {
//          case .success(let value):
//            let decoder = JSONDecoder()
//            let json = JSON(value)
//            let jsonData = try? json.rawData()
//
//            print("\(apiUrl) responseJson: \(json)")
//
//            if let data = jsonData, let value = try? decoder.decode(DefaultResponse.self, from: data) {
//              if value.code == 200 {
//                self.getUserInfo()
//              } else {
//                self.dismissHUD()
//              }
//            }
//            break
//          case .failure:
//            print("\(apiUrl) error: \(response.error!)")
//            self.dismissHUD()
//            break
//          }
//        }
//    }
  
  
  func registInfoMessage() {
    let param = UpdateUserInfoRequest (
      stateMessage: InfoMessageTextField.text!
    )
    ApiService.request(router: UserApi.updateUserInfo(param: param), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.okActionAlert(message: "Status message saved.") {
          self.getUserInfo()
        }
      }
      else {
        self.doAlert(message: value.resultMsg)
      }
    }) { (error) in
        self.doAlert(message: "Unknown error.\nPlease try again later.")
    }
  }
  func initrx(){
      
      
      companyDropDownView.rx.gesture(.tap()).when(.recognized).subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.dropDown.show()
      }).disposed(by: disposeBag)
//    familyCheckImageView.rx.tapGesture().when(.recognized)
//      .subscribe(onNext: { _ in
//        print("!!!")
//        if self.employeeNumberTextField.text!.isEmpty {
//          self.doAlert(message: "직번을 입력해 주세요.")
//          return
//        }
//        self.isFamily = true
//        self.registFamily()
//      })
//      .disposed(by: disposeBag)
//
//  familyCheckImageViewOff.rx.tapGesture().when(.recognized)
//    .subscribe(onNext: { _ in
//      self.isFamily = false
//      self.registFamily()
//    })
//    .disposed(by: disposeBag)
  }
  @IBAction func tapModifyProfileImage(_ sender: UIButton) {
    choiceAlert(message: "Would you like to\nchange your profile image?") {
      self.openImagePicker()
    }
  }
  
  @IBAction func changebirthBtn(_ sender: UIButton) {
    let param = UpdateUserInfoRequest (
      birth: birthTextField.text!
    )
    ApiService.request(router: UserApi.updateUserInfo(param: param), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.okActionAlert(message: "Your date of birth has changed.") {
          self.getUserInfo()
        }
      }
    }) { (error) in
      self.doAlert(message: "\(error?.errorString ?? "")")
    }
    
  }
  
  @IBAction func changeEmailBtn(_ sender: UIButton) {
    let param = ChangeUserEmailRequest (
      email: emailTextField.text!
    )
    ApiService.request(router: UserApi.changeUserEmail(param: param), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.okActionAlert(message: "Email has been changed.") {
          self.getUserInfo()
        }
      }
      else {
        if !value.result {
          self.doAlert(message: "The email format is not correct. \nPlease try again.")
        }
      }
    }) { (error) in
        self.doAlert(message: "Unknown error.\nPlease try again later.")
    }
    
  }
  
  @IBAction func tapSaveCompanyCode(_ sender: UIButton) {
    if codeTextField.text!.isEmpty {
      self.doAlert(message: "Please enter your corporate membership code.")
      return
    }
    
    performSegue(withIdentifier: "agreePopup", sender: nil)
  }
  
  @IBAction func tapSaveEmployeeNumber(_ sender: UIButton) {
    if employeeNumberTextField.text!.isEmpty {
      self.doAlert(message: "Please enter your direct number.")
      return
    }
    
    registEmployeeNumber()
  }
  
  @IBAction func tapSaveInfoMessage(_ sender: UIButton) {
    if InfoMessageTextField.text!.isEmpty {
      self.doAlert(message: "Please enter your direct number.")
      return
    }
    
    registInfoMessage()
  }
  
  @IBAction func backBtn(_ sender: Any) {
    self.navigationController!.popViewController(animated: true)
  }
  
  @IBAction func logoutBtn(_ sender: UIButton) {
    self.choiceAlert(message: "로그아웃 하시겠습니까?") {
      UserDefaults.standard.removeObject(forKey: "autoLoginId")
      UserDefaults.standard.removeObject(forKey: "autoLoginPassword")
      print("원래 토큰 값\(token)")
      token = ""
      print("토큰 값 지우고 난 뒤\(token)")
      let newVC: UIViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "startVC") as UIViewController
      newVC.modalPresentationStyle = .fullScreen
      self.navigationController?.present(newVC, animated: true)
      
    }
    
  }
  
  @IBAction func outMember(_ sender: UIButton) {
  }
  
//  @IBAction func stepCountingSwitch(_ sender: UISwitch) {
//    if sender.isOn {
//      DataHelper.set(true, forKey: .stepCountingStatus)
//      setSwitch()
//    } else {
//      DataHelper.set(false, forKey: .stepCountingStatus)
//      setSwitch()
//    }
//  }
  
}
extension memberInfoChangeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      registProfileImage(profileImage: image)
      picker.dismiss(animated: true, completion: nil)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}


extension memberInfoChangeViewController: AgreeOfferDelegate {
  func agree() {
    registCode()
  }
  
}
