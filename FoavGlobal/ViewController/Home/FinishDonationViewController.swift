//
//  FinishDonationViewController.swift
//  FOAV
//
//  Created by hoonKim on 2020/06/08.
//  Copyright © 2020 hoon Kim. All rights reserved.
//

import UIKit

class FinishDonationViewController: UIViewController {
  
  @IBOutlet var backBorderView: UIView!{
    didSet{
      backBorderView.layer.cornerRadius = 14
      backBorderView.layer.borderColor = #colorLiteral(red: 0.9999579787, green: 0.8000369668, blue: 0.0001903322845, alpha: 1)
      backBorderView.layer.borderWidth = 2
    }
  }
  @IBOutlet var yesButton: UIButton!{
    didSet{
      yesButton.layer.cornerRadius = 5
    }
  }
  @IBOutlet var donationCategoryLabel: UILabel!
  @IBOutlet var donationLabel: UILabel!
  
  @IBOutlet var donationNumberLabel: UILabel!
  @IBOutlet var donationCompanyLabel: UILabel!
  @IBOutlet var donotionDateLabel: UILabel!
  @IBOutlet var donationWayLabel: UILabel!
  
  var diff: String?
  var donationCompany: String?
  var donationId: Int?
  var donationResult: DonationResponse.Data?
  override func viewDidLoad() {
    super.viewDidLoad()
    initializeUI(donationResult)
  }
  
  func initializeUI(_ data: DonationResponse.Data? = nil) {
    donationWayLabel.text = diff ?? "" + "기부"
    donationCompanyLabel.text = donationCompany ?? ""
    
    donotionDateLabel.text = data?.createdAt
    donationLabel.text = "\(data?.count.formattedProductPrice() ?? "")\(diff ?? "")"
    donationNumberLabel.text = "\(data?.id ?? 0)"
  }
  
  @IBAction func tabCheck(_ sender: UIButton) {
    let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
    vc.modalPresentationStyle = .fullScreen
    self.present(vc, animated: true, completion: nil)
  }
  
}
