//
//  DownloadModel.swift
//  ZXDownLoadDemo
//
//  Created by xingxing on 2019/11/7.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation
import AVKit


class DownloadModel :  NSObject, URLSessionDownloadDelegate{

    var downloadUrl : String? = nil
    var fileUrl : String? = nil
    var urlSession : URLSession? = nil
    var downloadSession : URLSessionDownloadTask? = nil
    var status : DownloadStatus?
    var videoCrop : VideoCrop?
    var delegate : DownloadDelegate?
    var hasDownloaded : Int64?      //已下载的字节
    var totalDownload : Int64?      //总的需要下载
    var addTime : String?
    
    var deviceSN : String?
    
    
    let CROP_DIRECTORY = "crop"
    
    init(downloadUrl : String, urlSession : URLSession?, crop : VideoCrop?) {
        self.downloadUrl = downloadUrl
        self.urlSession = urlSession
        self.status = DownloadStatus.downloading
        self.videoCrop = crop
        self.addTime = MyDate.today()
    }
    
    
    init(downloadUrl : String, tfileUrl : String, addTime : String, status : DownloadStatus) {
        self.downloadUrl = downloadUrl
        self.status = status
        self.fileUrl = tfileUrl
        self.addTime = addTime
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        hasDownloaded = totalBytesWritten
        totalDownload = totalBytesExpectedToWrite
        
        delegate?.downloadBytesChange(httpUrl: downloadUrl!, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if location != nil {
            do {
                
                var destPath =  self.getSaveFilePath()
                
                if videoCrop != nil{
                    destPath = self.getSaveFilePath(isCrop: true)
                }
                
                if destPath != nil{
                
                
                    print("准备移动文件 \(location.absoluteString) 到 \(destPath)")
                    try FileManager.default.moveItem(at: location, to: NSURL(fileURLWithPath: destPath! as String) as URL)
                    print("移动文件完成")
                    
                    
                    if videoCrop != nil{
                         print("准备裁剪")
                        let cropResultPath = self.getSaveFilePath(isCrop: false)
                        self.cropVideo(sourceURL1: NSURL(fileURLWithPath: destPath! as String), targetURL: cropResultPath as! String, statTime: Float(videoCrop!.startTime), endTime: Float(videoCrop!.endTime))
                    }else{
                        fileUrl = destPath! as String

                        status = .finished
                        delegate?.downloadStatusChange(httpUrl: downloadUrl!, status: .finished)
                        
                        if self.deviceSN != nil{
                            downloadDB.insertOneData(device: DownloadBean(download_url: downloadUrl!, device_id: self.deviceSN!, file_url: fileUrl!, addTime: MyDate.today()))
                        }else{
                            print("self.deviceSN == nil")
                        }
                    }


                }
            }
            catch let error as NSError {
                print("move file error: \(error.localizedDescription)")
            }
        } else {
            print("location err: \(location)")
        }

    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("didCompleteWithError")
    }
    
    
    /******************************
     根据
     *******************************/
    func getSaveFilePath(isCrop : Bool = false) -> NSString?{
        
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        var docuPathNSString = NSString(string: documentPath)
        
        let words = (downloadUrl! as NSString).components(separatedBy: "/")
        if words.count > 2{

            self.deviceSN = words[words.count - 2]
            
            if videoCrop != nil && isCrop == true{
                docuPathNSString = docuPathNSString.appendingPathComponent("crop") as NSString
            }else{
                docuPathNSString = docuPathNSString.appendingPathComponent(self.deviceSN! ) as NSString
            }
            docuPathNSString = docuPathNSString.appendingPathComponent(words[words.count - 1]) as NSString

            print("保存目录：\(docuPathNSString)")
            let manager = FileManager.default
            
            if !manager.fileExists(atPath: docuPathNSString as String){
                do {
                    try manager.createDirectory(at:URL(fileURLWithPath: docuPathNSString as String), withIntermediateDirectories: true, attributes: nil)
                    print("创建目录成功：\(docuPathNSString)")


                }catch let error {
                    print(error)
//                    return nil
                }
            }

            if manager.fileExists(atPath: docuPathNSString as String){
                
                do {
                    print("文件已存在，准备删除已存在的文件：\(docuPathNSString)")
                    try manager.removeItem(atPath: docuPathNSString as String)
                    print("删除已存在的文件成功：\(docuPathNSString)")

                    }catch let error {
                        print(error)
                        return nil
                    }
            }
            
            return docuPathNSString
        }
        return nil
    }
    

    func cropVideo(sourceURL1: NSURL, targetURL : String, statTime:Float, endTime:Float)
    {
        let manager = FileManager.default

//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        
        guard let mediaType = "mp4" as? String else {return}
        guard let url = sourceURL1 as? NSURL else {return}
        
//        if mediaType == kUTTypeMovie as String || mediaType == "mp4" as String {
        
        print("mediaType=\(mediaType)")
        if  mediaType == "mp4" as String {
            let asset = AVAsset(url: url as URL)
            let length = Float(asset.duration.value) / Float(asset.duration.timescale)
            print("asset.duration.value: \(asset.duration.value) ")
            print("asset.duration.timescale: \(asset.duration.timescale) ")
            print("video length: \(length) seconds")
            print("asset: \(asset) ")
            
            let start = statTime
            let end = endTime
            
//            var outputURL = URL(fileURLWithPath: NSString(string: documentDirectory).appendingPathComponent("output"))
//
//            do {
//                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
//                let name = "2222"
//                outputURL = outputURL.appendingPathComponent("\(name).mp4")
//            }catch let error {
//                print(error)
//            }
            var outputURL = targetURL

            //Remove existing file
            _ = try? manager.removeItem(at:  URL(fileURLWithPath: outputURL) )
            
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = URL(fileURLWithPath:outputURL)
            exportSession.outputFileType = AVFileType.mp4
            
            let startTime = CMTime(seconds: Double(start ?? 0), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ?? length), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange
            
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    print("crop completed exported at \(outputURL)")

                    self.fileUrl = outputURL

                    self.status = .finished
                    self.delegate?.downloadStatusChange(httpUrl: self.downloadUrl!, status: .finished)
                    
                    if self.deviceSN != nil{
                        downloadDB.insertOneData(device: DownloadBean(download_url: self.downloadUrl!, device_id: self.deviceSN!, file_url: outputURL, addTime: MyDate.today()))
                    }else{
                        print("self.deviceSN == nil")
                    }
                    
                case .failed:
                    print("failed \(exportSession.error)")
                    
                case .cancelled:
                    print("cancelled \(exportSession.error)")
                    
                default: break
                }
            }
        }
    }
            
}

protocol DownloadDelegate {
    func downloadBytesChange(httpUrl : String, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
    func downloadStatusChange(httpUrl : String, status : DownloadStatus)
}

