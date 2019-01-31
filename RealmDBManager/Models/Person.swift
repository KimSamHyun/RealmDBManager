//
//  Person.swift
//  RealmDBManager
//
//  Created by sama73 on 2019. 1. 16..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit
import  RealmSwift

class Person: BaseObject {
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
    
    // 프라이머리키 설정했나?
    override class func isPrimaryKey() -> Bool {
        return (primaryKey() != nil)
    }
    
    // 오브젝트 생성
    override class func createObject(_ dicFields: [String: String]) -> Person {
        let this = self.init()
        
        this.SQLParsing(dicFields)
        
        return this
    }
    
    // 오브젝트 복사후 필드값 세팅
    override class func copyObject(object: Object, dicFields: [String: String]) -> Person {
        let newObject: Person = object.copy() as! Person
        newObject.SQLParsing(dicFields)
        
        return newObject
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
}
