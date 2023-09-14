//
//  PrivacyViewController.swift
//  FOAV
//
//  Created by hoon Kim on 08/11/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var privacyPolicyTV: UITextView! {
            didSet{
            // 편집 막는것
            privacyPolicyTV.isEditable = false
            // 클릭 막는것 
            privacyPolicyTV.isSelectable = false
            privacyPolicyTV.layer.borderWidth = 1.5
            privacyPolicyTV.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            privacyPolicyTV.layer.cornerRadius = 14
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        ApiService.request(router: AuthApi.privacy , success: { (response: ApiResponse<PrivacyResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.privacyPolicyTV.text = value.privacy
            } else if !value.result {
                self.doAlert(message: value.resultMsg)
            }
        }) { (error) in
            print("잠시 후 다시 시도해주세요.")
        }
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

}
