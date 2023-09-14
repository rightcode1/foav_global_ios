//
//  RegistChallengeViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/05.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

enum ImageIndex: String, Codable {
  case first
  case second
  case third
  case fourth
  case fifth
  case sixth
}

class RegistChallengeViewController: UIViewController {
  @IBOutlet var contentTextView: UITextView!
  
  @IBOutlet var contentImageView1: UIImageView!
  @IBOutlet var contentImageView2: UIImageView!
  @IBOutlet var contentImageView3: UIImageView!
  
  @IBOutlet var deleteImageButton1: UIButton!
  @IBOutlet var deleteImageButton2: UIButton!
  @IBOutlet var deleteImageButton3: UIButton!
  
  @IBOutlet var contentImageView4: UIImageView!
  @IBOutlet var contentImageView5: UIImageView!
  @IBOutlet var contentImageView6: UIImageView!
  
  @IBOutlet var deleteImageButton4: UIButton!
  @IBOutlet var deleteImageButton5: UIButton!
  @IBOutlet var deleteImageButton6: UIButton!
  
  var id: Int?
  
  var challengeUserId: Int?
  
  var imageIndex: ImageIndex = .first
  
  private var imagePicker = UIImagePickerController()
  
  var isModify: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imagePicker.delegate = self
    contentTextView.delegate = self
    
    if isModify {
      getChallengeDetail()
      userChallengeId = challengeUserId ?? 0
    }
  }
  
  func textViewSetupView() {
    if contentTextView.text == "글 본문을 작성해 주세요." {
      contentTextView.text = ""
      contentTextView.textColor = UIColor.black
    } else if contentTextView.text.isEmpty {
      contentTextView.text = "글 본문을 작성해 주세요."
      contentTextView.textColor = UIColor.lightGray
    }
  }
  
  func compareImage(image1: UIImage) -> Bool {
    let data1: NSData = image1.pngData()! as NSData
    let data2: NSData = #imageLiteral(resourceName: "32").pngData()! as NSData
      return data1.isEqual(data2)
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
  
  func registChallengeImage(thumbImage: UIImage) {
    let uploadGroup = DispatchGroup()
    
    uploadGroup.enter()
    ApiService.upload(router: CarbonLivingApi.registChallengeImage, multiPartFormHanler: { multipartFormData in
      let image = thumbImage.jpegData(compressionQuality: 0.1)!
      multipartFormData.append(image, withName: "image", fileName:  "" + "_" + ".jpg", mimeType: "image/jpeg")
    }, success: { (response: ApiResponse<BoolResponse>) in
      print("imageListReponse : \(response)")
      uploadGroup.leave()
    }, failure: { (error) in
      print("imageListError : \(String(describing: error))")
    })
    uploadGroup.notify(queue: .main) {
      if !self.compareImage(image1: self.contentImageView2.image!) {
        self.registChallengeImage2(thumbImage: self.contentImageView2.image!)
      } else {
        self.dismissHUD()
        self.okActionAlert(message: self.isModify ? "수정되었습니다." : "등록되었습니다.") {
          self.backPress()
        }
      }
    }
  }
  
  func registChallengeImage2(thumbImage: UIImage) {
    let uploadGroup = DispatchGroup()
    
    uploadGroup.enter()
    ApiService.upload(router: CarbonLivingApi.registChallengeImage, multiPartFormHanler: { multipartFormData in
      let image = thumbImage.jpegData(compressionQuality: 0.1)!
      multipartFormData.append(image, withName: "image", fileName:  "" + "_" + ".jpg", mimeType: "image/jpeg")
    }, success: { (response: ApiResponse<BoolResponse>) in
      print("imageListReponse : \(response)")
      uploadGroup.leave()
    }, failure: { (error) in
      print("imageListError : \(String(describing: error))")
    })
    uploadGroup.notify(queue: .main) {
      if !self.compareImage(image1: self.contentImageView3.image!) {
        self.registChallengeImage3(thumbImage: self.contentImageView3.image!)
      } else {
        self.dismissHUD()
        self.okActionAlert(message: self.isModify ? "수정되었습니다." : "등록되었습니다.") {
          self.backPress()
        }
      }
    }
  }
  
  func registChallengeImage3(thumbImage: UIImage) {
    let uploadGroup = DispatchGroup()
    uploadGroup.enter()
    ApiService.upload(router: CarbonLivingApi.registChallengeImage, multiPartFormHanler: { multipartFormData in
      let image = thumbImage.jpegData(compressionQuality: 0.1)!
      multipartFormData.append(image, withName: "image", fileName:  "" + "_" + ".jpg", mimeType: "image/jpeg")
    }, success: { (response: ApiResponse<BoolResponse>) in
      print("imageListReponse : \(response)")
      uploadGroup.leave()
    }, failure: { (error) in
      print("imageListError : \(String(describing: error))")
    })
    uploadGroup.notify(queue: .main) {
      self.dismissHUD()
      self.okActionAlert(message: self.isModify ? "수정되었습니다." : "등록되었습니다.") {
        self.backPress()
      }
      
    }
  }
  
  func uploadImages() {
    if !compareImage(image1: contentImageView1.image!) {
      registChallengeImage(thumbImage: contentImageView1.image!)
    } else {
      if !compareImage(image1: contentImageView2.image!) {
        registChallengeImage2(thumbImage: contentImageView2.image!)
      }
    }
  }
  
  func initWithUserChallengeDetail(_ data: UserChallengeDetail) {
    contentTextView.text = data.content
    
    if data.challengeUserImages.count > 0 {
      let images = data.challengeUserImages
      
      if images.count == 1 {
        let dict = images[0]
        let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict.name)")
        contentImageView1.kf.setImage(with: url)
        self.removeChallengeImage(id: dict.id)
        self.deleteImageButton1.isHidden = false
        
      } else if images.count == 2 {
        let dict = images[0]
        let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict.name)")
        contentImageView1.kf.setImage(with: url)
        self.removeChallengeImage(id: dict.id)
        self.deleteImageButton1.isHidden = false
        
        let dict2 = images[1]
        let url2 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict2.name)")
        contentImageView2.kf.setImage(with: url2)
        self.removeChallengeImage(id: dict2.id)
        self.deleteImageButton2.isHidden = false
        
      } else if images.count == 3 {
        let dict = images[0]
        let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict.name)")
        contentImageView1.kf.setImage(with: url)
        self.removeChallengeImage(id: dict.id)
        self.deleteImageButton1.isHidden = false
        
        let dict2 = images[1]
        let url2 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict2.name)")
        contentImageView2.kf.setImage(with: url2)
        self.removeChallengeImage(id: dict2.id)
        self.deleteImageButton2.isHidden = false
        
        let dict3 = images[2]
        let url3 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict3.name)")
        contentImageView3.kf.setImage(with: url3)
        self.removeChallengeImage(id: dict3.id)
        self.deleteImageButton3.isHidden = false
      } else if images.count == 4 {
        let dict = images[0]
        let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict.name)")
        contentImageView1.kf.setImage(with: url)
        self.removeChallengeImage(id: dict.id)
        self.deleteImageButton1.isHidden = false
        
        let dict2 = images[1]
        let url2 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict2.name)")
        contentImageView2.kf.setImage(with: url2)
        self.removeChallengeImage(id: dict2.id)
        self.deleteImageButton2.isHidden = false
        
        let dict3 = images[2]
        let url3 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict3.name)")
        contentImageView3.kf.setImage(with: url3)
        self.removeChallengeImage(id: dict3.id)
        self.deleteImageButton3.isHidden = false
        
        let dict4 = images[3]
        let url4 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict4.name)")
        contentImageView4.kf.setImage(with: url4)
        self.removeChallengeImage(id: dict4.id)
        self.deleteImageButton4.isHidden = false
        
      } else if images.count == 5 {
        let dict = images[0]
        let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict.name)")
        contentImageView1.kf.setImage(with: url)
        self.removeChallengeImage(id: dict.id)
        self.deleteImageButton1.isHidden = false
        
        let dict2 = images[1]
        let url2 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict2.name)")
        contentImageView2.kf.setImage(with: url2)
        self.removeChallengeImage(id: dict2.id)
        self.deleteImageButton2.isHidden = false
        
        let dict3 = images[2]
        let url3 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict3.name)")
        contentImageView3.kf.setImage(with: url3)
        self.removeChallengeImage(id: dict3.id)
        self.deleteImageButton3.isHidden = false
        
        let dict4 = images[3]
        let url4 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict4.name)")
        contentImageView4.kf.setImage(with: url4)
        self.removeChallengeImage(id: dict4.id)
        self.deleteImageButton4.isHidden = false
        
        let dict5 = images[4]
        let url5 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict5.name)")
        contentImageView5.kf.setImage(with: url5)
        self.removeChallengeImage(id: dict5.id)
        self.deleteImageButton5.isHidden = false
        
      } else if images.count >= 6 {
        let dict = images[0]
        let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict.name)")
        contentImageView1.kf.setImage(with: url)
        self.removeChallengeImage(id: dict.id)
        self.deleteImageButton1.isHidden = false
        
        let dict2 = images[1]
        let url2 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict2.name)")
        contentImageView2.kf.setImage(with: url2)
        self.removeChallengeImage(id: dict2.id)
        self.deleteImageButton2.isHidden = false
        
        let dict3 = images[2]
        let url3 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict3.name)")
        contentImageView3.kf.setImage(with: url3)
        self.removeChallengeImage(id: dict3.id)
        self.deleteImageButton3.isHidden = false
        
        let dict4 = images[3]
        let url4 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict4.name)")
        contentImageView4.kf.setImage(with: url4)
        self.removeChallengeImage(id: dict4.id)
        self.deleteImageButton4.isHidden = false
        
        let dict5 = images[4]
        let url5 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict5.name)")
        contentImageView5.kf.setImage(with: url5)
        self.removeChallengeImage(id: dict5.id)
        self.deleteImageButton5.isHidden = false
        
        let dict6 = images[5]
        let url6 = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict6.name)")
        contentImageView6.kf.setImage(with: url6)
        self.removeChallengeImage(id: dict6.id)
        self.deleteImageButton6.isHidden = false
      }
    }
  }
  
  func getChallengeDetail() {
    ApiService.request(router: CarbonLivingApi.challengeUserDetail(id: challengeUserId ?? 0), success: { (response: ApiResponse<UserChallengeDetailResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }else {
          self.initWithUserChallengeDetail(value.data)
        }
      } else {
        if value.code >= 202 {
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  func registChallenge() {
    self.showHUD()
    ApiService.request(router: CarbonLivingApi.registChallenge(challengeId: id ?? 0, content: contentTextView.text!), success: { (response: ApiResponse<ChallengeUserIdResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.dismissHUD()
          self.doAlert(message: value.resultMsg)
        }else {
          userChallengeId = value.data?.challengeUserId ?? 0
          self.uploadImages()
        }
      } else {
        if value.code >= 202 {
          self.dismissHUD()
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.dismissHUD()
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  func modifyChallenge() {
    self.showHUD()
    ApiService.request(router: CarbonLivingApi.challengeUserUpdate(content: contentTextView.text!), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.dismissHUD()
          self.doAlert(message: value.resultMsg)
        }else {
          self.uploadImages()
        }
      } else {
        if value.code >= 202 {
          self.dismissHUD()
          self.doAlert(message: value.resultMsg)
        }
      }
    }) { (error) in
      self.dismissHUD()
      self.doAlert(message: "알수없는 오류입니다. 잠시후 다시 시도해주세요.")
    }
  }
  
  func removeChallengeImage(id: Int) {
    ApiService.request(router: CarbonLivingApi.removeChallengeImage(id: id), success: { (response: ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        print("remove success")
      } else if !value.result {
        print("remove Fail")
      }
      
    }) { (error) in
      print("remove Fail")
    }
  }
  
  @IBAction func tapDeleteImage1(_ sender: UIButton) {
    contentImageView1.image = #imageLiteral(resourceName: "32")
    deleteImageButton1.isHidden = true
  }
  
  @IBAction func tapDeleteImage2(_ sender: UIButton) {
    contentImageView2.image = #imageLiteral(resourceName: "32")
    deleteImageButton2.isHidden = true
  }
  
  @IBAction func tapDeleteImage3(_ sender: UIButton) {
    contentImageView3.image = #imageLiteral(resourceName: "32")
    deleteImageButton3.isHidden = true
  }
  
  @IBAction func tapDeleteImage4(_ sender: UIButton) {
    contentImageView4.image = #imageLiteral(resourceName: "32")
    deleteImageButton4.isHidden = true
  }
  
  @IBAction func tapDeleteImage5(_ sender: UIButton) {
    contentImageView5.image = #imageLiteral(resourceName: "32")
    deleteImageButton5.isHidden = true
  }
  
  @IBAction func tapDeleteImage6(_ sender: UIButton) {
    contentImageView6.image = #imageLiteral(resourceName: "32")
    deleteImageButton6.isHidden = true
  }
  
  
  @IBAction func tapImage1(_ sender: UIButton) {
    imageIndex = .first
    openImagePicker()
  }
  
  @IBAction func tapImage2(_ sender: UIButton) {
    imageIndex = .second
    openImagePicker()
  }
  
  @IBAction func tapImage3(_ sender: UIButton) {
    imageIndex = .third
    openImagePicker()
  }
  
  @IBAction func tapImage4(_ sender: UIButton) {
    imageIndex = .fourth
    openImagePicker()
  }
  
  @IBAction func tapImage5(_ sender: UIButton) {
    imageIndex = .fifth
    openImagePicker()
  }
  
  @IBAction func tapImage6(_ sender: UIButton) {
    imageIndex = .sixth
    openImagePicker()
  }
  
  @IBAction func tapRegist(_ sender: UIButton) {
    if compareImage(image1: contentImageView1.image!) && compareImage(image1: contentImageView2.image!) && compareImage(image1: contentImageView3.image!){
      self.doAlert(message: "대표 이미지 썸네일을 등록해 주세요.")
      return
    }
    
    if contentTextView.text.isEmpty {
      self.doAlert(message: "글을 작성해 주세요.")
      return
    }
    
    if !isModify {
      print("regist")
      registChallenge()
    } else {
      print("modify")
      modifyChallenge()
    }
    
  }
  
  
}

extension RegistChallengeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
    if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      switch self.imageIndex {
        case .first:
          contentImageView1.image = image
          deleteImageButton1.isHidden = false
        case .second:
          contentImageView2.image = image
          deleteImageButton2.isHidden = false
        case .third:
          contentImageView3.image = image
          deleteImageButton3.isHidden = false
        case .fourth:
          contentImageView4.image = image
          deleteImageButton4.isHidden = false
        case .fifth:
          contentImageView5.image = image
          deleteImageButton5.isHidden = false
        case .sixth:
          contentImageView6.image = image
          deleteImageButton6.isHidden = false
      }
      picker.dismiss(animated: true, completion: nil)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

// 텍스트뷰 플레이스 홀더
extension RegistChallengeViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    textViewSetupView()
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if self.contentTextView.text == "" {
      textViewSetupView()
    }
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      
    }
    return true
  }
  
}
