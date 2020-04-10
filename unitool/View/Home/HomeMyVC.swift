//
//  HomeMyVC.swift
//  unitool
//
//  Created by そうへい on 2018/11/22.
//  Copyright © 2018 そうへい. All rights reserved.
//
import UIKit



class HomeMyVC: UIViewController{
    let menuList = ["ログアウト","成績照会","休講情報","学内アカウント設定"]
    let newMenu = [5]
    let tableView = UITableView()
    let versionLabel = UILabel()
    
   func setSchoolACButtonEvent() {
            self.present(getNavVC(view: SubSchoolAccountVC()), animated: true)
    }
    
    @objc func ScoreButtonEvent() {
        tableView.isUserInteractionEnabled = false
        SchoolAPI.getScore(completion: { (success, msg, data) in
            self.tableView.isUserInteractionEnabled = true
            switch success{
            case true:
                scoreData = data
                self.present(getNavVC(view: SubScoreVC()), animated: true)
            case false:
                attendData = []
                showAlert(type: 2, msg: msg ?? "エラー")
            }
        })
        
    }
    
    @objc func CanceldButtonEvent() {
        tableView.isUserInteractionEnabled = false
        SchoolAPI.getCanceled(completion: { (success, msg, data) in
            self.tableView.isUserInteractionEnabled = true
            switch success{
            case true:
                canceledData = data
                self.present(getNavVC(view: SubCanceledVC()), animated: true)
            case false:
                canceledData = []
                showAlert(type: 2, msg: msg ?? "エラー")
            }
        })
        
    }
    
    func LogoutButtonEvent() {
        let alert: UIAlertController = UIAlertController(title: "ログアウト", message: "ログアウトしてよろしいでしょうか?\n次回ご利用の際に学内アカウントの情報の再入力が必要です。", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "ログアウト", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            logoutUser()
            self.dismiss(animated: true)
            var window: UIWindow?
            window = (UIApplication.shared.delegate?.window)!
            window?.rootViewController = WelcomeViewController()
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("キャンセル")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        getVersionInfo()
    }
    
    func getVersionInfo() {
        let infoDictionary = Bundle.main.infoDictionary!
        let majorVersion = infoDictionary["CFBundleShortVersionString"]
        let minorVersion = infoDictionary["CFBundleVersion"] as! String
        let appVersion = majorVersion as! String
        versionLabel.text = "ユニツ \(appVersion)-(\(minorVersion))"
        versionLabel.textAlignment = .center
        versionLabel.font = UIFont.systemFont(ofSize: 13)
        versionLabel.textColor = Color_GreyFont
    }
    
    @objc func userAccountImageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.navigationController?.pushViewController(SubAccountSetting(), animated: true)
    }
    
    func setupVC(){
        let userAccountLogo = UIImageView()
        let userAccountEmail = UILabel()
        userAccountLogo.image = UIImage(named: "icon_user")
        userAccountEmail.text = UserData.email
        userAccountEmail.textAlignment = .center
        userAccountEmail.textColor = Color_GreyFont
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(userAccountImageTapped(tapGestureRecognizer:)))
        userAccountLogo.isUserInteractionEnabled = true
        userAccountLogo.addGestureRecognizer(tapGestureRecognizer)
        self.title = "アカウント"
        self.view.backgroundColor = Color_Back
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color_Back
        self.view.addSubview(tableView)
        self.view.addSubview(userAccountLogo)
        self.view.addSubview(userAccountEmail)
        self.view.addSubview(versionLabel)
        userAccountLogo.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        userAccountEmail.snp.makeConstraints { (make) in
            make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(userAccountLogo.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalToSuperview().multipliedBy(0.6)
            make.centerX.equalToSuperview()
            make.top.equalTo(userAccountEmail.snp.bottom).offset(15)
            //make.bottom.equalToSuperview().offset(-20)
        }
        versionLabel.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
        
    }
}

extension HomeMyVC:  UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            LogoutButtonEvent()
        case 1:
            ScoreButtonEvent()
        case 2:
            CanceldButtonEvent()
        case 3:
            setSchoolACButtonEvent()
        default:
            print("no Switch")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let icon = UIImageView()
        let newIcon = UIImageView()
        let text = UILabel()
        icon.image = UIImage(named: "menu_icon_\(indexPath.row)")
        newIcon.isHidden = true
        newIcon.image = UIImage(named: "menu_new_icon")
        text.textColor = Color_GreyFont
        text.text = menuList[indexPath.row]
        text.textAlignment = .center
        text.font = UIFont.boldSystemFont(ofSize: 14)
        cell.addSubview(icon)
        cell.addSubview(newIcon)
        cell.addSubview(text)
        cell.backgroundColor = Color_Back
        icon.snp.makeConstraints { (make) in
            make.height.width.equalTo(25)
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        newIcon.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        text.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if ((newMenu.firstIndex(of: indexPath.row)) != nil) {
            newIcon.isHidden = false
        }
        return cell
    }
    
    
}
