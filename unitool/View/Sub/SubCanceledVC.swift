//
//  SubCanceledVC.swift
//  unitool
//
//  Created by Shuangbing He on 2020/02/05.
//  Copyright © 2020 そうへい. All rights reserved.
//

import UIKit
import SwiftyJSON

var canceledData:[JSON] = []

class SubCanceledVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return canceledData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCanceledCell(date: canceledData[indexPath.row]["date"].stringValue, weekday: canceledData[indexPath.row]["weekday"].intValue, coma: canceledData[indexPath.row]["coma"].intValue, subject: canceledData[indexPath.row]["subject"].stringValue, teacher: canceledData[indexPath.row]["teacher"].stringValue)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    let footerView = UIView()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    func setupVC(){
        self.title = "補講情報"
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backMyEvent(_:)))
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.view)
            make.top.left.equalTo(self.view)
        }
    }
    
    @objc func backMyEvent(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func getCanceledCell(date: String, weekday: Int, coma: Int, subject: String, teacher: String) -> UITableViewCell {
        print(subject)
        let CanceledCell = UITableViewCell(style: .subtitle, reuseIdentifier: "cancelCell")
        CanceledCell.textLabel?.text = "\(subject) (\(teacher))"
        CanceledCell.detailTextLabel?.text = "\(date) \(coma)限目"
        CanceledCell.selectionStyle = .none
        return CanceledCell
    }

}
