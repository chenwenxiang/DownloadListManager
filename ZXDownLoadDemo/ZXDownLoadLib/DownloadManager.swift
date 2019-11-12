//
//  DownloadManager.swift
//  ZXDownLoadDemo
//
//  Created by xingxing on 2019/11/7.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

class DownloadManager {
    
    static var downloadList = [DownloadModel]()
    
    class func addADownload(videoUrl:NSString, crop : VideoCrop?){
        
        
        if(videoUrl == nil){print("addADownload videoUrl=nil");return}
        let fileType = videoUrl.substring(with: NSRange(location: videoUrl.length-4, length: 4))
            
        if(`fileType` != ".mp4" && fileType != ".MP4" ){print("addADownload videoUrl=nil");return}
        
        
        
//      let videoUrl = "http://192.168.43.1:8899/storage/emulated/0/Movies/USBCameraTest/88801ea7891700000000/out.mp4"
                   
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first! as NSString
        
        let wordList = videoUrl.components(separatedBy: "/")
        
        if(wordList.count < 2){print("下载地址有误:\(videoUrl)");return}
        documentPath.appendingPathComponent(wordList[wordList.count-2])
        
        var destPath = documentPath.appendingPathComponent(wordList[wordList.count - 1]) as String
           
//        if FileManager.default.fileExists(atPath: destPath) {
//               print("file already exist at \(destPath)")
////            self.playVideo(localPath: NSURL(fileURLWithPath: destPath))
//            self.cropVideo(sourceURL1: NSURL(fileURLWithPath: destPath), statTime: 4, endTime: 20)
//               return
//           }
        
        let downloadModel = DownloadModel(downloadUrl: videoUrl as String, urlSession: nil, crop: crop)
        
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: downloadModel, delegateQueue: nil)
        let downloadSession = session.downloadTask(with: URL(string: videoUrl as String)!)
            downloadSession.resume()
        
        downloadModel.urlSession = session
        downloadModel.downloadSession = downloadSession
        
        downloadList.append(downloadModel)
    }
}
