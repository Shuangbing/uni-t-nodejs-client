//
//  SubVerifyEmail.swift
//  unitool
//
//  Created by そうへい on 2018/12/03.
//  Copyright © 2018 そうへい. All rights reserved.
//

import UIKit

class SubVerifyEmail: UIViewController, UITextFieldDelegate{
    
    var username:String = ""
    var password:String  = ""
    
    let InputOneTimeCode = InputView()
    let InputreSendMail = InputButton()
    let InputSubmit = InputButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        self.title = "メールアドレス認証"
        self.view.backgroundColor = .white
        
        InputOneTimeCode.Lable.text = "認証コード"
        InputOneTimeCode.Input.keyboardType = .numberPad
        InputOneTimeCode.Input.contentMode = .center
        InputOneTimeCode.Input.becomeFirstResponder()
        InputOneTimeCode.Input.delegate = self
        
        
        InputreSendMail.setTitle("認証コード送信", for: .normal)
        InputreSendMail.addTarget(self, action: #selector(reSendMailButtonEvent), for: .touchUpInside)
        
        
        InputSubmit.isEnabled = false
        InputSubmit.setTitle("認証", for: .normal)
        InputSubmit.addTarget(self, action: #selector(submitButtonEvent), for: .touchUpInside)
        
        self.view.addSubview(InputOneTimeCode)
        self.view.addSubview(InputreSendMail)
        self.view.addSubview(InputSubmit)
        InputOneTimeCode.snp.makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-50)
            make.height.equalTo(70)
            make.top.equalTo(self.view).offset(25)
            make.centerX.equalTo(self.view)
        }
        InputreSendMail.snp.makeConstraints { (make) in
            make.top.equalTo(InputOneTimeCode.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.width.equalTo(245)
            make.height.equalTo(50)
        }
        InputSubmit.snp.makeConstraints { (make) in
            make.top.equalTo(InputreSendMail.snp.bottom).offset(30)
            make.centerX.equalTo(self.view)
            make.width.equalTo(245)
            make.height.equalTo(50)
        }
    }
    
    @objc func submitButtonEvent(){
        UserApi.userVerifyLogin(completion: { (success, msg) in
            switch success{
            case true:
                UserApi.userLogin(completion: { (success, msg, code) in
                    switch success{
                    case true:
                        self.present(HomeTabBarController(), animated: true)
                    case false:
                        showAlert(type: 2, msg: msg ?? "エラー")
                    }
                }, user: self.username, psw: self.password)
            case false:
                showAlert(type: 2, msg: msg ?? "エラー")
            }
        }, user: username , psw: password, vaildCode: InputOneTimeCode.Input.text ?? "")
    }
    
    func reSendMail(){
        UserApi.verifyReSendMail(completion: { (success, msg) in
            switch success{
            case true:
                self.InputSubmit.isEnabled = true
                showAlert(type: 3, msg: msg ?? "完了")
            case false:
                showAlert(type: 3, msg: msg ?? "エラー")
            }
        }, user: username , psw: password)
    }
    

    @objc func reSendMailButtonEvent() {
        reSendMail()
        var time = 30
        self.InputSubmit.isEnabled = true
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))
        codeTimer.setEventHandler {
            time = time - 1
            DispatchQueue.main.async {
                self.InputreSendMail.isEnabled = false
            }
            
            if time < 0 {
                codeTimer.cancel()
                DispatchQueue.main.async {
                    self.InputreSendMail.isEnabled = true
                    self.InputreSendMail.setTitle("再送信", for: .normal)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.InputreSendMail.setTitle("再送信　\(time)", for: .normal)
            }
            
        }
        
        codeTimer.resume()
        
    }
    
}
