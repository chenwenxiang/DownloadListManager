//
//  DBBean.swift
//  XingCamera
//
//  Created by xingxing on 2019/10/15.
//  Copyright © 2019 xingxing. All rights reserved.
//

import Foundation


class DownloadBean {
    var id: Int!
    var download_url: String!
    var device_id: String!
    var file_url: String!
    var addTime: String!
    
    init(download_url: String, device_id: String, file_url: String, addTime: String) {
        self.download_url = download_url
        self.device_id = device_id
        self.file_url = file_url
        self.addTime = addTime
    }
    
    init(id : Int, download_url: String, device_id: String, file_url: String, addTime: String) {
        self.id = id
        self.download_url = download_url
        self.device_id = device_id
        self.file_url = file_url
        self.addTime = addTime
    }
}
