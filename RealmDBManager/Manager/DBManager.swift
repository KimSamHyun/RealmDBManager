//
//  DBManager.swift
//  RealmDBManager
//
//  Created by sama73 on 2019. 1. 16..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit
import RealmSwift

class DBManager: NSObject {
    
    static let sharedInstance = DBManager()
    
    var database: Realm!
    
    override init() {
        super.init()
        print("DBManager init")
        
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Apply any necessary migration logic here.
                }
        })
        Realm.Configuration.defaultConfiguration = config
        
        database = try! Realm()
    }
    
    // INSERT문
	func insertSQL(objs: Object, isPrimaryKey: Bool = false) {
        try? database!.write ({
			if isPrimaryKey == true {
				// 프라이머리키 설정되어 있을때...
				database?.add(objs, update: true)
			}
			else {
				database?.add(objs)
			}
        })
    }
    
    // UPDATE문
    func updateSQL(objs: Object, isPrimaryKey: Bool = false) {
        try? database!.write ({
			if isPrimaryKey == true {
				// 프라이머리키 설정되어 있을때...
				database?.add(objs, update: true)
			}
			else {
				database?.add(objs)
			}
        })
    }
    
    // DELETE문
    func deleteDatabase() {
        try! database?.write({
            database?.deleteAll()
        })
    }
    
    // DELETE문
    func deleteSQL(objs : Object) {
        try? database!.write ({
            database?.delete(objs)
        })
    }

    // SELECT문
    func selectSQL(type: Object.Type) -> Results<Object>? {
        return database!.objects(type)
    }
    
    func selectSQL(type: Object.Type, condition: String) -> Results<Object>? {
        return database!.objects(type).filter(condition)
    }
	
	// 명령어 대문자로 변환
	static func commandUppercased(sql: String) -> String {
		var arrCommand = sql.components(separatedBy: " ")
		for i in 0..<arrCommand.count {
			let command = arrCommand[i].uppercased()
			switch command {
			case "INSERT",
				 "INTO",
                 "VALUES",
				 "UPDATE",
				 "SET",
				 "WHERE",
				 "DELETE",
				 "FROM",
				 "SELECT":
				arrCommand[i] = command
				break
			default:
				break
			}

			// INSERT INTO - VALUES
			var arrSubCommand = arrCommand[i].components(separatedBy: "(")
			if arrSubCommand.count == 2 {
				if arrSubCommand[0].uppercased() == "VALUES" {
					arrSubCommand[0] = "VALUES"
				}
				
				arrCommand[i] = arrSubCommand.joined(separator:"(")
			}
		}
		
        let temp1 = arrCommand.joined(separator:" ")
        let temp2 = temp1.replacingOccurrences(of: " (", with: "(")
		
		return temp2
	}
    
    // SQL 실행하다.
    @discardableResult  // <- Result of call to 'SQLExcute(sql:)' is unused
    static func SQLExcute(sql: String) -> Results<Object>? {
		
		let sqlTemp = DBManager.commandUppercased(sql: sql)
        print("\n명령어=\(sqlTemp)")
		
        // SQL Parsing
        guard let dicTableData:[String: Any] = DBManager.SQLParsing(sql: sqlTemp) else {
            print("잘못된 SQL명령어 입니다.")
            return nil
        }
		
		let command: String = dicTableData["COMMAND"] as! String
        if command == "INSERT" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
			let tableName: String = dicTableData["TABLE_NAME"] as! String
            if tableName == "Person" {
                let dicFields:[String: String] = dicTableData["FIELDS"] as! [String : String]
                Person.SQLExcute(command: command, condition: nil, dicFields: dicFields)
            }
        }
        else if command == "UPDATE" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
			let tableName: String = dicTableData["TABLE_NAME"] as! String
			let condition: String? = dicTableData["WHERE"] as? String
			let dicFields:[String: String] = dicTableData["FIELDS"] as! [String : String]
			
            // 검색후 업데이트해준다.
            if tableName == "Person" && condition != nil {
                Person.SQLExcute(command: command, condition: condition, dicFields: dicFields)
            }
        }
        else if command == "DELETE" {
            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
			let tableName: String = dicTableData["TABLE_NAME"] as! String
			let condition: String? = dicTableData["WHERE"] as? String
            // 검색후 삭제해준다.
            if tableName == "Person" && condition != nil {
                Person.SQLExcute(command: command, condition: condition, dicFields: nil)
            }
        }
        else if command == "SELECT" {

            // 테이블 명에 따라서 추가하는 클래스 정보를 다르게 세팅해준다.
			let tableName: String = dicTableData["TABLE_NAME"] as! String
			let condition: String? = dicTableData["WHERE"] as? String
            if tableName == "Person" {
                return Person.SQLExcute(command: command, condition: condition, dicFields: nil)
            }
        }

        return nil
    }
    
    // SQL Parsing
    static func SQLParsing(sql: String) -> [String: Any]? {
        // 앞에 6글자만 잘라서 대문자로 변환
        let command = sql.prefix(6).uppercased()
        if command == "INSERT" {
            let temp1 = sql.mid(12)
            let temp2 = temp1.replacingOccurrences(of: "'|\\)|;", with: "",options: .regularExpression)
            let temp3 = temp2.replacingOccurrences(of: ", ", with: ",")
            let temp4 = temp3.replacingOccurrences(of: " ,", with: ",")
            let arrSQL = temp4.components(separatedBy: " VALUES(")
            if arrSQL.count != 2 {
                print("INSERT 잘못된 명령어")
                return nil
            }
            
            let arrTable = arrSQL[0].components(separatedBy: "(")
            if arrTable.count != 2 {
                print("INSERT 잘못된 명령어")
                return nil
            }

            // 테이블 명령어 정리
            var dicTableData:[String: Any] = [:]
			dicTableData["COMMAND"] = command
			dicTableData["TABLE_NAME"] = arrTable[0]
			let arrField = arrTable[1].components(separatedBy: ",")
			let arrValues = arrSQL[1].components(separatedBy: ",")
			if arrField.count == 0 || arrField.count != arrValues.count {
				return nil
			}
			
			var dicFields:[String: String] = [:]
			for i in 0..<arrField.count {
				// 필드 값 세팅
				let field = arrField[i]
				let value = arrValues[i]
				dicFields[field] = value
			}
			
			dicTableData["FIELDS"] = dicFields
			
            return dicTableData
        }
        else if command == "UPDATE" {
            if sql.contains("WHERE") == false {
                print("UPDATE 잘못된 명령어")
                return nil
            }
            
            let temp1 = sql.mid(7)
            let temp2 = temp1.replacingOccurrences(of: "'|\\)|;", with: "",options: .regularExpression)
            let temp3 = temp2.replacingOccurrences(of: ", ", with: ",")
            let temp4 = temp3.replacingOccurrences(of: " ,", with: ",")
            let arrSQL = temp4.components(separatedBy: " SET ")
            if arrSQL.count != 2 {
                print("INSERT 잘못된 명령어")
                return nil
            }
            
            // 테이블 명령어 정리
            var dicTableData:[String: Any] = [:]
			dicTableData["COMMAND"] = command
			dicTableData["TABLE_NAME"] = arrSQL[0]
            
            let arrCommand = arrSQL[1].components(separatedBy: " WHERE ")
            if arrCommand.count != 2 {
                print("INSERT 잘못된 명령어")
                return nil
            }
			
			let arrDatas = arrCommand[0].components(separatedBy: ",")
			var dicFields:[String: String] = [:]
			for data in arrDatas {
				// 필드 값 세팅
				let arrItem = data.components(separatedBy: "=")
				let field = arrItem[0]
				let value = arrItem[1]
				dicFields[field] = value
			}
			
            dicTableData["FIELDS"] = dicFields
			dicTableData["WHERE"] = arrCommand[1]
            
            return dicTableData
        }
        else if command == "DELETE" {
            let temp1 = sql.mid(12)
            let temp2 = temp1.replacingOccurrences(of: "'|\\)|;", with: "",options: .regularExpression)
            let temp3 = temp2.replacingOccurrences(of: ", ", with: ",")
            let temp4 = temp3.replacingOccurrences(of: " ,", with: ",")

            let arrSQL = temp4.components(separatedBy: " WHERE ")
            
            // 테이블 명령어 정리
            var dicTableData:[String: Any] = [:]
			dicTableData["COMMAND"] = command
			dicTableData["TABLE_NAME"] = arrSQL[0]
            // WHERE
            if arrSQL.count == 2 {
				dicTableData["WHERE"] = arrSQL[1]
            }

            return dicTableData
        }
        else if command == "SELECT" {
            let temp1 = sql.mid(7)
            let temp2 = temp1.replacingOccurrences(of: "'|\\)|;", with: "",options: .regularExpression)
            let temp3 = temp2.replacingOccurrences(of: ", ", with: ",")
            let temp4 = temp3.replacingOccurrences(of: " ,", with: ",")
            
            let arrSQL = temp4.components(separatedBy: " FROM ")
            // 테이블 명령어 정리
            var dicTableData:[String: Any] = [:]
			dicTableData["COMMAND"] = command
			dicTableData["SELECT"] = arrSQL[0]
            
            let arrCommand = arrSQL[1].components(separatedBy: " WHERE ")
			dicTableData["TABLE_NAME"] = arrCommand[0]
            
            // WHERE
            if arrCommand.count == 2 {
				dicTableData["WHERE"] = arrCommand[1]
            }

            return dicTableData
        }
        else {
            return nil
        }
    }
}
