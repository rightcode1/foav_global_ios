//
//  ActivityWayDetailViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/18.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit

class ActivityWayDetailViewController: UIViewController {
  @IBOutlet var backView: UIView!{
    didSet{
      backView.layer.cornerRadius = 10
    }
  }
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var pageControl: UIPageControl!
  
  var activityList: [CarbonLivingList] = []
  
  var counter = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.isPagingEnabled = true
    getCarbonLivingList()
    
  }
  
  
  func getCarbonLivingList() {
    ApiService.request(router: CarbonLivingApi.activityList, success: { (response: ApiResponse<CarbonLivingListResponse>) in
      guard let value = response.value else {
        return
      }
      
      if value.result {
        self.activityList = value.list
        self.pageControl.numberOfPages = self.activityList.count
        self.collectionView.reloadData()
        print("!!!")
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
  @IBAction func tapPrevious(_ sender: UIButton) {
    let count = counter <= 0 ? 0 : counter - 1
    let index = IndexPath.init(item: count, section: 0)
    self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    self.pageControl.currentPage = count
    counter = count
  }
  
  @IBAction func tapNext(_ sender: UIButton) {
    let count = counter >= activityList.count - 1 ? activityList.count - 1 : counter + 1
    let index = IndexPath.init(item: count, section: 0)
    self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    self.pageControl.currentPage = count
    counter = count
  }
  
}

extension ActivityWayDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let page = Int(targetContentOffset.pointee.x / collectionView.frame.width)
    self.pageControl.currentPage = page
    self.counter = page
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return activityList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    var cell = UICollectionViewCell()
    
    cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath)
    let imageView = cell.viewWithTag(1) as! UIImageView
    let dict = activityList[indexPath.row]
    
    let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(dict.thumbnail ?? "")")
    imageView.kf.setImage(with: url)
    
    return cell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = self.collectionView.frame.size
    return CGSize(width: size.width, height: size.height)
    
  }
  
}
