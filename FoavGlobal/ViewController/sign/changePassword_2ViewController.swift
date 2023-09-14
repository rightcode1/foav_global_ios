//
//  changePassword_2ViewController.swift
//  FOAV
//
//  Created by hoon Kim on 01/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class changePassword_2ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var idText: UITextField!
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var cellPhoneNumText: UITextField!
    
    
    override func viewDidLoad() {
      navigationController?.isNavigationBarHidden = false
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func changePasswordBtn(_ sender: Any) {
        if passwordText.text!.isEmpty {
            doAlert(message: "Please enter a password.")
            return
        } else if cellPhoneNumText.text!.isEmpty {
            doAlert(message: "Please enter a confirm password.")
            return
        }
        
        let param = ChangePasswordRequest (
            loginId: idText.text!, password: passwordText.text!, email: cellPhoneNumText.text!
        )
        ApiService.request(router: AuthApi.changePassword(param: param), success: { (response: ApiResponse<ChangePasswordResponse>) in
            guard let value = response.value else {
                return
            }
            
            if value.result {
                self.okActionAlert(message: "Your password has been changed. \nPlease log in with the new password.") {
                  self.navigationController?.popToRootViewController(animated: true)
                }
            } else if !value.result {
                self.doAlert(message: value.resultMsg)
            }
            
        }) { (error) in
            self.doAlert(message: "Certification has expired. Please proceed with authentication again.")
        }
        
    }
}
 
