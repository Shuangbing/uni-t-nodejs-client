//
//  ReLoginMainVC.swift
//  unitool
//
//  Created by そうへい on 2019/05/26.
//  Copyright © 2019 そうへい. All rights reserved.
//
import UIKit
import SnapKit
import ViewAnimator

class ReLoginViewController : UIViewController {
    
    private lazy var logoIMG : UIImageView = {
        let img = UIImage(named: "LogoBanner")
        let imgView = UIImageView()
        imgView.image = img
        imgView.layer.cornerRadius = 30
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private lazy var LoginButton : UIButton = {
        let button = InputButton()
        button.Color = Color_Main
        button.setTitle("再ログイン", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(LoginActionButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var CloaseButton : UIButton = {
        let originalColor = Color_Main
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = originalColor
        button.setTitle("閉じる", for: UIControl.State.normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(ReturnRegButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let LoginInput = InputView()
    let PswInput = InputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    
    func setupVC(){
        
        self.view.backgroundColor = .white
        view.addSubview(logoIMG)
        view.addSubview(LoginInput)
        view.addSubview(PswInput)
        view.addSubview(LoginButton)
        view.addSubview(CloaseButton)
        
        LoginInput.Lable.text = "メールアドレス"
        LoginInput.Input.keyboardType = .emailAddress
        LoginInput.Input.text = UserData.email
        LoginInput.Input.isEnabled = false
        PswInput.Lable.text = "パスワード"
        PswInput.Input.isSecureTextEntry = true
        
        //view.addSubview(RegisterButton)
        
        logoIMG.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-150)
        }
        
        LoginInput.snp.makeConstraints { (make) in
            make.width.equalTo(self.view).dividedBy(1.5)
            make.height.equalTo(80)
            make.centerX.equalTo(logoIMG)
            make.top.equalTo(logoIMG.snp.bottom).offset(20)
        }
        
        PswInput.snp.makeConstraints { (make) in
            make.width.equalTo(LoginInput)
            make.height.equalTo(80)
            make.centerX.equalTo(logoIMG)
            make.top.equalTo(LoginInput.snp.bottom).offset(5)
        }
        
        LoginButton.snp.makeConstraints { (make) in
            make.width.equalTo(LoginInput).multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(PswInput.snp.bottom).offset(5)
            make.centerX.equalTo(logoIMG)
        }
        
        CloaseButton.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.height.equalTo(view).dividedBy(8)
            make.left.bottom.equalTo(view)
        }
        
    }
    
    @objc func LoginActionButtonEvent(_ sender: UIButton) {
        sender.setTitle("処理中...", for: .normal)
        sender.isUserInteractionEnabled = false
        UserApi.userReLogin(completion: { (success, msg) in
            switch success{
            case true:
                self.dismiss(animated: true)
                //self.present(HomeTabBarController(), animated: true)
            case false:
                showAlert(type: 2, msg: msg ?? "エラー")
            }
            sender.setTitle("ログイン", for: .normal)
            sender.isUserInteractionEnabled = true
        }, user: LoginInput.Input.text ?? "", psw: PswInput.Input.text ?? "")
    }
    
    @objc func ReturnRegButtonEvent(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
