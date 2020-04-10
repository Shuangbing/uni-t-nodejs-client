//
//  SubSettingTimeTable.swift
//  unitool
//
//  Created by そうへい on 2018/12/13.
//  Copyright © 2018 そうへい. All rights reserved.
//

import UIKit

@available(iOS 10.0, *)
class SubSettingTimeTable: UIViewController, UIWebViewDelegate{
    
    
    let mainView = UIScrollView()
    
    let periodTotal = InputView()
    let weekdayView = InputView()
    let weekdaySelect = UISegmentedControl()
    let nofityView = InputView()
    let nofitySelector = UISwitch()
    let SaveSetting = InputButton()
    let SyncTimeTable = InputButton()
    let DelectTimeTable = InputButton()
    
    @objc func saveSettingEvent() {
        let periodInt = Int(periodTotal.Input.text ?? "-1")!
        let weekdayInt = weekdaySelect.selectedSegmentIndex
       
        if periodInt >= 1, periodInt <= 8{
            UserSetting["timetable"]["period"].int = periodInt
            UserSetting["timetable"]["weekday"].int = weekdayInt
            UserSetting["timetable"]["nofity"].bool = nofitySelector.isOn
            updateTimeTable()
            UserDefaults.standard.set(UserSetting.rawString(),forKey: "UserSetting")
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            showAlert(type: 2, msg: "時限数は1~8の数字を設置してください")
        }
        
        
    }
    
    @objc func SyncTimeTableEvent() {
        let alert: UIAlertController = UIAlertController(title: "時間割同期", message: "学内情報から今の時間割を自動同期します\n同期が完了すると現在の時間割は削除されます", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "同期", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            SchoolAPI.syncTimetable(completion: { (success, msg, data) in
                switch success{
                case true:
                    updateSubject(data: data)
                    updateTimeTable()
                    self.navigationController?.popToRootViewController(animated: true)
                    showAlert(type: 1, msg: msg ?? "完成")
                case false:
                    showAlert(type: 2, msg: msg ?? "エラー")
                }
            }, team: 1)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("キャンセル")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func DelectTimeTableEvent() {
        let alert: UIAlertController = UIAlertController(title: "時間割削除", message: "現在の時間割は削除されます\n宜しいでしょうか?", preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            delAllSubject()
            updateTimeTable()
            self.navigationController?.popToRootViewController(animated: true)
            showAlert(type: 1, msg: "時間割初期化完了")
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainView.endEditing(true)
    }
    
    func setupVC(){
        self.title = "時間割設定"
        self.view.backgroundColor = Color_White
        
        periodTotal.Lable.text = "時限数"
        periodTotal.Input.keyboardType = .numberPad
        periodTotal.Input.textAlignment = .center
        periodTotal.Input.text = "\(UserSetting["timetable"]["period"].intValue)"
        
        weekdayView.Lable.text = "土日表示"
        weekdayView.Input.isUserInteractionEnabled = false
        weekdayView.Line.isHidden = true
        
        nofityView.Lable.text = nil
        nofityView.Input.isUserInteractionEnabled = false
        nofityView.Line.isHidden = true
        let nofityText = UILabel()
        nofityText.text = "授業開始前通知(10分前)"
        nofityText.textColor = Color_GreyFont
        nofityText.font = UIFont.systemFont(ofSize: 15)
        
        nofitySelector.isOn = UserSetting["timetable"]["nofity"].boolValue
        nofitySelector.onTintColor = Color_GreyFont

        weekdaySelect.insertSegment(withTitle: "しない", at: 0, animated: false)
        weekdaySelect.insertSegment(withTitle: "土", at: 1, animated: false)
        weekdaySelect.insertSegment(withTitle: "土日", at: 2, animated: false)
        weekdaySelect.tintColor = Color_GreyFont
        weekdaySelect.selectedSegmentIndex = UserSetting["timetable"]["weekday"].intValue
        
        SaveSetting.setTitle("保存", for: .normal)
        SaveSetting.addTarget(self, action: #selector(saveSettingEvent), for: .touchUpInside)
        
        SyncTimeTable.setTitle("時間割同期", for: .normal)
        SyncTimeTable.addTarget(self, action: #selector(SyncTimeTableEvent), for: .touchUpInside)
        
        DelectTimeTable.setTitle("時間割初期化", for: .normal)
        DelectTimeTable.addTarget(self, action: #selector(DelectTimeTableEvent), for: .touchUpInside)
        DelectTimeTable.setBackgroundImage(UIImage(color: UIColor.red.lighter()), for: .normal)
        DelectTimeTable.setBackgroundImage(UIImage(color: UIColor.red.lighter().darkened()), for: .highlighted)
        
        
        self.view.addSubview(mainView)
        
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapRecognized))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        mainView.addGestureRecognizer(singleTapGestureRecognizer)
        
        mainView.addSubview(periodTotal)
        mainView.addSubview(weekdayView)
        mainView.addSubview(nofityView)
        mainView.addSubview(SaveSetting)
        mainView.addSubview(SyncTimeTable)
        mainView.addSubview(DelectTimeTable)
        weekdayView.addSubview(weekdaySelect)
        nofityView.addSubview(nofitySelector)
        nofityView.addSubview(nofityText)
        
        mainView.isScrollEnabled = true
        mainView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        periodTotal.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(70)
            make.top.equalToSuperview().offset(25)
            make.centerX.equalToSuperview()
        }
        weekdayView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(70)
            make.top.equalTo(periodTotal.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        weekdaySelect.snp.makeConstraints { (make) in
            make.width.equalTo(weekdayView)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        nofityView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().offset(-50)
            make.height.equalTo(70)
            make.top.equalTo(weekdaySelect.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        nofityText.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        nofitySelector.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        }
        SaveSetting.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.height.equalTo(50)
            make.top.equalTo(nofityView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        SyncTimeTable.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(SaveSetting.snp.bottom).offset(15)
        }
        DelectTimeTable.snp.makeConstraints { (make) in
            make.width.equalTo(250)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(SyncTimeTable.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func tapRecognized() {
        self.view.endEditing(true)
    }
}
