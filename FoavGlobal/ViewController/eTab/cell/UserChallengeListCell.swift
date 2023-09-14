//
//  UserChallengeListCell.swift
//  FOAV
//
//  Created by hoonKim on 2021/02/16.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit
import Kingfisher

class UserChallengeListCell: UITableViewCell {
  @IBOutlet weak var collectionView: UICollectionView!{
    didSet {
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView.register(UINib(nibName: "ImageListCell", bundle: nil), forCellWithReuseIdentifier: "ImageListCell")
    }
  }
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  @IBOutlet weak var userProfileButton: UIButton!
  @IBOutlet weak var userImageView: UIImageView!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var likeCountLabel: UILabel!
  
  @IBOutlet weak var heartImageView: UIImageView!
  
  @IBOutlet weak var modifyButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var likeButton: UIButton!
  
  @IBOutlet weak var commentCoutnlabel: UILabel!
  
  var imageList: [Image] = []
  var uiImageList: [UIImage] = []
  
  var vc: ChallengeDetailViewController?
  
  var listvc: UserChallengeListViewController?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func initImages(images: [Image], index: Int? = nil) {
    if images.count > 0 {
      DispatchQueue.global().sync {
        self.uiImageList.removeAll()
        
        for i in 0..<images.count {
          let dict = images[i]
          do {
            let data = try! Data(contentsOf: URL(string: dict.name)!)
            let image = UIImage(data: data)
            self.uiImageList.append(image!.resizeToWidth(newWidth: UIScreen.main.bounds.width))
          }
        }
      }
    }
    
    //    showImageList(imageList: self.uiImageList, index: index)
  }
  
  func showImage(_ imageName: String) {
//    let vc = UIStoryboard(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "reviewImageVC") as! ShowReviewImageViewController
//    vc.imageUrl = "\(ApiEnvironment.baseUrl)/img/\(imageName)"
//    
//    vc.modalPresentationStyle = .overFullScreen
//    
//    if self.vc == nil {
//      self.listvc?.present(vc, animated: true)
//    } else {
//      self.vc?.present(vc, animated: true)
//    }
    
  }
  
  func imageLoad(imageName: String?) -> URL {
    let imageUrl = URL(string: "\(ApiEnvironment.baseUrl)/img/\(imageName ?? "")")!
    //    let imageUrl = URL(string: "\(ApiEnvironment.imageUrl)/\(Int(width))x\(Int(height))/\(imageName ?? "")")!
    return imageUrl
  }
  
  func initWithChallengeList(_ list: ChallengeUserList) {
    imageList = list.challengeUserImages
    
    if list.profile != nil && list.profile != "" {
      let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(list.profile ?? "")")
      userImageView.kf.setImage(with: url)
    } else {
      userImageView.image = #imageLiteral(resourceName: "icon_profile-2")
    }
    
    nameLabel.text = list.userName
    dateLabel.text = list.createdAt
    
    contentLabel.text = list.content
    likeCountLabel.text = "\(list.like)"
    commentCoutnlabel.text = "\(list.commentCount)"
    
    let width = ((UIScreen.main.bounds.width - 50) / 3)
    collectionViewHeight.constant = list.challengeUserImages.count <= 0 ? 0 : width
    
    
    if list.isLike {
      heartImageView.image = #imageLiteral(resourceName: "heart_little")
    } else {
      heartImageView.image = #imageLiteral(resourceName: "heart_blank")
    }
    
    collectionView.reloadData()
  }
}

extension UserChallengeListCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ImageListCell", for: indexPath) as! ImageListCell
    cell.imageView.kf.cancelDownloadTask()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return imageList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "ImageListCell", for: indexPath) as! ImageListCell
    
    let dict = imageList[indexPath.row]
    let imageUrl = "\(ApiEnvironment.baseUrl)/img/\(dict.name)"
    
    let scale = UIScreen.main.scale
    let width = ((UIScreen.main.bounds.width - 50) / 3)
    let size = CGSize(width: width * scale, height: width * scale)
    let downsamplingImageProcessor = DownsamplingImageProcessor(size: size)
    cell.imageView.kf.setImage(with: URL(string: imageUrl), options: [.processor(downsamplingImageProcessor)])
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //    initImages(images: imageList, index: indexPath.row)
    let dict = imageList[indexPath.row]
    showImage(dict.name)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = ((UIScreen.main.bounds.width - 50) / 3)
    return CGSize(width: width, height: width)
  }
}
