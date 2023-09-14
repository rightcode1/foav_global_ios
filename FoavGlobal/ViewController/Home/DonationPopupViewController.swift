//
//  DonationPopupViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/06/08.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class DonationPopupViewController: UIViewController {
  @IBOutlet var cornerView: UIView!{
    didSet{
      cornerView.layer.cornerRadius = 10
    }
  }
  
  @IBOutlet var donationCategoryLabel: UILabel!
  @IBOutlet var donationInfoLabel: UILabel!
  @IBOutlet var donationImageView: UIImageView!
  
  @IBOutlet var yesButton: UIButton!{
    didSet{
      yesButton.layer.cornerRadius = 5
    }
  }
  @IBOutlet var cancleButton: UIButton!{
    didSet{
      cancleButton.layer.cornerRadius = 5
    }
  }
  var diff: String?
  var donationCompany: String?
  var donationId: Int?
  var donationResult: DonationResponse.Data?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if diff ?? "" == "시간" {
      donationCategoryLabel.text = "봉사시간 기부"
      donationInfoLabel.text = "기부 가능한 나의\n봉사시간이 모두 기부됩니다."
      donationImageView.image = #imageLiteral(resourceName: "71")
    }
  }
  
  func donation() {
    ApiService.request(router: DonationApi.donation(charityId: donationId ?? 0), success: { (response: ApiResponse<DonationResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code >= 202 {
          self.okActionAlert(message: value.resultMsg) {
            self.backPress()
          }
        } else {
          self.donationResult = value.data
          let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "finishDonation") as! FinishDonationViewController
          vc.diff = self.diff
          vc.donationId = self.donationId
          vc.donationCompany = self.donationCompany
          vc.donationResult = self.donationResult
          vc.modalPresentationStyle = .fullScreen
          self.present(vc, animated: true, completion: nil)
          }
        }
    }) { (error) in
      self.okActionAlert(message: "알수없는 오류 입니다.\n다시 시도해주세요.") {
        self.backPress()
      }
    }
  }
  
  @IBAction func yes(_ sender: UIButton) {
    donation()
  }
  
}
