//
//  SplashViewController.swift
//  FOAV
//
//  Created by hoon Kim on 02/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import TAKUUID
class SplashViewController: UIViewController {
  
  var versionNumber: String? {
    guard let dictionary = Bundle.main.infoDictionary,
          let build = dictionary["CFBundleVersion"] as? String else {return nil}
    return build
  }
  var signupType: SignupType = .normal
  var kakaoGender = ""
  var goUpdate = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // uuid 생성 및 찾아서 서버로 전송
    
    navigationController?.isNavigationBarHidden = true
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4) {
          ApiService.request(router: VersionApi.checkVersion, success: {  (response: ApiResponse<CheckVersioinResponse>) in
            guard let value = response.value else {
              return
            }
            if value.result {
              let version: Int = Int(self.versionNumber!) ?? 0
              
              if version < value.versions.iosGlobal {
                self.performSegue(withIdentifier: "update", sender: nil)
              } else {
                UserDefaults.standard.set(value.versions.iosGlobal, forKey: "version")
                //userdefaults 값이 존재하면 자동로그인
                if UserDefaults.standard.string(forKey: "autoLoginId") != nil {
                  self.autoLogin()
                } else if UserDefaults.standard.string(forKey: "autoLoginId") == nil {
                  let loginVC2 = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "startVC")
                  loginVC2.modalPresentationStyle = .fullScreen
                  self.present(loginVC2, animated: true, completion: nil)
                }
                print("version : \(version)\nserver version: \(value.versions.iosGlobal)")
              }
            }
          }) { (error) in
            
          }
          
      }
    
  }
  
  
  func autoLogin() {
    // 유저디폴트에 저장되어있는 키에 맞는 값 불러오기
    if let userId = UserDefaults.standard.string(forKey: "autoLoginId") {
      if let userPw = UserDefaults.standard.string(forKey: "autoLoginPassword") {
        
        let param = LoginRequest (
          loginId: userId, password: userPw
        )
        // 로그인
        ApiService.request(router: AuthApi.login(param: param), success: { (response: ApiResponse<LoginResponse>) in
          guard let value = response.value else {
            return
          }
          if value.result {
            // 로그인 하면서 토큰값 넣어주기
            token = "bearer \(value.token!)"
            // 사용자를 구분하기위한 유저 정보 가져오기
            self.registToken()
            ApiService.request(router: UserApi.userInfo, success: { (response: ApiResponse<UserInfoResponse>) in
              guard let value = response.value else {
                return
              }
              if value.result {
                  DataHelper.set(value.user.charityVersion ?? false, forKey: .tabBarHidden)
                let vc = UIStoryboard.init(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tabBarVC")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
              } else if !value.result {
                let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "startVC")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
              }
              
            }) { (error) in
              //                            self.doAlert(message: "잠시 후 다시 시도해주세요.")
            }
          } else {
            if !value.result {
              UserDefaults.standard.removeObject(forKey: "autoLoginId")
              UserDefaults.standard.removeObject(forKey: "autoLoginPassword")
              let vc = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "startVC")
              vc.modalPresentationStyle = .fullScreen
              self.present(vc, animated: true, completion: nil)
            }
          }
        }) { (error) in
          //                    self.doAlert(message: "잠시 후 다시 시도해주세요.")
        }
      }
    } else {
      let login = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "startVC")
      login.modalPresentationStyle = .fullScreen
      self.present(login, animated: true, completion: nil)
    }
  }
  
  //    startVC
  
}
