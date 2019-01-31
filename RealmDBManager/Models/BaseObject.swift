//
//  BaseObject.swift
//  RealmDBManager
//
//  Created by sama73 on 2019. 1. 31..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit
import  RealmSwift

class BaseObject: Object {
    
    // 프라이머리키 설정했나?
    class func isPrimaryKey() -> Bool {
        return false
    }
    
    class func createObject(_ dicFields: [String: String]) -> BaseObject {
        let this = self.init()
        
        return this
    }
    
    class func copyObject(object: Object, dicFields: [String: String]) -> BaseObject {
        let this = self.init()
        
        return this
    }
    
    // SQL 실행하다.
    class func SQLExcute(dicTableData: [String: Any]) -> (String, Results<Object>?) {
        
        var RESULT_CODE = "0"
        
        let command: String = dicTableData["COMMAND"] as! String
        if command == "INSERT" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
            let dicFields:[String: String] = dicTableData["FIELDS"] as! [String: String]

            let newItem = createObject(dicFields)
            // isPrimaryKey는 프라이머리키 설정 했는지 유무
            DBManager.sharedInstance.insertSQL(objs: newItem, isPrimaryKey: self.isPrimaryKey())
        }
        else if command == "UPDATE" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
            let condition: String? = dicTableData["WHERE"] as? String
            let dicFields:[String: String] = dicTableData["FIELDS"] as! [String: String]
            
            // 검색후 업데이트해준다.
            if condition != nil {
                let objects = DBManager.sharedInstance.selectSQL(type: self, condition: condition ?? "")?.first
                if objects != nil {
                    let newObject = copyObject(object: objects!, dicFields: dicFields)
                    
                    // isPrimaryKey는 프라이머리키 설정 했는지 유무
                    DBManager.sharedInstance.updateSQL(objs: newObject, isPrimaryKey:  self.isPrimaryKey())
                }
                else {
                    RESULT_CODE = "2"
                }
            }
        }
        else if command == "DELETE" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
            let condition: String? = dicTableData["WHERE"] as? String
            // 검색후 삭제해준다.
            if condition != nil {
                // 조건식 검색해서 존재할 경우
                let objects = DBManager.sharedInstance.selectSQL(type: self, condition: condition ?? "")?.first
                if objects != nil {
                    DBManager.sharedInstance.deleteSQL(objs: objects!)
                }
                else {
                    RESULT_CODE = "2"
                }
            }
        }
        else if command == "SELECT" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
            let condition: String? = dicTableData["WHERE"] as? String
            // 검색 조건이 없을 경우 전체 검색
            if condition == nil {
                return (RESULT_CODE, DBManager.sharedInstance.selectSQL(type: self))
            }
                // 검색 조건이 있을 경우 조건 검색
            else {
                return (RESULT_CODE, DBManager.sharedInstance.selectSQL(type: self, condition: condition ?? ""))
            }
        }
        
        return (RESULT_CODE, nil)
    }
}
