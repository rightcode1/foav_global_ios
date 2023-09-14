//
//  OutMemberViewController.swift
//  FOAV
//
//  Created by hoon Kim on 16/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class OutMemberViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func withdrawalButton(_ sender: UIButton) {
        choiceAlert(message: "회원탈퇴 하시겠습니까?") {
        ApiService.request(router: UserApi.userWithdrawal, success: { (response: ApiResponse<UserWithdrawalResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                
                self.okActionAlert(message: "회원탈퇴가 완료되었습니다.") {
                    let vc2 = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "startVC")
                    UserDefaults.standard.removeObject(forKey: "autoLoginId")
                    UserDefaults.standard.removeObject(forKey: "autoLoginPassword")
                    vc2.modalPresentationStyle = .fullScreen
                    self.present(vc2, animated: true, completion: nil)
                }
            } else if !value.result {
                self.okActionAlert(message: value.resultMsg) {
                    return
                }
            }
            
        }) { (error) in
            self.doAlert(message: "잠시 후 다시 시도해 주세요.")
            }
        }

    }
    
}
