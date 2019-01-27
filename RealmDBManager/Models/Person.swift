//
//  Person.swift
//  RealmDBManager
//
//  Created by sama73 on 2019. 1. 16..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit
import  RealmSwift

class Person: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var gender: Int = 0
    @objc dynamic var age: Int = 0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: Int, firstName: String, lastName: String, age: Int, gender: Int) {
        self.init()
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.gender = gender
    }
}


extension Person: NSCopying {
	// 클래스 복사
	func copy(with zone: NSZone? = nil) -> Any {
		let copy = Person(id: id,
						  firstName: firstName,
						  lastName: lastName,
						  age: age,
						  gender: gender)
		
		return copy
	}
	
	convenience init(_ dicFields: [String: String]) {
		self.init()
		
		self.SQLParsing(dicFields)
	}
	
	// 필드 값 세팅
	func setField(field: String, value: String) {
		
		if field == "id" {
			self.id = Int(value) ?? 0
		}
		else if field == "firstName" {
			self.firstName = value
		}
		else if field == "lastName" {
			self.lastName = value
		}
		else if field == "age" {
			self.age = Int(value) ?? 0
		}
		else if field == "gender" {
			self.gender = Int(value) ?? 0
		}
	}
	
	// SQL 파싱
	func SQLParsing(_ dicFields: [String: String]) {
		
		for key in dicFields.keys {
			// 필드 값 세팅
			self.setField(field: key, value: dicFields[key]!)
		}
	}
	
	// SQL 실행하다.
	@discardableResult  // <- Result of call to 'SQLExcute(sql:)' is unused
	// command : 명령어
	// condition : 조건식
	// dicFields : 필드명 + 필드값
	static func SQLExcute(command: String, condition: String?, dicFields: [String: String]?) -> Results<Object>? {
		
		if command == "INSERT" {
			let newPerson = Person(dicFields!)
			
			// isPrimaryKey는 프라이머리키 설정 했는지 유무
			DBManager.sharedInstance.insertSQL(objs: newPerson, isPrimaryKey: true)
		}
		else if command == "UPDATE" {
			// 조건식 검색해서 존재할 경우
			let objects = DBManager.sharedInstance.selectSQL(type: Person.self, condition: condition ?? "")?.first
			if objects != nil {
				let newPerson: Person = objects?.copy() as! Person
				
				// 변경된 내용 수정
				newPerson.SQLParsing(dicFields!)
				
				// isPrimaryKey는 프라이머리키 설정 했는지 유무
				DBManager.sharedInstance.updateSQL(objs: newPerson, isPrimaryKey: true)
			}
		}
		else if command == "DELETE" {
			// 조건식 검색해서 존재할 경우
			let objects = DBManager.sharedInstance.selectSQL(type: Person.self, condition: condition ?? "")?.first
			if objects != nil {
				DBManager.sharedInstance.deleteSQL(objs: objects!)
			}
		}
		else if command == "SELECT" {
			// 검색 조건이 없을 경우 전체 검색
			if condition == nil {
				return DBManager.sharedInstance.selectSQL(type: Person.self)
			}
				// 검색 조건이 있을 경우 조건 검색
			else {
				return DBManager.sharedInstance.selectSQL(type: Person.self, condition: condition ?? "")
			}
		}
		
		return nil
	}
}
