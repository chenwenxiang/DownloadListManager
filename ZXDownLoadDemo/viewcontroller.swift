//
//  ManAcitivty.swift
//  ZXDownLoadDemo
//
//  Created by xingxing on 2019/11/2.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import AVKit





class viewcontroller : UIViewController, URLSessionDownloadDelegate{
    
    private var player: AVPlayer!
    private var palyerItem: AVPlayerItem!
    
    private var playerLayer:AVPlayerLayer?
    
    @IBOutlet weak var uiview_videoSuperView: UIView!
    var uiview_videoView: UIView?
    
    
    var urlArray : [String] =
        ["http://192.168.43.1:8899/storage/emulated/0/Movies/USBCameraTest/88801ea7891700000000/2019-10-09-16-31-55.mp4"
        ,"http://192.168.43.1:8899/storage/emulated/0/Movies/USBCameraTest/88801ea7891700000000/2019-10-11-00-00-00.mp4"
        ,"http://192.168.43.1:8899/storage/emulated/0/Movies/USBCameraTest/88801ea7891700000000/out.mp4"]
    
    var downCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.download()
        
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        print("documentPath="+(documentPath as String))
    }
    
    @IBAction func handle_downloading(_ sender: Any) {
        
        DownloadManager.addADownload(videoUrl: "http://192.168.43.1:8899/storage/emulated/0/Movies/USBCameraTest/88801ea7891700000000/out.mp4", crop: VideoCrop(startTime: 4,endTime: 5))
    }
    
    @IBAction func handle_downloading2(_ sender: Any) {

        DownloadManager.addADownload(videoUrl: "http://192.168.43.1:8899/storage/emulated/0/Movies/USBCameraTest/88801ea7891700000000/2019-10-09-16-31-55.mp4", crop: nil)
    }
    
    @IBAction func handle_downloading3(_ sender: Any) {
        
        DownloadManager.addADownload(videoUrl: "http://192.168.43.1:8899/storage/emulated/0/Movies/USBCameraTest/88801ea7891700000000/2019-10-11-00-00-00.mp4", crop: nil)
    }
    
    @IBAction func handle_list(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle:
            nil).instantiateViewController(withIdentifier: "VC_DownloadManager")
        
        self.navigationController?.pushViewController(vc, animated: true)
            //.instantiateViewController(identifier: "downlist")
    }
    
    func download() {
           
        let videoUrl = "http://192.168.43.1:8899/storage/emulated/0/Movies/USBCameraTest/88801ea7891700000000/out.mp4"
           
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        let destPath = NSString(string: documentPath).appendingPathComponent("video2.mp4") as String
           
        if FileManager.default.fileExists(atPath: destPath) {
               print("file already exist at \(destPath)")
//            self.playVideo(localPath: NSURL(fileURLWithPath: destPath))
            self.cropVideo(sourceURL1: NSURL(fileURLWithPath: destPath), statTime: 4, endTime: 20)
               return
        }
        
        var session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        session.downloadTask(with: URL(string: videoUrl)!).resume()
//        session.downloadTask(with: URL(string: videoUrl)!) { (location, response, err) in
//
//            print("compeletioned location=\(location)")
//
//              if let _ = location {
//                             do {
//                                try FileManager.default.moveItem(at: location!, to: NSURL(fileURLWithPath: destPath) as URL)
//                                print("move done")
//                                self.playVideo(localPath: NSURL(fileURLWithPath: destPath))
//                             }
//                             catch let error as NSError {
//                                 print("move file error: \(error.localizedDescription)")
//                             }
//                         } else {
//                             print("location err: \(location)")
//                         }
//        }.resume()
        
       }

    private func playVideo(localPath:NSURL) {

        DispatchQueue.main.async(execute: {

        self.player = AVPlayer(url: localPath as URL)
           
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = self.view.frame
           self.view.layer.addSublayer(self.playerLayer!)
           self.player?.play()
        })
    }
    
    
    
    
    func play(url:String){
        //创建媒体资源管理对象
        self.palyerItem = AVPlayerItem(url: NSURL(string: url)! as URL)
        //创建ACplayer：负责视频播放
        self.player = AVPlayer.init(playerItem: self.palyerItem)
        self.player.rate = 1.0//播放速度 播放前设置
        //创建显示视频的图层
        let playerLayer = AVPlayerLayer.init(player: self.player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        //播放
        self.player.play()
    }
    
    

    func cropVideo(sourceURL1: NSURL, statTime:Float, endTime:Float)
    {
        let manager = FileManager.default

        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first!
        
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
            
            var outputURL = URL(fileURLWithPath: NSString(string: documentDirectory).appendingPathComponent("output"))
            
            do {
                try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
                let name = "2222"
                outputURL = outputURL.appendingPathComponent("\(name).mp4")
            }catch let error {
                print(error)
            }
            
            //Remove existing file
            _ = try? manager.removeItem(at:  outputURL)
            
            
            guard let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {return}
            exportSession.outputURL = outputURL
            exportSession.outputFileType = AVFileType.mp4
            
            let startTime = CMTime(seconds: Double(start ?? 0), preferredTimescale: 1000)
            let endTime = CMTime(seconds: Double(end ?? length), preferredTimescale: 1000)
            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange
            exportSession.exportAsynchronously{
                switch exportSession.status {
                case .completed:
                    print("completedexported at \(outputURL.absoluteString)")

                    self.playVideo(localPath: outputURL as NSURL)
                    
//                        UISaveVideoAtPathToSavedPhotosAlbum(outputURL.path, self, nil, nil)
//                    self.saveVideoTimeline(outputURL)
                    
                case .failed:
                    print("failed \(exportSession.error)")
                    
                case .cancelled:
                    print("cancelled \(exportSession.error)")
                    
                default: break
                }
            }
        }
    }
        
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("bytesWritten=\(bytesWritten)")
        print("totalBytesWritten=\(totalBytesWritten)")
        print("totalBytesExpectedToWrite=\(totalBytesExpectedToWrite)")
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("didFinishDownloadingTo=\(location.absoluteString)")
    }
}


