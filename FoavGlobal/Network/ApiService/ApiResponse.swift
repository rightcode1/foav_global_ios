//
//  ApiResponse.swift
//  BARO
//
//  Created by ldong on 2018. 1. 26..
//  Copyright © 2018년 weplanet. All rights reserved.
//

import Foundation
import Alamofire


struct ApiResponse<T> {
  
  var success: Bool = false
  var statusCode: Int = 500
  var errorString: String?
  var value: T?
  var errorMessage: ErrorMessage?
  
  
  init(statusCode: Int = 200,
       errorString: String? = nil,
       response: Any? = nil,
       errorMessage: ErrorMessage? = nil) {
    self.statusCode = statusCode
    self.errorString = errorString
    self.value = response as? T
    self.errorMessage = errorMessage
  }
  
  init(response: DataResponse<T>) {
    switch response.result {
    case .success:
      self.value = response.result.value
    case .failure(let error):
      errorString = error.localizedDescription
      do {
        errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: response.data!)
      } catch {
        debugPrint(error)
      }
    }
    
    if let code =  response.response?.statusCode {
      statusCode = code
    }
  }
  
  
  init(statusCode: Int?, data: Data?) {
    if let statusCode = statusCode {
      self.statusCode = statusCode
    }
    
    if let data = data {
      do {
        errorMessage = try JSONDecoder().decode(ErrorMessage.self, from: data)
      } catch {
        debugPrint(error)
      }
    }
  }
}

