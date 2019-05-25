//
//  ApiClient.swift
//  unitool
//
//  Created by そうへい on 2018/11/19.
//  Copyright © 2018 そうへい. All rights reserved.
//

import UIKit
import StatusAlert
import Alamofire
import SwiftyJSON

let API_URL = "http://localhost:3000"
var isAgreePolicy = false
var SUPPORT_SCHOOL = JSON("{}").arrayValue
var USER_SCHOOL = JSON("{}").arrayValue
let USER_UUID = UIDevice.current.identifierForVendor?.uuidString ?? "null"
var isTOKEN_UPDATED = false

var selectSchoolNo = -1
var USERNAME = ""
var PASSWORD = ""

func getSupportSchool() {
    print(USER_UUID)
    Alamofire.request(API_URL+"/school", method: .get).responseJSON { response in
        
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            switch response.response?.statusCode {
            case 200:
                SUPPORT_SCHOOL = json["data"].arrayValue
                break
            default:
                break
            }
        case .failure(_):
            print("get school list faild")
        }
    }
}


func HeaderReturn(withAuth: Bool)->HTTPHeaders{
    let token = UserData.access_token
    let authtoken = UserData.authHashCode
    //let token2 = UserData.schoolAccount
    var header:HTTPHeaders

    switch withAuth {
    case true:
        header = ["authorization": "Bearer \(token)", "authentication": "Bearer \(authtoken)", "uuid": USER_UUID]
        break
    case false:
        header = ["authorization": "Bearer \(token)", "uuid": USER_UUID]
        break
    }
    print(header)
    return header
}

class UnitUser: NSObject{
    
    func userReLogin(completion:((_ success: Bool, _ result: String?)->Void)?, user:String, psw:String) {
        let parameters: [String: Any] = [
            "username": user,
            "password" : psw,
            "uuid": USER_UUID
        ]
        //---------Login---------
        Alamofire.request(API_URL+"/user/auth/login", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    let data = json["data"]
                    updateToken(token_new: data["access_token"].stringValue)
                    completion?(true, json["message"].stringValue)
                    break
                default:
                    completion?(false, json["message"].stringValue)
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service")
            }
        }
        //---------Login---------
    }
    
    func userLogin(completion:((_ success: Bool, _ result: String?,_ code: Int)->Void)?, user:String, psw:String) {
        let parameters: [String: Any] = [
            "username": user,
            "password" : psw,
            "uuid": USER_UUID
        ]
        //---------Login---------
        Alamofire.request(API_URL+"/user/auth/login", method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    let UserData = User()
                    let data = json["data"]
                    UserData.id = data["uid"].stringValue
                    UserData.email = data["usr"].stringValue
                    UserData.access_token = data["access_token"].stringValue
                    UserData.school = data["school_id"].stringValue
                    addUser(user: UserData)
                    completion?(true, "ok", 0)
                    break
                default:
                    completion?(false, json["message"].stringValue, 1)
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service", 1)
            }
        }
        //---------Login---------
    }
    
    func userProfile(completion:((_ success: Bool, _ result: String?,_ code: JSON)->Void)?) {
        Alamofire.request(API_URL+"/user", method: .get, headers: HeaderReturn(withAuth: false)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(false, json["message"].stringValue, json["data"])
                    break
                case 403:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, JSON())
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service", JSON())
            }
        }
    }
    
    func userVerifyLogin(completion:((_ success: Bool, _ result: String?,_ code: Int)->Void)?, user:String, psw:String, one:String) {
        //let time = NSDate().timeIntervalSince1970
        
        //---------userVerifyLogin---------
        /*
         Alamofire.request(API_URL+"verify_login", method: .post, parameters: parameters).responseJSON { response in
         switch response.result {
         case .success:
         if let jsonData = response.result.value {
         let json = JSON(jsonData)
         if json["code"] == 200 {
         let UserData = User()
         UserData.id = json["data"]["client"]["id"].intValue
         UserData.email = json["data"]["client"]["email"].stringValue
         UserData.token = base64Encoding(plainString: "\(APP_ID):\(json["data"]["access_token"].stringValue):\(UserData.id)")
         UserData.refresh_token = json["data"]["refresh_token"].stringValue
         UserData.school = json["data"]["client"]["school"].intValue
         addUser(user: UserData)
         completion?(true, json["message"].stringValue,json["code"].intValue )
         }else{
         completion?(false, json["message"].stringValue,json["code"] .intValue)
         }
         }
         case .failure:
         completion?(false, "サービスに接続できません",401)
         }
         }*/
        //---------userVerifyLogin---------
    }
    
    func userRegister(completion:((_ success: Bool, _ result: String?)->Void)?, user:String, psw:String, sch:String) {
        let parameters: [String: Any] = [
            "username": user,
            "password": psw,
            "school_id" : sch,
        ]
        //---------Register---------
        Alamofire.request(API_URL+"/user/auth/register", method: .post, parameters: parameters).responseJSON { response in
            print(response.result)
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue)
                    break
                default:
                    completion?(false, json["message"].stringValue)
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service")
            }
        }
        //---------Register---------
    }
    
    func userUpdateToken(completion:((_ success: Bool, _ result: String?)->Void)?) {
        //---------userUpdateToken---------
        Alamofire.request(API_URL+"/user/auth/refresh", method: .get, headers: HeaderReturn(withAuth: false)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue)
                    updateToken(token_new: json["data"]["access_token"].stringValue)
                    break
                case 403:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue)
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service")
            }
        }
        //---------userUpdateToken---------
    }
    
    func getUniCoin(completion:((_ success: Bool, _ result: String?, _ attendData: String)->Void)?) {
        //---------getUniCoin---------
        Alamofire.request(API_URL+"school/getUniCoin", headers: HeaderReturn(withAuth: false)).responseJSON { response in
            
            switch response.result {
            case .success:
                if let jsonData = response.result.value {
                    let json = JSON(jsonData)
                    if json["code"] == 200 {
                        completion?(true, json["message"].stringValue, json["data"]["unicoin"].stringValue)
                    }else{
                        completion?(false, json["message"].stringValue, "-")
                    }
                }
            case .failure:
                completion?(false, "サービスに接続できません", "-")
            }
        }
        //---------getUniCoin---------
    }
    
    func changePassword(completion:((_ success: Bool, _ result: String?)->Void)?, psw_now:String, psw_new:String) {
        let parameters: [String: Any] = [
            "password_old": psw_now,
            "password_new": psw_new,
        ]
        //---------changePassword---------
        Alamofire.request(API_URL+"/user/auth/password", method: .put, parameters: parameters, headers: HeaderReturn(withAuth: false)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue)
                    break
                default:
                    completion?(false, json["message"].stringValue)
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service")
            }
        }
        //---------changePassword---------
    }
    
    func delectAccount(completion:((_ success: Bool, _ result: String?)->Void)?, psw_now:String) {
        let parameters: [String: Any] = [
            "password": psw_now,
        ]
        //---------delectAccount---------
        Alamofire.request(API_URL+"/user", method: .delete, parameters: parameters, headers: HeaderReturn(withAuth: false)).responseJSON { response in
            switch response.result {
            case .success:
                if let jsonData = response.result.value {
                    let json = JSON(jsonData)
                    if json["code"] == 200 {
                        completion?(true, json["message"].stringValue)
                    }else{
                        completion?(false, json["message"].stringValue)
                    }
                }
            case .failure:
                completion?(false, "サービスに接続できません")
            }
        }
        //---------delectAccount---------
    }
    
    func logout(){
        Alamofire.request(API_URL+"/user/auth/logout", method: .get, headers: HeaderReturn(withAuth: false))
    }
    
}

class UnitSchool: NSObject{
    
    func verify(completion:((_ success: Bool, _ result: String?)->Void)?, user:String, psw:String) {
        let parameters: [String: Any] = [
            "susr": user,
            "spsw" : psw,
        ]
        //---------verify---------
        Alamofire.request(API_URL+"/school/api/verify", method: .post, parameters: parameters, headers: HeaderReturn(withAuth: false)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue)
                    updateAuthToken(token: json["data"]["school_account"].stringValue)
                    break
                case 403:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue)
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service")
            }
        }
        //---------verify---------
    }
    
    func syncTimetable(completion:((_ success: Bool, _ result: String?, _ Data: [JSON])->Void)?,team: Int) {
        //---------verify---------
        Alamofire.request(API_URL+"/school/api/timetable", method: .get, headers: HeaderReturn(withAuth: true)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue, json["data"].arrayValue)
                    break
                case 403:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service", [])
            }
        }
        //---------verify---------
    }
    
    func getScore(completion:((_ success: Bool, _ result: String?, _ Data: [JSON])->Void)?) {
        //---------getScore---------
        Alamofire.request(API_URL+"/school/api/grade", headers: HeaderReturn(withAuth: true)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue, json["data"].arrayValue)
                    break
                case 403:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service", [])
            }

        }
        //---------getScore---------
    }
    
    func getAttendList(completion:((_ success: Bool, _ result: String?, _ attendData: [JSON])->Void)?) {
        //---------getAttendList---------
        Alamofire.request(API_URL+"/school/api/attendance", method: .get, headers: HeaderReturn(withAuth: true)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue, json["data"].arrayValue)
                    break
                case 403:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service", [])
            }
        }
        //---------getAttendList---------
    }
    
    func sendAttend(completion:((_ success: Bool, _ result: String?, _ attendData: [JSON])->Void)?, attenddata:String, attendno:String) {
        
        let parameters: [String: Any] = [
            "attendanceCode": attenddata,
            "attendanceNo": attendno,
        ]
        
        //---------getAttendList---------
        Alamofire.request(API_URL+"/school/api/attendance", method: .post, parameters: parameters, headers: HeaderReturn(withAuth: true)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue, [])
                    break
                case 403:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, "could not connect service", [])
            }
        }
        //---------getAttendList---------
    }
    
}

func RSA_SCHOOL_ACCOUNT(user: String, psw:String)->String{
    return "good"
}




func showAlert(type: Int, msg: String) {
    let statusAlert = StatusAlert()
    StatusAlert.multiplePresentationsBehavior = .dismissCurrentlyPresented
    switch type {
    case 1:
        statusAlert.title = "完了"
        statusAlert.image = UIImage(named: "success")
        //HapticFeedback.Notification.successSound()
        if #available(iOS 10.0, *) {
            HapticFeedback.Notification.success()
        } else {
            // Fallback on earlier versions
        }
    case 2:
        statusAlert.title = "エラー"
        statusAlert.image = UIImage(named: "error")
        //HapticFeedback.Notification.warningSound()
        if #available(iOS 10.0, *) {
            HapticFeedback.Notification.warning()
        } else {
            // Fallback on earlier versions
        }
    case 3:
        statusAlert.title = nil
        statusAlert.image = nil
        //HapticFeedback.Notification.warningSound()
        if #available(iOS 10.0, *) {
            HapticFeedback.Notification.warning()
        } else {
            // Fallback on earlier versions
        }
    default:
        statusAlert.image = UIImage(named: "success")
    }
    
    statusAlert.message = msg
    statusAlert.canBePickedOrDismissed = false
    statusAlert.showInKeyWindow()
}

func showWaitAlert() {
    let statusAlert = StatusAlert()
    statusAlert.image = nil
    statusAlert.title = nil
    statusAlert.isMultipleTouchEnabled = true
    statusAlert.message = "読み取り中..."
    statusAlert.canBePickedOrDismissed = false
    statusAlert.showInKeyWindow()
    //statusAlert.show(multiplePresentationsBehavior: .dismissCurrentlyPresented)
}

func base64Encoding(plainString:String)->String
{
    let plainData = plainString.data(using: String.Encoding.utf8)
    let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
    return base64String!
}

func base64Decoding(encodedString:String)->String
{
    let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
    let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
    return decodedString
}

