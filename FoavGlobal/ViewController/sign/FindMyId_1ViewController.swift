//
//  FindMyId_1ViewController.swift
//  FOAV
//
//  Created by hoon Kim on 23/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class FindMyId_1ViewController: UIViewController, UIGestureRecognizerDelegate {
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
    @IBOutlet weak var failAuthLabel: UILabel!
    
    var hashCode = ""
    var confirmTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendPhoneCodeType = "find"
        navigationController?.isNavigationBarHidden = false
        navigationController?.interactivePopGestureRecognizer?.delegate = self
       
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func getAuthNumBtn(_ sender: Any) {
        showHUD()
        let param = sendPhoneCodeRequest (
            email: cellphoneNum.text!, joinOrFind: sendPhoneCodeType
        )
        ApiService.request(router: AuthApi.sendCode(param: param), success: { (response: ApiResponse<ConfirmResponse>) in
            
            guard let value = response.value else {
                return
            }
            if value.result {
                if value.code == 202 {
                    self.doAlert(message: value.resultMsg)
                } else {
                    self.doAlert(message: "Verification code has been sent.")
                    self.hashCode = value.confirmHash ?? ""
                  self.confirmTime = value.effectiveTime ?? ""
                }
                self.dismissHUD()
            } else if !value.result {
                self.dismissHUD()
                    self.doAlert(message: value.resultMsg)
            }
        }) { (error) in
            self.doAlert(message: "Please try again in a few minutes.")
            self.dismissHUD()
        }
        
        
    }
    @IBAction func checkAuthNumBtn(_ sender: Any) {
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
                     self.failAuthLabel.isHidden = false
                    self.doAlert(message: value.resultMsg)
                }
            
        }) { (error) in
            self.doAlert(message: "please try again.")
        }
        
    }
    
    
    @IBAction func moveToNextBtn(_ sender: UIButton) {
        if cellphoneNum.text!.isEmpty {
            doAlert(message: "Please enter your phone number.")
            return
        }
        if authNumText.text!.isEmpty{
            doAlert(message: "Please enter your verification code.")
            return
        }
        let param = FindMyIdRequest (
            email: self.cellphoneNum.text!
        )
        ApiService.request(router: AuthApi.findId(param: param), success: { (response: ApiResponse<FindMyIdResponse>) in
            guard let value = response.value else {
                return
            }
            
            if value.result {
                if value.code == 202 {
                   self.doAlert(message: value.resultMsg)
               } else {
                   let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindMyId_2VC") as! FindMyId_2ViewController
                   vc.findId = value.userId
                   self.navigationController?.pushViewController(vc, animated: true)
               }
                
            } else if !value.result {
                    self.doAlert(message: value.resultMsg)
                }
            
            
        }) { (error) in
            self.doAlert(message: "Please complete authentication.")
        }
        
    

        
    }
    
}

