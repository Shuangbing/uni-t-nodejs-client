//
//  DBManage.swift
//  unitool
//  数据库管理类
//  Created by そうへい on 2018/11/20.
//  Copyright © 2018 そうへい. All rights reserved.
//
import SwiftyJSON
import RealmSwift

let Database_config = Realm.Configuration(schemaVersion: 2)
let Database = try! Realm(configuration: Database_config)
class User: Object {
    @objc dynamic var id = ""
    @objc dynamic var email = ""
    @objc dynamic var access_token = ""
    @objc dynamic var refresh_token = ""
    @objc dynamic var authHashCode = ""
    @objc dynamic var school = ""
}

class TimeTable: Object {
    @objc dynamic var week = -1
    @objc dynamic var coma = -1
    @objc dynamic var subject = ""
    @objc dynamic var classroom = ""
    @objc dynamic var teacher = ""
    @objc dynamic var bgColor = -1
    @objc dynamic var subjectCode = ""
}


func delAllSubject(){
    try! Database.write {
        Database.delete(Database.objects(TimeTable.self))
    }
}


func readAllSubject()->Results<TimeTable>{
    let subjectData = Database.objects(TimeTable.self)
    return subjectData
}

func updateSubject(data: [JSON]) {
    
    try! Database.write {
        Database.delete(Database.objects(TimeTable.self))
    }
    
    for (index, sub) in data.enumerated() {
        let subject = TimeTable()
        subject.week = sub["week"].intValue
        subject.coma = sub["time"].intValue
        subject.subject = sub["lesson_name"].stringValue
        subject.teacher = sub["lesson_teacher"].stringValue
        subject.classroom = ""
        if(index <= SubjectColor.count - 1)
        {
            subject.bgColor = index
        }else{
            subject.bgColor = Int(arc4random()%7)
        }
        subject.subjectCode = sub["code"].stringValue
        try! Database.write {
            Database.add(subject)
        }
    }
}

func delectOneSubject(week: Int, coma: Int) {
    let sub = Database.objects(TimeTable.self).filter("week == \(week) && coma == \(coma)")
    try! Database.write {
        Database.delete(sub)
    }
}

func addOneSubject(subject: TimeTable) {
    delectOneSubject(week: subject.week, coma: subject.coma)
    try! Database.write {
        Database.add(subject)
    }
}

func editOneSubject(week: Int, coma: Int, subject: TimeTable){
    delectOneSubject(week: week, coma: coma)
    try! Database.write {
        Database.add(subject)
    }
}

func addSubject(subject: TimeTable){
    try! Database.write {
        Database.add(subject)
    }
}

func addUser(user: User) {
    try! Database.write {
        Database.add(user)
    }
}

func readUser() -> User {
    let UserData = Database.objects(User.self).first
    return UserData ?? User()
}

func updateAuthToken(token: String){
    let UserData = Database.objects(User.self).first
    try! Database.write {
        UserData?.authHashCode = token
    }
}

func updateToken(token_new: String){
    let UserData = Database.objects(User.self).first
    try! Database.write {
        UserData?.access_token = token_new
    }
}

func updateTokenByRefresh(access_token: String, refresh_token: String){
    let UserData = Database.objects(User.self).first
    try! Database.write {
        UserData?.access_token = access_token
        UserData?.refresh_token = refresh_token
    }
}

func logoutUser() {
    UserApi.logout()
    try! Database.write {
        Database.delete(Database.objects(User.self))
    }
    UserData = User()
}
