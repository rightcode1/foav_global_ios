//
//  QuestionViewController.swift
//  FOAV
//
//  Created by hoon Kim on 15/10/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var inquiryTextView: UITextView!{
        didSet{
            inquiryTextView.layer.cornerRadius = 5
            inquiryTextView.layer.borderWidth = 1
            inquiryTextView.layer.borderColor = #colorLiteral(red: 0.8481841683, green: 0.8431426883, blue: 0.8520599008, alpha: 1)
        }
    }
    @IBOutlet weak var inquiryTitleText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inquiryTextView.delegate = self
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        // 텍스트뷰 안에 텍스트 바더(여백) 주는 법
        inquiryTextView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10);
        // Do any additional setup after loading the view.
    }
    
     @IBAction func sendQuestionBtn(_ sender: UIButton) {
        let param = InquiryRequest (title: inquiryTitleText.text!, content: inquiryTextView.text)
        
        ApiService.request(router: SettingApi.inquiry(param: param), success: { (response: ApiResponse<InquiryResoponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                print("!!!#@$#@$#@$#@$#@$#@$#@$#@$\(value.result)")
                self.okActionAlert(message: "문의하신 사항이 접수되었습니다.") {
                    self.navigationController!.popViewController(animated: true)
                }
                
            }
            
        }) { (error) in
            self.doAlert(message: "문의하기를 진행할 수 없습니다. \n 다시 시도해주세요.")
        }
        

     }
 
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func textViewSetupView() {
        if inquiryTextView.text == "서비스에 관한 문의사항을 적어주세요." {
            inquiryTextView.text = ""
            inquiryTextView.textColor = UIColor.black
        } else if inquiryTextView.text.isEmpty {
            inquiryTextView.text = "서비스에 관한 문의사항을 적어주세요."
            inquiryTextView.textColor = UIColor.lightGray
        }
    }

}

extension QuestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewSetupView()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.inquiryTextView.text == "" {
             textViewSetupView()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.inquiryTextView.resignFirstResponder()
        }
        return true
    }
    
}

