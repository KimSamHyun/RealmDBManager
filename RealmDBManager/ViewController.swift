//
//  ViewController.swift
//  RealmDBManager
//
//  Created by sama73 on 2019. 1. 16..
//  Copyright © 2019년 sama73. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvResult: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tvResult.layer.borderColor = UIColor.black.cgColor
        tvResult.layer.borderWidth = 1.0
    }

    // MARK: - UIButton Action
    // Insert문
    @IBAction func onInsert1Click(_ sender: Any) {
        let sql = "Insert Into Person (id, firstName, lastName, gender, age) Values ('1', '홍', '길동', '0', '32');"
        tvResult.text = sql

        DBManager.SQLExcute(sql: sql)
    }

	@IBAction func onInsert2Click(_ sender: Any) {
        let sql = "Insert Into Person (id, firstName, lastName, gender, age) Values ('2', '임', '꺽정', '0', '30');"
        tvResult.text = sql

        DBManager.SQLExcute(sql: sql)
	}
	
    // Update문
    @IBAction func onUpdateClick(_ sender: Any) {
        let sql = "Update Person Set firstName='홍', lastName='길순', age='37' Where id='1';"
        tvResult.text = sql

        DBManager.SQLExcute(sql: sql)
//        DBManager.SQLExcute(sql: "UPDATE Person SET id='1', firstName='김', lastName='삼돌', age='37', gender='0', age='40';")
    }

    // Delete문 조건 삭제
    @IBAction func onDelete2Click(_ sender: Any) {
        let sql = "Delete From Person Where id='2';"
        tvResult.text = sql

        DBManager.SQLExcute(sql: sql)
    }
    
    // Select문 전체 검색
    @IBAction func onSelect1Click(_ sender: Any) {
        let sql = "Select * From Person;"
        tvResult.text = sql

        if let objects = DBManager.SQLExcute(sql: sql) {
            tvResult.text += "\n\(objects)"
        }
    }
    
    // Select문 조건 검색
    @IBAction func onSelect2Click(_ sender: Any) {
        let sql = "Select * From Person Where id='2';"
        tvResult.text = sql

        if let objects = DBManager.SQLExcute(sql: sql) {
            tvResult.text += "\n\(objects)"
        }
    }
}

