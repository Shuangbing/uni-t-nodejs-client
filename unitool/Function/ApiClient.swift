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

let API_URL = "https://api.uni-t.cc"
var isAgreePolicy = false
var SUPPORT_SCHOOL = JSON("{}").arrayValue
var USER_SCHOOL = JSON("{}").arrayValue
let USER_UUID = UIDevice.current.identifierForVendor?.uuidString ?? "null"
var isTOKEN_UPDATED = false
var selectSchoolNo = -1
var USERNAME = ""
var PASSWORD = ""

let InternetErrorMessage = "サービスに接続できません"

func getSupportSchool() {
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
                completion?(false, InternetErrorMessage)
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
            print(response.result)
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
                case 402:
                    let verifyview = SubVerifyEmail()
                    verifyview.username = user
                    verifyview.password = psw
                    LoginViewController.current()?.present(getNavVC(view: verifyview), animated: true)
                default:
                    completion?(false, json["message"].stringValue, 1)
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage, 1)
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
                case 411:
                    UIViewController.current()?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, JSON())
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage, JSON())
            }
        }
    }
    
    func verifyReSendMail(completion:((_ success: Bool, _ result: String?)->Void)?, user:String, psw:String) {
        let parameters: [String: Any] = [
        "username": user,
        "password" : psw,
        "uuid": USER_UUID
        ]
        //---------Login---------
        Alamofire.request(API_URL+"/user/auth/verify/resend", method: .post, parameters: parameters).responseJSON { response in
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
                    completion?(false, InternetErrorMessage)
                }
            }
    }
    
    func userVerifyLogin(completion:((_ success: Bool, _ result: String?)->Void)?, user:String, psw:String, vaildCode:String) {
        let parameters: [String: Any] = [
            "username": user,
            "password" : psw,
            "vaild": vaildCode,
            "uuid": USER_UUID
        ]
        //---------Login---------
        Alamofire.request(API_URL+"/user/auth/verify", method: .post, parameters: parameters).responseJSON { response in
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
                completion?(false, InternetErrorMessage)
            }
        }
    }
    
    func userRegister(completion:((_ success: Bool, _ result: String?)->Void)?, user:String, psw:String, sch:String) {
        let parameters: [String: Any] = [
            "username": user,
            "password": psw,
            "school_id" : sch,
        ]
        //---------Register---------
        Alamofire.request(API_URL+"/user/auth/register", method: .post, parameters: parameters).responseJSON { response in
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
                completion?(false, InternetErrorMessage)
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
                case 411:
                    UIViewController.current()?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue)
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage)
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
                completion?(false, InternetErrorMessage, "-")
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
                completion?(false, InternetErrorMessage)
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
                completion?(false, InternetErrorMessage)
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
                case 411:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue)
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage)
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
                case 411:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage, [])
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
                case 411:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage, [])
            }

        }
        //---------getScore---------
    }
    
    func getCanceled(completion:((_ success: Bool, _ result: String?, _ Data: [JSON])->Void)?) {
        //---------getScore---------
        Alamofire.request(API_URL+"/school/api/canceled", headers: HeaderReturn(withAuth: true)).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                switch response.response?.statusCode {
                case 200:
                    completion?(true, json["message"].stringValue, json["data"].arrayValue)
                    break
                case 411:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage, [])
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
                case 411:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage, [])
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
                case 411:
                    UIApplication.shared.keyWindow?.rootViewController?.present(ReLoginViewController(), animated: true)
                    break
                default:
                    completion?(false, json["message"].stringValue, [])
                    break
                }
            case .failure(_):
                completion?(false, InternetErrorMessage, [])
            }
        }
        //---------getAttendList---------
    }
    
}


func getTopViewController() -> UIViewController? {
    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        var topViewController: UIViewController = rootViewController

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }

        return topViewController
    } else {
        return nil
    }
}

func showAlert(type: Int, msg: String) {
    var title = ""
    switch type {
    case 1:
        title = "完了"
        HapticFeedback.Notification.pop()
    case 2:
        title = "エラー"
        HapticFeedback.Notification.failed()
    case 3:
        title = "エラー"
        HapticFeedback.Notification.failed()
    default:
        title = "完了"
    }
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    getTopViewController()!.present(alert, animated: true) {
        sleep(1)
        alert.dismiss(animated: true)
        return
    }
}

func showWaitAlert() {
    let alert = UIAlertController(title: nil, message: "読み取り中", preferredStyle: .alert)
    getTopViewController()!.present(alert, animated: true) {
        sleep(1)
        alert.dismiss(animated: true)
        return
    }
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

