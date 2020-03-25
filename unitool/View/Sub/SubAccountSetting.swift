//
//  SubAccountSetting.swift
//  unitool
//
//  Created by そうへい on 2018/12/06.
//  Copyright © 2018 そうへい. All rights reserved.
//

import UIKit

class SubAccountSetting: UIViewController{
    
    let LoginInput = InputView()
    let PointInput = InputView()
    let SchoolInput = InputView()
    
    let changePasswordButton = InputButton()
    let delectAccountButton = InputButton()
    
    @objc func delectAccountEvent(){
        let alert: UIAlertController = UIAlertController(title: "アカウント削除", message: "アカウントが削除されます\n取り消しができません\n宜しいでしょうか?", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let textFields = alert.textFields
            UserApi.delectAccount(completion: { (success, msg) in
                switch success{
                case true:
                    logoutUser()
                    self.dismiss(animated: true)
                    var window: UIWindow?
                    window = (UIApplication.shared.delegate?.window)!
                    window?.rootViewController = WelcomeViewController()
                    showAlert(type: 1, msg: msg ?? "完了")
                case false:
                    showAlert(type: 2, msg: msg ?? "エラー")
                }
            }, psw_now: textFields![0].text ?? "")
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("キャンセル")
        })
        alert.addTextField { (text_password) in
            text_password.placeholder = "アカウントパスワード"
            text_password.isSecureTextEntry = true
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func changePasswordEvent(){
        let alert: UIAlertController = UIAlertController(title: "パスワード変更", message: "新しいパスワードを入力してください", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "変更", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            if let textFields = alert.textFields {
                let now_psw = textFields[0].text
                let change_psw = textFields[1].text
                let change_repsw = textFields[2].text
                if now_psw != "", change_psw != "", change_repsw != ""{
                    if change_psw == change_repsw{
                        UserApi.changePassword(completion: { (success, msg) in
                            switch success{
                            case true:
                                showAlert(type: 1, msg: msg ?? "完了")
                            case false:
                                showAlert(type: 2, msg: msg ?? "エラー")
                            }
                        }, psw_now: now_psw!, psw_new: change_repsw!)
                    }else{
                        showAlert(type: 2, msg: "新しいパスワードが一致していません")
                    }
                }else{
                    showAlert(type: 2, msg: "全ての項目を入力してください")
                }
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("キャンセル")
        })
        alert.addTextField { (text_password) in
            text_password.placeholder = "現在のパスワード"
            text_password.isSecureTextEntry = true
        }
        alert.addTextField { (text_changepassword) in
            text_changepassword.placeholder = "新しいパスワード"
            text_changepassword.isSecureTextEntry = true
        }
        alert.addTextField { (text_rechangepassword) in
            text_rechangepassword.placeholder = "新しいパスワード再入力"
            text_rechangepassword.isSecureTextEntry = true
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        updateCoin()
    }
    
    func updateCoin(){
        UserApi.userProfile { (success, msg, data) in
            self.PointInput.Input.text = data["unicoin"].stringValue
            self.SchoolInput.Input.text = data["school_name"].stringValue
        }
    }
    
    func setupVC(){
        self.title = "アカウント設定"
        self.view.backgroundColor = Color_Back
        view.addSubview(LoginInput)
        view.addSubview(PointInput)
        view.addSubview(SchoolInput)
        view.addSubview(changePasswordButton)
        view.addSubview(delectAccountButton)
        LoginInput.Lable.text = "メールアドレス"
        LoginInput.Input.keyboardType = .emailAddress
        LoginInput.Input.text = UserData.email
        LoginInput.isUserInteractionEnabled = false
        PointInput.Lable.text = "ユニポイント"
        PointInput.Input.text = "読み取り中..."
        PointInput.isUserInteractionEnabled = false
        SchoolInput.Lable.text = "利用学校"
        SchoolInput.Input.text = "読み取り中..."
        SchoolInput.isUserInteractionEnabled = false
        changePasswordButton.setTitle("パスワード変更", for: .normal)
        changePasswordButton.addTarget(self, action: #selector(changePasswordEvent), for: .touchUpInside)
        delectAccountButton.setTitle("アカウント削除", for: .normal)
        delectAccountButton.addTarget(self, action: #selector(delectAccountEvent), for: .touchUpInside)
        delectAccountButton.setBackgroundImage(UIImage(color: UIColor.red.lighter()), for: .normal)
        delectAccountButton.setBackgroundImage(UIImage(color: UIColor.red.lighter().darkened()), for: .highlighted)
        delectAccountButton.isHidden = true
        let schoolName = UserData.school
        if (schoolName != "") {SchoolInput.Input.text = schoolName}
        
        LoginInput.snp.makeConstraints { (make) in
            make.width.equalTo(self.view).dividedBy(1.5)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        PointInput.snp.makeConstraints { (make) in
            make.width.equalTo(LoginInput)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalTo(LoginInput.snp.bottom).offset(5)
        }
        
        SchoolInput.snp.makeConstraints { (make) in
            make.width.equalTo(LoginInput)
            make.height.equalTo(80)
            make.centerX.equalToSuperview()
            make.top.equalTo(PointInput.snp.bottom).offset(5)
        }
        
        changePasswordButton.snp.makeConstraints { (make) in
            make.width.equalTo(LoginInput)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(SchoolInput.snp.bottom).offset(15)
        }
        
        delectAccountButton.snp.makeConstraints { (make) in
            make.width.equalTo(LoginInput)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(changePasswordButton.snp.bottom).offset(10)
        }
    }
}
