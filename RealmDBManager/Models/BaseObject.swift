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
    
    // SQL 실행하다.
    // command : 명령어
    // condition : 조건식
    // dicFields : 필드명 + 필드값
    class func SQLExcuteRun(command: String, condition: String?, dicFields: [String: String]?) -> Results<Object>? {
        return nil
    }
    
    // SQL 실행하다.
    class func SQLExcute(dicTableData: [String: Any]) -> Results<Object>? {
        
        let command: String = dicTableData["COMMAND"] as! String
        if command == "INSERT" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
            let dicFields:[String: String] = dicTableData["FIELDS"] as! [String: String]
            return SQLExcuteRun(command: command, condition: nil, dicFields: dicFields)
        }
        else if command == "UPDATE" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
            let condition: String? = dicTableData["WHERE"] as? String
            let dicFields:[String: String] = dicTableData["FIELDS"] as! [String: String]
            
            // 검색후 업데이트해준다.
            if condition != nil {
                return SQLExcuteRun(command: command, condition: condition, dicFields: dicFields)
            }
        }
        else if command == "DELETE" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
            let condition: String? = dicTableData["WHERE"] as? String
            // 검색후 삭제해준다.
            if condition != nil {
                return SQLExcuteRun(command: command, condition: condition, dicFields: nil)
            }
        }
        else if command == "SELECT" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
            let condition: String? = dicTableData["WHERE"] as? String
            return SQLExcuteRun(command: command, condition: condition, dicFields: nil)
        }
        
        return nil
    }
}
