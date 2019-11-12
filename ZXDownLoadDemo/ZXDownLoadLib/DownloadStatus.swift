//
//  DownloadStatus.swift
//  ZXDownLoadDemo
//
//  Created by xingxing on 2019/11/7.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation


enum DownloadStatus : String{
    case downloading = "下载中"
    case canceled = "已取消"
    case croping = "正在裁剪"
    case finished = "已完成"
    case paused = "已暂停"
}
