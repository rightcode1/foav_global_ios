//
//  eTabViewController.swift
//  FOAV
//
//  Created by hoonKim on 2021/01/25.
//  Copyright © 2021 hoon Kim. All rights reserved.
//

import UIKit
import Kingfisher

enum EmployeesChallengeCategroy: String, Codable {
    case 전체
    case 미션
    case 봉사
    case 생활
    case 역량
    case 건강
}

class eTabViewController: BaseViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var eTabBarItem: UITabBarItem!{
        didSet{
            if UIScreen.main.bounds.width >= 375 && UIScreen.main.bounds.height > 667 {
                eTabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -12, right: 0)
                eTabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 17)
            } else {
                eTabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
            }
        }
    }
    @IBOutlet weak var ChallengeListMore: UIImageView!
    
    @IBOutlet var activityListCollectionView: UICollectionView!
    
    @IBOutlet weak var eTabDonationStatus: UIView!{
        didSet{
            // 뷰에 그림자 주는 법
            eTabDonationStatus.layer.cornerRadius = 11
            eTabDonationStatus.layer.shadowOpacity = 1
            eTabDonationStatus.layer.shadowOffset = CGSize(width: 0, height: 1)
            eTabDonationStatus.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            eTabDonationStatus.layer.shadowRadius = 2
        }
    }
    @IBOutlet var employeesView: UIView!
    @IBOutlet var employeesView1: UIView!
    @IBOutlet var employeesChallangeCategoryListCollectionView: UICollectionView!
    @IBOutlet var employeesChallangeListCollectionView: UICollectionView!
    @IBOutlet var employeesChallengeListCollectionViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var adImageView: UIImageView!
    
    @IBOutlet var co2Label: UILabel!
    @IBOutlet var needTreeLabel: UILabel!
    
    
    var lastContentOffset: CGFloat = 0
    
    let diffList: [(String, UIImage, UIImage)] = [("전체보기", #imageLiteral(resourceName: "challengeDiff1On"), #imageLiteral(resourceName: "challengeDiff1Off")), ("기업/기관", #imageLiteral(resourceName: "challengeDiff2On"), #imageLiteral(resourceName: "challengeDiff2Off")), ("봉사센터", #imageLiteral(resourceName: "challengeDiff3On"), #imageLiteral(resourceName: "challengeDiff3Off")),
                                                  ("지자체", #imageLiteral(resourceName: "challengeDiff4On"), #imageLiteral(resourceName: "challengeDiff4Off")), ("기타", #imageLiteral(resourceName: "challengeDiff5On"), #imageLiteral(resourceName: "challengeDiff5Off"))]
    var selectedDiff: ChallengeListDiff = .전체보기
    
    var companyList: [CarbonCompany] = []
    var challengeList: [ChallengeList] = []
    var carbonLivingList: [CarbonLivingList] = []
    var advertisement: AdVertisements?
    
    var userId: Int?
    var companyId: Int?
    var userLoginId: String?
    
    var employeesChallengeList: [ChallengeList] = []
    var selectCategory: EmployeesChallengeCategroy = .전체
    var categoryArray: [EmployeesChallengeCategroy] = [.전체, .미션, .봉사, .생활, .역량, .건강]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationTitleUI()
        initChallengeDiffCollectionViewLayout()
        initrx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.scrollToTop()
        getAdvertisement()
        getNormalUserInfo()
        getCarbonLivingList()
        getChallengeList()
        getCompanyList()
        getCarbonInfo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "challengeDetail", let vc = segue.destination as? ChallengeDetailViewController, let challengeData = sender as? (Int, Bool) {
            vc.id = challengeData.0
            vc.isCompany = challengeData.1
            vc.userId = userId
            vc.userLoginId = userLoginId
            vc.companyId = companyId
        }
        
        if segue.identifier == "employees", let vc = segue.destination as? ChallengeListViewController {
            vc.companyId = companyId
        }
        
        if segue.identifier == "companyDetail", let vc = segue.destination as? CarbonCompanyDetailViewController, let id = sender as? Int {
            vc.id = id
        }
        
        if segue.identifier == "carbonLivingDetail", let vc = segue.destination as? CarbonLivingDetailViewController, let id = sender as? Int {
            vc.id = id
        }
        
    }
    
    func initChallengeDiffCollectionViewLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = 47
        let height = 60
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.itemSize = CGSize(width: width, height: height)
        
        let spacing = ((Int(UIScreen.main.bounds.size.width) - 30) - (width * 5)) / 4
        layout.minimumInteritemSpacing = CGFloat(spacing)
        layout.minimumLineSpacing = CGFloat(spacing)
    }
    
    func stringToChallengeListDiff(_ string: String) -> ChallengeListDiff {
        switch string {
        case "전체보기":
            return .전체보기
        case "기업/기관":
            return .기업기관
        case "봉사센터":
            return .봉사센터
        case "지자체":
            return .지자체
        case "기타":
            return .기타
        default:
            return .전체보기
        }
    }
    
    func calculatePercent(current: Double, total: Double) -> Float {
        var currnetPercent = (Float(current) / Float(total) * 100)
        print("current: \(current)")
        
        if currnetPercent <= 0.0 {
            currnetPercent = 0.0
        }
        return currnetPercent
    }
    func initrx(){
        ChallengeListMore.rx.tapGesture().when(.recognized)
              .subscribe(onNext: { _ in
                  let vc = UIStoryboard(name: "eTab", bundle: nil).instantiateViewController(withIdentifier: "ChallengeList") as! ChallengeListViewController
                  self.navigationController?.pushViewController(vc, animated: true)
                  
              })
              .disposed(by: disposeBag)
    }
    
      func getAdvertisement() {
        ApiService.request(router: HomeApi.getetabAdvertisement, success: { (response: ApiResponse<AdvertisementResponse>) in
          guard let value = response.value else {
            return
          }
          if value.result {
              self.adImageView.kf.setImage(with: URL(string: value.advertisements[Int.random(in: 0...value.advertisements.count-1)].thumbnail)!)
          } else if !value.result {
            self.doAlert(message: value.resultMsg)
          }
        }) { (error) in
          return
        }
      }
    
    
    func getCarbonLivingList() {
        ApiService.request(router: CarbonLivingApi.carbonLivingList, success: { (response: ApiResponse<CarbonLivingListResponse>) in
            guard let value = response.value else {
                return
            }
            
            if value.result {
                self.carbonLivingList.removeAll()
                
                if value.list.count > 0 {
                    self.carbonLivingList = value.list
                }
                
                self.activityListCollectionView.reloadData()
            }
            
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
        }
    }
    
    func getEmployeesChallengeList() {
        let param = ChallengeListRequest(companyId: companyId ?? 0, category: selectCategory.rawValue)
        ApiService.request(router: CarbonLivingApi.employeesChallengeList(param: param), success: { (response: ApiResponse<ChallengeListResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.employeesChallengeList = value.list.filter{ $0.active == true }
                
                let height = ((self.view.frame.width - 40) / 2) + 30
                
                self.employeesChallengeListCollectionViewHeight.constant = height * CGFloat((self.employeesChallengeList.count / 2) + (self.employeesChallengeList.count % 2 != 0 ? 1: 0))
                self.employeesChallangeListCollectionView.reloadData()
            }
            
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
        }
    }
    
    func getNormalUserInfo() {
        ApiService.request(router: UserApi.userInfo, success: { (response:  ApiResponse<UserInfoResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.userId = value.user.id
                self.userLoginId = value.user.loginId
                self.companyId = value.user.companyId ?? 0
                
                if value.user.companyId == nil {
                    self.employeesView.isHidden = true
                    self.employeesView1.isHidden = true
                } else {
                    self.employeesView.isHidden = false
                    self.employeesView1.isHidden = false
                    self.getEmployeesChallengeList()
                }
            }
            else {
                if !value.result {
                    self.doAlert(message: value.resultMsg)
                }
            }
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
        }
    }
    
    func getUserInfo(totalCarbon: Double) {
        ApiService.request(router: UserApi.userInfo, success: { (response:  ApiResponse<UserInfoResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.userId = value.user.id
                self.userLoginId = value.user.loginId
                self.navigationTitleUI(imageurl: value.user.mainLogo)

            }
            else {
                if !value.result {
                    self.doAlert(message: value.resultMsg)
                }
            }
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
        }
    }
    
    func getCarbonInfo() {
        ApiService.request(router: CarbonLivingApi.carbonInfo, success: { (response: ApiResponse<CarbonInfoResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                //소수점 한자리만 보여주기
                self.co2Label.text = value.data.totalCarbon.formattedProductPrice() ?? "0.0"
                self.needTreeLabel.text = value.data.pine.formattedProductPrice() ?? "0.0"
                self.getUserInfo(totalCarbon: value.data.totalCarbon)
            }
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
        }
    }
    
    func getChallengeList() {
        let param = ChallengeListRequest(diff: selectedDiff == .전체보기 ? nil : selectedDiff.rawValue)
        ApiService.request(router: CarbonLivingApi.challengeList(param: param), success: { (response: ApiResponse<ChallengeListResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.challengeList.removeAll()
                self.challengeList = value.list.filter{ $0.active == true }
            }
            
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
        }
    }
    
    func getCompanyList() {
        ApiService.request(router: CarbonLivingApi.carbonCompanyList, success: { (response: ApiResponse<CarbonCompanyListResponse>) in
            guard let value = response.value else {
                return
            }
            if value.result {
                self.companyList = value.list
            }
            
        }) { (error) in
            self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
        }
    }
    
    @IBAction func tapActiviryDetail(_ sender: UIButton) {
        
    }
    
    
    @IBAction func moreCarbonLivigList(_ sender: UIButton) {
        let vc = UIStoryboard(name: "eTab", bundle: nil).instantiateViewController(withIdentifier: "moreCarbonLivingList") as! MoreCarbonLivingListViewController
        vc.carbonLivingList = carbonLivingList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapGoChallenge(_ sender: UIButton) {
        
    }
    
    @IBAction func moveToSettingBtn(_ sender: Any) {
        let vc2 = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingViewController
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    //  @IBAction func tapAd(_ sender: UIButton) {
    //    let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "advertisementVC") as! AdvertisementViewController
    //    clickToAdvertisementId = advertisement?.id ?? 0
    //    vc.advertisementId = advertisement?.id ?? 0
    //    if clickToAdvertisementId != 0 {
    //      ApiService.request(router: HomeApi.clickCount , success: { (response: ApiResponse<AdvertisementClinkCountResponse>) in
    //        guard let value = response.value else {
    //          return
    //        }
    //        if value.result {
    //          print("++++++++++++count")
    //        }
    //      }) { (error) in
    //
    //      }
    //    }
    //    if advertisement?.url != "" {
    //      if let url = URL(string: advertisement?.url ?? "") {
    //        UIApplication.shared.open(url, options: [:])
    //      }
    //    }
    //    if advertisement?.url ?? "" == "" {
    //      vc.imageUrl = advertisement?.image ?? ""
    //      self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //  }
    
}

extension eTabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carbonLivingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CarbonLivingListCell
        let dict = carbonLivingList[indexPath.row]
        
        cell.initWithCarbonLivingList(dict)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = carbonLivingList[indexPath.row]
        let vc = UIStoryboard(name: "eTab", bundle: nil).instantiateViewController(withIdentifier: "carbonLivingDetail") as! CarbonLivingDetailViewController
        vc.id = dict.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension eTabViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.x
        print("self.lastContentOffset : \(self.lastContentOffset)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == employeesChallangeCategoryListCollectionView {
            return categoryArray.count
        } else if collectionView == employeesChallangeListCollectionView {
            return employeesChallengeList.count
        } else {
            return carbonLivingList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if collectionView == employeesChallangeCategoryListCollectionView {
            let dict = categoryArray[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath)
            let categoryLabel = cell.viewWithTag(1) as! UILabel
            let selectedView = cell.viewWithTag(2)
            
            switch dict{
            case .전체:
                categoryLabel.text = "ALL"
                break
            case .미션:
                categoryLabel.text = "Mission"
                break
            case .봉사:
                categoryLabel.text = "Volunteer"
                break
            case .생활:
                categoryLabel.text = "Life"
                break
            case .역량:
                categoryLabel.text = "Ability"
                break
            case .건강:
                categoryLabel.text = "Health"
                break
            }
            
            if dict == selectCategory {
                selectedView?.backgroundColor = #colorLiteral(red: 0.1085440442, green: 0.5352237225, blue: 0.7687184811, alpha: 1)
            } else {
                selectedView?.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
            }
            
            return cell
        } else if collectionView == employeesChallangeListCollectionView {
            let dict = employeesChallengeList[indexPath.row]
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "employeesChallengeCell", for: indexPath)
            let imageView = cell.viewWithTag(1) as! UIImageView
            let peopleCountLabel = cell.viewWithTag(2) as! UILabel
            let titleLabel = cell.viewWithTag(3) as! UILabel
            let dateLabel = cell.viewWithTag(4) as! UILabel
            let backView = cell.viewWithTag(5)
            
            let roundView2 = cell.viewWithTag(6)!
            let commentCountLabel = cell.viewWithTag(7) as! UILabel
            
            let size = imageView.layer.bounds.size
            let url = imageLoad(imageName: dict.thumbnail, width: size.width, height: size.height)
            
            imageView.kf.setImage(with: url)
            imageView.layer.cornerRadius = 8
            backView?.layer.cornerRadius = 3
            
            peopleCountLabel.text = "\(dict.join)명"
            titleLabel.text = dict.title
            dateLabel.text = "\(dict.startDate)~\(dict.endDate)"
            
            roundView2.layer.cornerRadius = 4
            commentCountLabel.text = "\(dict.challengeUserCommentCount)개"
            
            return cell
        }else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carbonLivingCell", for: indexPath)
            let imageView = cell.viewWithTag(1) as! UIImageView
            let dict = carbonLivingList[indexPath.row]
            let size = imageView.layer.bounds.size
            let url = imageLoad(imageName: dict.thumbnail, width: size.width, height: size.height)
            imageView.kf.setImage(with: url)
            imageView.layer.cornerRadius = 8
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == employeesChallangeCategoryListCollectionView {
            let dict = categoryArray[indexPath.row]
            selectCategory = dict
            employeesChallangeCategoryListCollectionView.reloadData()
            getEmployeesChallengeList()
        } else if collectionView == employeesChallangeListCollectionView {
            let dict = employeesChallengeList[indexPath.row]
            performSegue(withIdentifier: "challengeDetail", sender: (dict.id, true))
        } else {
            let dict = carbonLivingList[indexPath.row]
            performSegue(withIdentifier: "carbonLivingDetail", sender: dict.id)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == employeesChallangeCategoryListCollectionView {
            let size = employeesChallangeCategoryListCollectionView.frame.size
            return CGSize(width: self.view.frame.width / 6, height: size.height)
        } else if collectionView == employeesChallangeListCollectionView {
            //      let size = challengeListCollectionView.frame.size
            let width = (self.view.frame.width - 40) / 2
            return CGSize(width: width, height: width + 30)
        }else {
            return CGSize(width: 175, height: 130)
        }
    }
    
    
}
