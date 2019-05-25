//
//  LoginVC.swift
//  unitool
//
//  Created by そうへい on 2018/11/19.
//  Copyright © 2018 そうへい. All rights reserved.
//

import UIKit
import SnapKit
import ViewAnimator

let UserApi = UnitUser()
let SchoolInput = InputView()

class WelcomeViewController: UIViewController {
    
    private lazy var topIMG : UIImageView = {
        let img = UIImage(named: "top")
        let imgView = UIImageView()
        imgView.image = img
        return imgView
    }()

    private lazy var logoIMG : UIImageView = {
        let img = UIImage(named: "LogoBanner")
        let imgView = UIImageView()
        imgView.image = img
        imgView.layer.cornerRadius = 30
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private lazy var LoginButton : UIButton = {
        let originalColor = Color_Sub
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = originalColor
        button.setTitle("ログイン", for: UIControl.State.normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(LoginButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var RegisterButton : UIButton = {
        let originalColor = Color_Main
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = originalColor
        button.setTitle("新規登録", for: UIControl.State.normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(RegButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func LoginButtonEvent(_ sender: UIButton) {
        self.present(LoginViewController(), animated: true) {
            print("LoginButton")
        }
    }
    
    @objc func RegButtonEvent(_ sender: UIButton) {
        self.present(RegisterViewController(), animated: true) {
            print("Register")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        self.view.backgroundColor = .white
        
        view.addSubview(topIMG)
        view.addSubview(logoIMG)
        view.addSubview(LoginButton)
        view.addSubview(RegisterButton)
        
        topIMG.snp.makeConstraints { (make) in
            make.top.left.width.equalTo(self.view)
        }
        
        logoIMG.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.center.equalTo(self.view)
        }
        
        LoginButton.snp.makeConstraints { (make) in
            make.height.equalTo(view).dividedBy(8)
            make.width.equalTo(self.view).dividedBy(2)
            make.bottom.left.equalTo(self.view)
        }
        
        RegisterButton.snp.makeConstraints { (make) in
            make.height.equalTo(view).dividedBy(8)
            make.width.equalTo(self.view).dividedBy(2)
            make.left.equalTo(LoginButton.snp.right)
            make.bottom.equalTo(self.view)
        }
        
    }
    
}


class LoginViewController : UIViewController {
    
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
        button.setTitle("ログイン", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(LoginActionButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var RegisterReturn : UIButton = {
        let originalColor = Color_Main
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = originalColor
        button.setTitle("新規登録", for: UIControl.State.normal)
        button.tintColor = .white
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(ReturnRegButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    let LoginInput = InputView()
    let PswInput = InputView()
    let ForgetPsw = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    @objc func forgetPswTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let view = SubWebUIView()
        view.title = "パスワード忘れ"
        view.url_string = "\(API_URL)web/forget"
        let nav_view = getNavVC(view: view)
        self.present(nav_view, animated: true)
    }
    
    func setupVC(){
        
        self.view.backgroundColor = .white
        view.addSubview(logoIMG)
        view.addSubview(LoginInput)
        view.addSubview(PswInput)
        view.addSubview(ForgetPsw)
        view.addSubview(LoginButton)
        view.addSubview(RegisterReturn)
        
        ForgetPsw.text = "パスワード忘れ"
        ForgetPsw.font = UIFont.boldSystemFont(ofSize: 14)
        ForgetPsw.textColor = Color_Sub
        ForgetPsw.textAlignment = .center
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgetPswTapped(tapGestureRecognizer:)))
        ForgetPsw.isUserInteractionEnabled = true
        ForgetPsw.addGestureRecognizer(tapGestureRecognizer)
        
        LoginInput.Lable.text = "メールアドレス"
        LoginInput.Input.keyboardType = .emailAddress
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
        
        RegisterReturn.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.height.equalTo(view).dividedBy(8)
            make.left.bottom.equalTo(view)
        }
        
        ForgetPsw.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(15)
            make.top.equalTo(LoginButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func LoginActionButtonEvent(_ sender: UIButton) {
        sender.setTitle("処理中...", for: .normal)
        sender.isUserInteractionEnabled = false
        UserApi.userLogin(completion: { (success, msg, code) in
            switch success{
            case true:
                
                self.present(HomeTabBarController(), animated: true)
            case false:
                if code == 422{
                    //メールアドレス認証
                    let verifyview = SubVerifyEmail()
                    verifyview.username = self.LoginInput.Input.text ?? ""
                    verifyview.password = self.PswInput.Input.text ?? ""
                    self.present(getNavVC(view: verifyview), animated: true)
                }else{showAlert(type: 2, msg: msg ?? "エラー")}
            }
            sender.setTitle("ログイン", for: .normal)
            sender.isUserInteractionEnabled = true
        }, user: LoginInput.Input.text ?? "", psw: PswInput.Input.text ?? "")
    }
    
    @objc func ReturnRegButtonEvent(_ sender: UIButton) {
        self.present(RegisterViewController(), animated: true) {
            print("Back to Register")
        }
    }
}

class RegisterViewController : UIViewController{
    
    let LoginInput = InputView()
    let PswInput = InputView()
    
    var firstShowPolicy = false
    
    private lazy var logoIMG : UIImageView = {
        let img = UIImage(named: "LogoBanner")
        let imgView = UIImageView()
        imgView.image = img
        imgView.layer.cornerRadius = 30
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private lazy var LoginReturn : UIButton = {
        let originalColor = Color_Sub
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = originalColor
        button.setTitle("ログイン", for: UIControl.State.normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(ReturnLoginButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    private lazy var RegisterButton : UIButton = {
        let button = InputButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setBackgroundImage(UIImage(color: Color_Main), for: .normal)
        button.setBackgroundImage(UIImage(color: Color_Main.lighter()), for: .highlighted)
        button.setTitle("新規登録", for: UIControl.State.normal)
        button.addTarget(self, action: #selector(RegActionButtonEvent(_:)), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }


    
    override func viewWillAppear(_ animated: Bool) {
        if firstShowPolicy == false{
            self.present(getNavVC(view: SubPolicyWebView()), animated: true)
            firstShowPolicy = true
        }
    }
    
    func setupVC(){
        
        self.view.backgroundColor = .white
        
        view.addSubview(logoIMG)
        view.addSubview(LoginInput)
        view.addSubview(PswInput)
        view.addSubview(SchoolInput)
        view.addSubview(LoginReturn)
        view.addSubview(RegisterButton)
        LoginInput.Lable.text = "メールアドレス"
        LoginInput.Input.keyboardType = .emailAddress
        PswInput.Lable.text = "パスワード"
        PswInput.Input.isSecureTextEntry = true
        SchoolInput.Lable.text = "利用学校"
        
        SchoolInput.Input.text = "利用学校を選択してください"
        if (selectSchoolNo != -1) {SchoolInput.Input.text = SUPPORT_SCHOOL[selectSchoolNo]["name"].stringValue}
        SchoolInput.Edit = false
        SchoolInput.Input.addTarget(self, action: #selector(TapToSelectSchoolEvent(_:)), for: UIControl.Event.touchDown)
        logoIMG.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-200)
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
        
        SchoolInput.snp.makeConstraints { (make) in
            make.width.equalTo(LoginInput)
            make.height.equalTo(80)
            make.centerX.equalTo(logoIMG)
            make.top.equalTo(PswInput.snp.bottom).offset(5)
        }
        
        RegisterButton.snp.makeConstraints { (make) in
            make.width.equalTo(LoginInput).multipliedBy(0.9)
            make.height.equalTo(50)
            make.top.equalTo(SchoolInput.snp.bottom).offset(5)
            make.centerX.equalTo(logoIMG)
        }
        
        LoginReturn.snp.makeConstraints { (make) in
            make.width.equalTo(view)
            make.height.equalTo(view).dividedBy(8)
            make.left.bottom.equalTo(view)
        }
    }
    
    @objc func ReturnLoginButtonEvent(_ sender: UIButton) {
        self.present(LoginViewController(), animated: true)
    }
    
    @objc func RegActionButtonEvent(_ sender: UIButton) {
        if (selectSchoolNo != -1) {
            if isAgreePolicy == true{
        UserApi.userRegister(completion: { (success, msg) in
            switch success{
            case true:
                sender.setTitle("処理中...", for: .normal)
                sender.isUserInteractionEnabled = false
                UserApi.userLogin(completion: { (success, msg, code) in
                    switch success{
                    case true:
                        self.present(HomeTabBarController(), animated: true)
                    case false:
                        if code == 422{
                            //メールアドレス認証
                            let verifyview = SubVerifyEmail()
                            verifyview.username = self.LoginInput.Input.text ?? ""
                            verifyview.password = self.PswInput.Input.text ?? ""
                            self.present(getNavVC(view: verifyview), animated: true)
                        }else{showAlert(type: 2, msg: msg ?? "エラー")}
                    }
                    sender.setTitle("ログイン", for: .normal)
                    sender.isUserInteractionEnabled = true
                }, user: self.LoginInput.Input.text ?? "", psw: self.PswInput.Input.text ?? "")
            case false:
                showAlert(type: 2, msg: msg ?? "エラー")
            }
        }, user: LoginInput.Input.text ?? "", psw: PswInput.Input.text ?? "", sch: SUPPORT_SCHOOL[selectSchoolNo]["school_id"].stringValue)}
            else{
                self.present(getNavVC(view: SubPolicyWebView()), animated: true)
            }
        }else{
            showAlert(type: 2, msg: "利用学校を選択してください")
        }
    }
    
    
    @objc func TapToSelectSchoolEvent(_ sender: UITextField) {
        self.present(getNavVC(view: selectSchoolView()), animated: true)
    }
    
    func refreshSchool(){
        if (selectSchoolNo != -1) {SchoolInput.Input.text = SUPPORT_SCHOOL[selectSchoolNo]["name"].stringValue}
    }
    
}

class selectSchoolView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SUPPORT_SCHOOL.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellName = SUPPORT_SCHOOL[indexPath.row]["school_name"].stringValue
        let CellType = "時間割\(returnTypeIsSupport(type: "timetable", index: indexPath.row))　出席登録\(returnTypeIsSupport(type: "attend", index: indexPath.row))　成績照会\(returnTypeIsSupport(type: "score", index: indexPath.row))　Wi-Fi認証\(returnTypeIsSupport(type: "wlan", index: indexPath.row))"
        let cell = getSchoolCell(name: CellName, type: CellType, wlan: SUPPORT_SCHOOL[indexPath.row]["wlan"].intValue, attend: SUPPORT_SCHOOL[indexPath.row]["attend"].intValue, timetable: SUPPORT_SCHOOL[indexPath.row]["timetable"].intValue,score: SUPPORT_SCHOOL[indexPath.row]["score"].intValue)
        
        return cell
    }
    
    func returnTypeIsSupport(type: String, index: Int) -> String{
        if (SUPPORT_SCHOOL[index]["school_support"][type].boolValue) {
            return "✅"
        }else{
            return "⛔"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(SUPPORT_SCHOOL[indexPath.row])
        selectSchoolNo = indexPath.row
        SchoolInput.Input.text = SUPPORT_SCHOOL[indexPath.row]["school_name"].stringValue
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func getSchoolCell(name: String, type: String, wlan: Int, attend: Int, timetable: Int, score: Int) -> UITableViewCell{
        let cell = UITableViewCell()
        let lable_School = UILabel()
        let lable_Type = UILabel()
        let typeView = UIView()
        let typeWIFI, typeATTEND, typeTIMETABLE, typeSCORE: UIImageView
        typeWIFI = UIImageView()
        typeATTEND = UIImageView()
        typeTIMETABLE = UIImageView()
        typeSCORE = UIImageView()
        typeWIFI.image = UIImage(named: "wifi_\(wlan)")
        typeATTEND.image = UIImage(named: "attend_\(attend)")
        typeTIMETABLE.image = UIImage(named: "timetable_\(timetable)")
        typeSCORE.image = UIImage(named: "score_\(score)")
        lable_School.text = name
        lable_Type.text = type
        lable_Type.font = UIFont.boldSystemFont(ofSize: 13)
        typeView.addSubview(typeWIFI)
        typeView.addSubview(typeSCORE)
        typeView.addSubview(typeTIMETABLE)
        typeView.addSubview(typeATTEND)
        cell.addSubview(lable_School)
        cell.addSubview(lable_Type)
        cell.addSubview(typeView)
        lable_School.font = UIFont.systemFont(ofSize: 20)
        
        /*
        typeWIFI.snp.makeConstraints { (make) in
            make.left.top.equalTo(typeView)
            make.width.height.equalTo(16)
        }
        typeATTEND.snp.makeConstraints { (make) in
            make.top.equalTo(typeView)
            make.left.equalTo(typeWIFI.snp.right).offset(5)
            make.width.height.equalTo(16)
        }
        typeTIMETABLE.snp.makeConstraints { (make) in
            make.top.equalTo(typeView)
            make.left.equalTo(typeATTEND.snp.right).offset(5)
            make.width.height.equalTo(16)
        }
        typeSCORE.snp.makeConstraints { (make) in
            make.top.equalTo(typeView)
            make.left.equalTo(typeTIMETABLE.snp.right).offset(5)
            make.width.height.equalTo(16)
        }
         */
        lable_School.snp.makeConstraints { (make) in
            make.left.width.equalTo(cell).offset(10)
            make.top.equalTo(cell).offset(15)
            make.height.equalTo(cell).dividedBy(3)
        }
        lable_Type.snp.makeConstraints { (make) in
            make.left.width.equalTo(cell).offset(10)
            make.top.equalTo(lable_School.snp.bottom).offset(1)
            make.height.equalTo(cell).dividedBy(3)
        }
        typeView.snp.makeConstraints { (make) in
            make.left.width.equalTo(lable_School)
            make.top.equalTo(lable_School.snp.bottom).offset(5)
            make.height.equalTo(cell).dividedBy(3)
        }
        return cell
    }
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC() {
        self.view.backgroundColor = Color_Main
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.title = "対応学校"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backRegEvent(_:)))


        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.width.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-50)
        }
        UIView.animate(views: self.tableView.visibleCells,animations: [fromAnimation, zoomAnimation], delay: 0.5)
    }
    
    @objc func backRegEvent(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
