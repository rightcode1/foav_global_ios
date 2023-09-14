//
//  MainHomeViewController.swift
//  FOAV
//
//  Created by hoon Kim on 05/12/2019.
//  Copyright © 2019 hoon Kim. All rights reserved.
//

import UIKit
import CoreLocation
import TAKUUID
import HealthKit
import Kingfisher

class MainHomeViewController: BaseViewController {
  @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var poscoCollectionView: UICollectionView!
  @IBOutlet weak var mainServiceNewsCollectionView: UICollectionView!{
    didSet{
      // cell identifier - mainServiceListCell
      //            mainServiceNewsCollectionView.layer.cornerRadius = 5
    }
  }
  @IBOutlet weak var donationCollectionView: UICollectionView!{
    didSet{
      // cell identifier -  donationListCell
      //            donationCollectionView.layer.cornerRadius = 5
    }
  }
  @IBOutlet var serviceTimeView: UIView!{
    didSet{
      // 뷰에 그림자 주는 법
      serviceTimeView.layer.cornerRadius = 11
      serviceTimeView.layer.shadowOpacity = 1
      serviceTimeView.layer.shadowOffset = CGSize(width: 0, height: 1)
      serviceTimeView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
      serviceTimeView.layer.shadowRadius = 2
    }
  }
  @IBOutlet var mainHomeTabBarItem: UITabBarItem!{
    didSet{
      if UIScreen.main.bounds.width >= 375 && UIScreen.main.bounds.height > 667 {
        mainHomeTabBarItem.imageInsets = UIEdgeInsets(top: 12, left: 0, bottom: -12, right: 0)
        mainHomeTabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 17)
      } else {
        mainHomeTabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: -3, right: 0)
      }
    }
  }
  
  @IBOutlet var todayStepsCountView: UIView!{
    didSet{
      todayStepsCountView.layer.cornerRadius = todayStepsCountView.frame.height / 2
    }
  }
  @IBOutlet var totalDaonationLb: UILabel!
  @IBOutlet var todayStepsCountLabel: UILabel!
  
  @IBOutlet var totalStepsCountLabel: UILabel!
    @IBOutlet var mainVerstionVisibleView1: UIView!
    @IBOutlet var mainVerstionVisibleView2: UIView!
  
//  @IBOutlet weak var advertisementView: UIView!
//  @IBOutlet weak var advertisementImageView: UIImageView!
  
  var myId: Int?
  
  var healthStore = HKHealthStore()
  
  var serviceNews = [ListRows]()
  var activeCharity = [CharityListV2]()
  
  var manager = CLLocationManager()
  
  var imgArr = [ UIImage(named: "mainad"),
                 UIImage(named: "6"),
                 UIImage(named: "8") ]
  
  var cal = Calendar(identifier: .gregorian)
  let dateFormatter = DateFormatter()
  let date = Date()
  var status: Bool = false
  
  var popupDay: String = ""
  
  var selectedYear: Int = 0
  var selectedMonth: Int = 0
  var selectedDay: Int = 0
  
  var registStepsCount: Int?
  var companyId: Int?
  var poscoImageUrl: URL?
  
  var advertisement: AdVertisements?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "donationRank", let vc = segue.destination as? PoscoDonationRankListViewController {
        vc.companyId = companyId
        vc.myId = myId
      }
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    manager.delegate = self
      print(DataHelperTool.tabBarHidden)
    self.tabBarController?.tabBar.isHidden = DataHelperTool.tabBarHidden ?? false
    manager.desiredAccuracy = kCLLocationAccuracyBest
    let status = CLLocationManager.authorizationStatus()
    if status == .notDetermined {
      manager.requestWhenInUseAuthorization()
    }else if status == .restricted || status == .denied {
      self.callYesNoMSGDialog(message: "위치 정보 사용 동의가 필요합니다\n설정창으로 이동하시겠습니까?") {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:])
      }
    }else {
      manager.startUpdatingLocation()
    }
    UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
    TAKUUIDStorage.sharedInstance().migrate()
    let uuid = TAKUUIDStorage.sharedInstance().findOrCreate()
    let param = RegistDeviceRequest(uuid: uuid!)
    ApiService.request(router: UserApi.registDevice(param: param) , success: { (response: ApiResponse<RegistDeviceResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        
      }
    }) { (error) in
    }
    
    navigationTitleUI()
    totalView()
//    popup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    scrollView.scrollToTop()
    getUserInfo()
      self.tabBarController?.tabBar.isHidden = DataHelperTool.tabBarHidden ?? false
    self.navigationController?.navigationBar.isHidden = false
    getServiceNewsList()
    charityList()
    

    
    if (DataHelperTool.stepCountingStatus ?? true) {
      if (appIsAuthorized()) {
        displaySteps()
      } // end if
      else {
        // Don't have permission, yet
        handlePermissions()
      }
      
      updateStepsCount()
      initStepsCount()
    }
  }
  
  
  @objc
  func stepCountTiemr() {
    print("in - stepCountTimer")
    if (DataHelperTool.stepCountingStatus ?? true) {
      if (appIsAuthorized()) {
        displaySteps()
      } // end if
      else {
        // Don't have permission, yet
        handlePermissions()
      }
      
      updateStepsCount()
      initStepsCount()
    }
    
    if registStepsCount != nil && registStepsCount ?? 0 > 0 {
      self.registStepsCount(stepsCount: registStepsCount!, date: DataHelperTool.stepsCountDate ?? "")
      print("stepCountTimer - step: \(registStepsCount!)")
    }
  }
  
  func getComapnyInfo(id: Int) {
    ApiService.request(router: UserApi.companyInfo(id: id) , success: { (response: ApiResponse<CompanyInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.data.isShareBanner {
          self.poscoCollectionView.isHidden = false
          let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(value.data.shareBanner)")
          self.poscoImageUrl = url
            self.poscoCollectionView.reloadData()
          
        }
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
    }) { (error) in
      
    }
  }
  
  func getUserInfo() {
    // 유저 정보 불러오는 곳
    ApiService.request(router: UserApi.userInfo, success: { (response:  ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.companyId = value.user.companyId ?? 0
        self.getComapnyInfo(id: self.companyId ?? 0)
        self.myId = value.user.id
          if value.user.companyId == nil {
            self.poscoCollectionView.isHidden = true
          }
          self.navigationTitleUI(imageurl: value.user.mainLogo)
          self.mainVerstionVisibleView1.isHidden = value.user.mainVersion ?? false
          self.mainVerstionVisibleView2.isHidden = value.user.mainVersion ?? false
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
  
  func appIsAuthorized() -> Bool {
    if (self.healthStore.authorizationStatus(for: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!) == .sharingAuthorized) {
      return true
    }
    else {
      return false
    }
  }
  
  func authorize(completion: @escaping (Bool, Error?) -> Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
      completion(false, HKError.noError as? Error)
      return
    }
    guard
      let step = HKObjectType.quantityType(forIdentifier: .stepCount) else {
      completion(false, HKError.noError as? Error)
      return
    }
    let reading: Set<HKObjectType> = [step]
    HKHealthStore().requestAuthorization(toShare: nil, read: reading, completion: completion)
  }
  
  func handlePermissions() {
    
    // Access Step Count
    let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)! ]
    // Check Authorization
    healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
      if (bool) {
        // Authorization Successful
        self.displaySteps()
      } // end if
    } // end of checking authorization
  } // end of func handlePermissions
  
  
  func displaySteps() {
    getSteps { (result) in
      DispatchQueue.main.async {
        let stepCount = String(Int(result))
        // Did not retrieve proper step count
        if (stepCount == "-1") {
          // If we do not have permissions
          if (!self.appIsAuthorized()) {
            self.authorize { (bool, error) in
              if bool {
                print("getStepsCount : success")
              } else {
                print("fali")
              }
            }
          } // end if
          // Else, no data to show
          else {
            self.todayStepsCountLabel.text = "0 steps"
          } // end else
          return
        } // end if
        self.registStepsCount = Int(stepCount) ?? nil
        self.todayStepsCountLabel.text = "\(Int(stepCount)?.formattedProductPrice() ?? "") steps"
        print("steps count : \(Int(stepCount)?.formattedProductPrice() ?? "")")
      }
    }
    
  } // end of func displaySteps
  
  func getSteps(completion: @escaping (Double) -> Void) {
    let calendar = NSCalendar.current
    let interval = NSDateComponents()
    interval.day = 1
    
    var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
    anchorComponents.hour = 0
    let anchorDate = calendar.date(from: anchorComponents)
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    // Define 1-day intervals starting from 0:00
    let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepsQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
    
    // Set the results handler
    stepsQuery.initialResultsHandler = {query, results, error in
      let endDate = NSDate()
      let startDate = calendar.date(byAdding: .day, value: 0, to: endDate as Date, wrappingComponents: false)
      if let myResults = results{
        myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
          if let quantity = statistics.sumQuantity(){
            let date = statistics.startDate
            let steps = quantity.doubleValue(for: HKUnit.count())
            
            
            print("today \(date): steps = \(steps)")
            //NOTE: If you are going to update the UI do it in the main thread
            DispatchQueue.main.async {
              completion(steps)
            }
            
          }
        } //end block
      } //end if let
    }
    healthStore.execute(stepsQuery)
  }
  
  func registStepsCountOfWeaks() {
    
    let calendar = NSCalendar.current
    let interval = NSDateComponents()
    interval.day = 1
    
    var anchorComponents = calendar.dateComponents([.day, .month, .year], from: NSDate() as Date)
    anchorComponents.hour = 0
    let anchorDate = calendar.date(from: anchorComponents)
    let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    // Define 1-day intervals starting from 0:00
    let stepsQuery = HKStatisticsCollectionQuery(quantityType: stepsQuantityType, quantitySamplePredicate: nil, options: .cumulativeSum, anchorDate: anchorDate!, intervalComponents: interval as DateComponents)
    
    // Set the results handler
    stepsQuery.initialResultsHandler = {query, results, error in
      let endDate = NSDate()
      let startDate = calendar.date(byAdding: .day, value: -7, to: endDate as Date, wrappingComponents: false)
      if let myResults = results{
        myResults.enumerateStatistics(from: startDate!, to: endDate as Date) { statistics, stop in
          if let quantity = statistics.sumQuantity() {
            DispatchQueue.global().sync {
              let date = statistics.startDate
              let steps = quantity.doubleValue(for: HKUnit.count())
              
              self.dateFormatter.dateFormat = "yyyy-MM-dd"
              
              let todayDateString = self.dateFormatter.string(from: Date())
              let registDateString = self.dateFormatter.string(from: calendar.date(byAdding: .hour, value: 9, to: date)!)
              
              //              print("@@@@@@@@@@@@@\n\n\n\n")
              //              print("\(date): steps = \(steps), registIndex: \(registIndex)")
              //              print("today: \(todayDateString), registDate: \(registDateString), isBefore :\(todayDateString >= registDateString) ")
              
              if todayDateString >= registDateString  {
                self.registStepsCount(stepsCount: Int(steps), date: registDateString)
              }
            }
            
            //NOTE: If you are going to update the UI do it in the main thread
            DispatchQueue.main.async {
              //update UI components
            }
            
          }
        } //end block
      } //end if let
    }
    healthStore.execute(stepsQuery)
  }
  
  func initStepsCount() {
    //    if DataHelperTool.joinDate != nil {
    //      let joinDate = DataHelperTool.joinDate!.stringToDate
    //      let interval = Date().timeIntervalSince(joinDate)
    //      let days = Int(interval / 86400)
    //
    //      if days > 6 {
    //        registStepsCountOfWeaks()
    //      }
    //    } else {
    registStepsCountOfWeaks()
    //    }
  }
  
  func totalView() {
    ApiService.request(router: HomeApi.homeData , success: { (response: ApiResponse<HomeDataResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.totalDaonationLb.text = value.donation
      } else if !value.result {
        self.doAlert(message: value.resultMsg)
      }
    }) { (error) in
      print("알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
  }
  
//  func showPopup(id: Int?, imageUrl: String?, thumbnail: String?, url: String? = nil) {
//    let vc = self.storyboard?.instantiateViewController(withIdentifier: "homePopup") as! HomePopupViewController
//
//    vc.modalPresentationStyle = .overFullScreen
//    vc.modalTransitionStyle = .crossDissolve
//    vc.thumbnailimageURL = "\(thumbnail ?? "")"
//    vc.imageURL = "\(imageUrl ?? "")"
//    vc.url = url
//    vc.id = id
//    vc.delegate = self
//
//    self.present(vc, animated: true, completion: nil)
//  }
  
//  func popup() {
//    ApiService.request(router: HomeApi.getPopupImage(location: "bottom"), success: { (response: ApiResponse<HomePopupResponse>) in
//      guard let value = response.value else {
//        return
//      }
//      print("??1")
//      if value.result {
//        if (value.advertisements?.count ?? 0) > 0  {
//          if value.advertisements?.first?.image != "" || value.advertisements?.first?.image != nil {
//            clickToAdvertisementId = value.advertisements?.first?.id ?? 0
//            if DataHelperTool.popupDate != nil  {
//              print("??2")
//              self.dateFormatter.dateFormat = "MMdd"
//              self.popupDay = self.dateFormatter.string(from: self.date)
//              let pop = DataHelperTool.popupDate
//              print(pop ?? "")
//              if pop != self.popupDay {
//                if DataHelperTool.popupDateIndex != nil {
//                  let plus: Int = (DataHelperTool.popupDateIndex ?? 0) + 1
//                  DataHelper.set(plus, forKey: .popupDateIndex)
//                  if (DataHelperTool.popupDateIndex ?? 0) > 3 {
//                    DataHelper<Any>.remove(forKey: .popupDateIndex)
//                    self.showPopup(id: value.advertisements?.first?.id, imageUrl: value.advertisements?.first?.image, thumbnail: value.advertisements?.first?.thumbnail, url: value.advertisements?.first?.url)
//                  }
//                } else {
//                  self.showPopup(id: value.advertisements?.first?.id, imageUrl: value.advertisements?.first?.image, thumbnail: value.advertisements?.first?.thumbnail, url: value.advertisements?.first?.url)
//                }
//              }
//            } else {
//              self.showPopup(id: value.advertisements?.first?.id, imageUrl: value.advertisements?.first?.image, thumbnail: value.advertisements?.first?.thumbnail, url: value.advertisements?.first?.url)
//            }
//          }
//        }
//
//      }
//    }) { error in
//    }
//  }
//
  // 주요소식 불러오는 함수
  func getServiceNewsList() {
    ApiService.request(router: SettingApi.serviceNews, success: { (response: ApiResponse<ServiceNewsResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        self.serviceNews = value.serviceNewsList
        self.mainServiceNewsCollectionView.reloadData()
        print("_____\(self.serviceNews)")
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n잠시후 다시 시도해주세요.")
    }
    
  }
  // 기부단체 불러오는 함수
  func charityList() {
    let param = CharityListRequest(diff: "active")
    ApiService.request(router: DonationApi.charityList(param: param), success: { (response: ApiResponse<CharityListV2Response>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        if value.code == 202 {
          self.doAlert(message: value.resultMsg)
        } else {
          self.activeCharity = value.charityList ?? []
          self.donationCollectionView.reloadData()
        }
      }
      
    }) { (error) in
      self.doAlert(message: "알수없는 오류입니다.\n 다시 시도해주세요.")
    }
  }
  
  func updateStepsCount() {
    ApiService.request(router: UserApi.userInfo, success: { (response:  ApiResponse<UserInfoResponse>) in
      guard let value = response.value else {
        return
      }
      if value.result {
        let changeSecond = ((value.user.serviceTime) / 1000)
        let hour = changeSecond / 3600
        let min = (changeSecond % 3600) / 60
        self.totalStepsCountLabel.text = "\(value.user.stepsCount.formattedProductPrice() ?? "") Step"
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
  
  func registStepsCount(stepsCount: Int, date: String) {
    let param = RegistStepsCountRequest(
      stepsCount: stepsCount,
      date: date
    )
    ApiService.request(router: UserApi.registStepsCount(param: param), success: { (response:  ApiResponse<DefaultResponse>) in
      guard let value = response.value else {
        return
      }
      self.updateStepsCount()
    }) { (error) in
    }
  }
  
//  func getAdvertisementList() {
//    ApiService.request(router: HomeApi.getAdvertisement(param: AdvertisementRequest(location: "area", latitude: DataHelperTool.monthLatitude ?? "", longitude: DataHelperTool.monthLongitude ?? "")), success: { (response: ApiResponse<AdvertisementResponse>) in
//      guard let value = response.value else {
//        return
//      }
//      if value.result {
//        if value.advertisements.count > 0 {
//          self.advertisementView.isHidden = false
//          let dict = value.advertisements[0]
//          self.advertisement = dict
//          DispatchQueue.main.async {
//            self.advertisementImageView.kf.setImage(with: URL(string: dict.thumbnail))
//          }
//        } else {
//          self.advertisementView.isHidden = true
//        }
//      }
//    }) { (error) in
//    }
//  }
  
  @IBAction func moveToSettingBtn(_ sender: Any) {
    let vc2 = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingViewController
    self.navigationController?.pushViewController(vc2, animated: true)
  }
  
  @IBAction func moveCharityStroeListBtn(_ sender: Any) {
    let vc2 = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "charityStoreList") as! CharityListViewController
    self.navigationController?.pushViewController(vc2, animated: true)
  }
  @IBAction func tabMoreNews(_ sender: UIButton) {
    let vc2 = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "issueList") as! IssueListViewController
    self.navigationController?.pushViewController(vc2, animated: true)
  }
  
}

//extension MainHomeViewController: HomePopupDelegate {
//  func tapPopup(imageUrl: String?, url: String?) {
//    let vc = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "advertisementVC") as! AdvertisementViewController
//
//    if url == nil {
//      vc.imageUrl = imageUrl ?? ""
//      self.navigationController?.pushViewController(vc, animated: true)
//    } else {
//      if let url = URL(string: url!) {
//        UIApplication.shared.open(url, options: [:])
//      }
//    }
//
//  }
//
//}

extension MainHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
      if collectionView == mainServiceNewsCollectionView {
        if self.serviceNews.count != 0 {
          return self.serviceNews.count
        } else {
          return 0
        }
      } else if collectionView == donationCollectionView {
        if self.activeCharity.count != 0 {
          return self.activeCharity.count
        } else {
          return 0
        }
      } else {
        return 1
      }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    // mainCollection TagNum - image: 5 , label: 6
    // donationCollection TagNum - image: 7, titleLabel: 8 , contentLabel: 9
    
    if collectionView == mainServiceNewsCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainServiceListCell", for: indexPath)
      
      if let imageView = cell.viewWithTag(5) as? UIImageView {
        let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(serviceNews[indexPath.row].thumbnailName)")
        //        let url = URL(string: "\(ApiEnvironment.imageUrl)/390x246/\(serviceNews[indexPath.row].thumbnailName)")
        imageView.kf.setImage(with: url!)
        imageView.layer.cornerRadius = 5
      }
      if let labelText = cell.viewWithTag(6) as? UILabel {
        labelText.text = serviceNews[indexPath.row].title
      }
      
      return cell
    }else if collectionView == donationCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "donationListCell", for: indexPath)
      
      if let titleLb = cell.viewWithTag(8) as? UILabel {
        titleLb.text = activeCharity[indexPath.row].company
      }
      
      if let contentLb = cell.viewWithTag(9) as? UILabel {
        contentLb.text = activeCharity[indexPath.row].title
      }
      
      if let diffImageView = cell.viewWithTag(13) as? UIImageView {
        diffImageView.image = activeCharity[indexPath.row].companyCode != nil ? UIImage(named: "groupDonationIcon")! : UIImage(named: "wholeDonationIcon")!
      }
      
      if let diffImageView = cell.viewWithTag(10) as? UIImageView {
        diffImageView.image = activeCharity[indexPath.row].diff == "걸음" ? #imageLiteral(resourceName: "shoePrintIcon138195-1") : #imageLiteral(resourceName: "25")
      }
      
      if let diffLb = cell.viewWithTag(11) as? UILabel {
        diffLb.text = activeCharity[indexPath.row].diff == "걸음" ? "the part of one's steps" : "donation of volunteer hours"
      }
      
      if let imageView = cell.viewWithTag(7) as? UIImageView {
        let url = URL(string: "\(ApiEnvironment.baseUrl)/img/\(activeCharity[indexPath.row].thumbnail ?? "")")
        //        let url = URL(string: "\(ApiEnvironment.imageUrl)/520x760/\(activeCharity[indexPath.row].thumbnail ?? "")")
        imageView.kf.setImage(with: url)
        imageView.layer.cornerRadius = 5
      }
      return cell
    } else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "poscoCell", for: indexPath)
        if let imageView = cell.viewWithTag(1) as? UIImageView {
          
          imageView.layer.cornerRadius = 10
          imageView.kf.setImage(with: poscoImageUrl)
        }
        
        return cell
      }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if collectionView == mainServiceNewsCollectionView {
      let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "issueVC") as! IssueDetailViewController
      serviceNewsId = self.serviceNews[indexPath.row].id
      self.navigationController?.pushViewController(vc, animated: true)
    }
    else if collectionView == donationCollectionView {
      let dict = self.activeCharity[indexPath.row]
      let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "realDonationVC") as! RealDonationViewController
      dateFormatter.dateFormat = "yyyy.MM.dd"
      let today = dateFormatter.string(from: date)
      if Int(today.components(separatedBy: ".").joined())! < Int(dict.startDate.components(separatedBy: ".").joined())! ||
          Int(today.components(separatedBy: ".").joined())! > Int(dict.endDate.components(separatedBy: ".").joined())! {
        status = false
      } else {
        status = true
      }
      charityId = self.activeCharity[indexPath.row].id
      vc.status = status
      self.navigationController?.pushViewController(vc, animated: true)
    } else {
        let vc = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "donationRank") as! PoscoDonationRankListViewController
        vc.companyId = companyId
        vc.myId = myId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
  }
  
}

// 콜렉션 뷰 활용 할 땐 꼭 필요함
extension MainHomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if collectionView == donationCollectionView {
      return CGSize(width: CGFloat(260), height: CGFloat(380))
    } else if collectionView == mainServiceNewsCollectionView {
      return CGSize(width: CGFloat(184), height: CGFloat(220))
    } else {
        let size = poscoCollectionView.bounds.size
        return CGSize(width: size.width, height: size.height)
      }
    
  }
  
}
// MARK: - CLLocationManagerDelegate
extension MainHomeViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .restricted || status == .denied {
      
    } else {
      manager.startUpdatingLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //위치가 업데이트될때마다
    if let location = manager.location {
      print("latitude :" + String(location.coordinate.latitude) + " / longitude :" + String(location.coordinate.longitude))
      
      let month = Date().toString(dateFormat: "MM")
      
      if DataHelperTool.locationMonth == nil {
        DataHelper.set("\(location.coordinate.latitude)", forKey: .monthLatitude)
        DataHelper.set("\(location.coordinate.longitude)", forKey: .monthLongitude)
        DataHelper.set(month, forKey: .locationMonth)
      } else if DataHelperTool.locationMonth ?? "00" != month {
        DataHelper.set("\(location.coordinate.latitude)", forKey: .monthLatitude)
        DataHelper.set("\(location.coordinate.longitude)", forKey: .monthLongitude)
        DataHelper.set(month, forKey: .locationMonth)
      }
      
      longitude = "\(location.coordinate.longitude)"
      latitude = "\(location.coordinate.latitude)"
      manager.stopUpdatingLocation()
      
      let geoCoder = CLGeocoder()
      let locale = Locale(identifier: "Ko-kr")
      geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { (placemarks, error) -> Void in
        if let error = error {
          NSLog("\(error)")
          return
        }
      }
      
    }
  }
}
