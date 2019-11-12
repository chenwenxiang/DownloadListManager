//
//  DeviceDB.swift
//  XingCamera
//
//  Created by xingxing on 2019/10/12.
//  Copyright © 2019 xingxing. All rights reserved.
//

import UIKit
import SQLite3


//let goods = DeviceBean(device_name: "ZNYJS", ssid: "ZNYJS", passwd: "adminfff")
//var goodArr = [DeviceBean]()
var db: OpaquePointer?

let downloadDB = DownloadDB()



class DownloadDB: NSObject {
    
    
    override init() {
        super.init()
        print("DownloadDB init()")
        
        db = self.openDatabase()
        createTable()
    }
    
    private func createTable(){
        let createTableString = """
       CREATE TABLE DownloadVideo(
       Id INTEGER PRIMARY KEY AUTOINCREMENT,
       download_url CHAR(200),
       device_id CHAR(100),
       file_url CHAR(200),
       addTime CHAR(50));
       """
        var createTableStatement: OpaquePointer?
        // 第一步
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 第二步
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("成功创建表")
            } else {
                print("未成功创建表")
            }
        } else {
            
        }
        //第三步
      sqlite3_finalize(createTableStatement)
        
    }
    
    private func openDatabase() -> OpaquePointer? {
        
        var dbPath = ""
        func fetchLibraryPath() {
            if let libraryPathString = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first {
                let pathURL = URL(fileURLWithPath: libraryPathString).appendingPathComponent("device.sqlite")
                dbPath = pathURL.path
            }
        }

        fetchLibraryPath()
        
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print( "成功打开数据库，路径：\(dbPath)")
            return db
        } else {
            print( "打开数据库失败")
            return nil
        }
    }
    
    func insertOneData( device : DownloadBean) {
        let insertRowString = "INSERT INTO DownloadVideo ( download_url, device_id, file_url, addTime) VALUES ( ?, ?, ?, ?);"
        var insertStatement: OpaquePointer?
        //第一步
        if sqlite3_prepare_v2(db, insertRowString, -1, &insertStatement, nil) == SQLITE_OK {
            //第二步
            let id: Int32 = 1
            //第二步
//            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 1, device.download_url, -1, nil)
            sqlite3_bind_text(insertStatement, 2, device.device_id, -1, nil)
            sqlite3_bind_text(insertStatement, 3, device.file_url, -1, nil)
            sqlite3_bind_text(insertStatement, 4, device.addTime, -1, nil)
            
            //第三步
            if sqlite3_step(insertStatement) == SQLITE_DONE {
               print("插入数据成功")
                
            } else {
                print( "插入数据失败")
            }
        } else {
            
        }
        //第四步
        sqlite3_finalize(insertStatement)
    }
    
    func updateData() {
        let updateString = "UPDATE Computer SET Name = 'changeComputer' WHERE Id = 2;"
        var updateStatement: OpaquePointer?
        //第一步
        if sqlite3_prepare_v2(db, updateString, -1, &updateStatement, nil) == SQLITE_OK {
            //第二步
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print( "更新成功" )
            } else {
                
            }
        }
        //第三步
        sqlite3_finalize(updateStatement)
    }
    func deleteData(id: Int) {
        let deleteString = "DELETE FROM DownloadVideo WHERE Id = \(id);"
        var deleteStatement: OpaquePointer?
        //第一步
        if sqlite3_prepare_v2(db, deleteString, -1, &deleteStatement, nil) == SQLITE_OK {
            //第二步
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print( "删除成功" )
            }
        } else {
            
        }
        //第三步
        sqlite3_finalize(deleteStatement)
    }
    
    func queryOneData(id : Int) {
        let queryString = "SELECT * FROM DownloadVideo WHERE Id == \(id);"
        var queryStatement: OpaquePointer?
        //第一步
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            //第二步
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                //第三步
                let id = sqlite3_column_int(queryStatement, 0)
                
                var queryResultName = sqlite3_column_text(queryStatement, 1)
                let device_name = String(cString: queryResultName!)
                
                 queryResultName = sqlite3_column_text(queryStatement, 2)
                let ssid = String(cString: queryResultName!)
                
                queryResultName = sqlite3_column_text(queryStatement, 3)
                let passwd = String(cString: queryResultName!)
                
//                let weight = sqlite3_column_int(queryStatement, 2)
//                let price = sqlite3_column_double(queryStatement, 3)
                
                
                print(  "id: \(id), device_name: \(device_name), ssid: \(ssid), passwd: \(passwd)" )
            } else {
                print( "error" )
            }
        }
        //第四步
        sqlite3_finalize(queryStatement)
    }
    
    func queryAllData() -> NSMutableArray{
        let queryString = "SELECT * FROM DownloadVideo;"
        var queryStatement: OpaquePointer?
        
        var deviceList = NSMutableArray()
        //第一步
        if sqlite3_prepare_v2(db, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            //第二步
            while(sqlite3_step(queryStatement) == SQLITE_ROW) {
                //第三步
                let id = sqlite3_column_int(queryStatement, 0)
                
                var queryResultName = sqlite3_column_text(queryStatement, 1)
                let download_url = String(cString: queryResultName!)
                
                 queryResultName = sqlite3_column_text(queryStatement, 2)
                let device_id = String(cString: queryResultName!)
                
                 queryResultName = sqlite3_column_text(queryStatement, 3)
                let file_url = String(cString: queryResultName!)
                
                 queryResultName = sqlite3_column_text(queryStatement, 4)
                let addTime = String(cString: queryResultName!)
                
                let device = DownloadBean(id:Int(id), download_url: download_url, device_id: device_id, file_url: file_url, addTime: addTime)
                deviceList.add(device)
                
//                let weight = sqlite3_column_int(queryStatement, 2)
//                let price = sqlite3_column_double(queryStatement, 3)
                
                
                print(  "id: \(id), download_url: \(download_url), device_id: \(device_id), file_url: \(file_url)" )
            }
        }
        //第四步
        sqlite3_finalize(queryStatement)
        
        return deviceList
    }
    
}
