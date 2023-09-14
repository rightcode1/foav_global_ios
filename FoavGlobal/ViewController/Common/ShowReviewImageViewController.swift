//
//  ShowReviewImageViewController.swift
//  jjajan
//
//  Created by hoon Kim on 30/01/2020.
//  Copyright © 2020 jjajan. All rights reserved.
//

import UIKit
import Kingfisher

class ShowReviewImageViewController: UIViewController{
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    
    var imageUrl = ""
    var eventReview = false
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url) 
        // Do any additional setup after loading the view.
    }

}
extension ShowReviewImageViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
}

