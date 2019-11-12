//
//  Cell_DownloadManager.swift
//  ZXDownLoadDemo
//
//  Created by xingxing on 2019/11/8.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import AVKit



class Cell_DownloadManager : UITableViewCell, DownloadDelegate{

    
    @IBOutlet weak var uila_processing: UILabel!
    @IBOutlet weak var uila_time: UILabel!
    @IBOutlet weak var uila_fileName: UILabel!
    @IBOutlet weak var uila_status: UILabel!
    @IBOutlet weak var uibu_opr: UIButton!
    
    var downloadModel : DownloadModel?
    
    private var player: AVPlayer!
    private var palyerItem: AVPlayerItem!
    
    private var playerLayer:AVPlayerLayer?
    
    func setModel(downloadModel : DownloadModel){
        self.downloadModel = downloadModel
        
        if self.downloadModel != nil{
            let domainSplit = ( self.downloadModel!.downloadUrl! as NSString).components(separatedBy: "/")
            uila_fileName.text = domainSplit[domainSplit.count - 1]
            uila_time.text = (self.downloadModel!.addTime as! NSString).substring(with: NSRange(location: 0, length: 10))
            
            self.uila_status.text = downloadModel.status!.rawValue
            
            if downloadModel.hasDownloaded != nil && downloadModel.totalDownload != nil{
                var percent = Float(downloadModel.hasDownloaded!) / Float(downloadModel.totalDownload!) * 100
                self.uila_processing.text = "\(percent)%"
            }
            
            switch downloadModel.status! {
            case .downloading:
//                uibu_opr.setTitle("暂停", for: UIControl.State.normal)
                uibu_opr.setImage(UIImage(named: "icon_download_start"), for: UIControl.State.normal)
                break;
            case .finished,.croping:
//                uibu_opr.setTitle("播放", for: UIControl.State.normal)
                uibu_opr.setImage(UIImage(named: "icon_download_play"), for: UIControl.State.normal)
                break;
            default:
//                uibu_opr.setTitle("继续", for: UIControl.State.normal)
                uibu_opr.setImage(UIImage(named: "icon_download_stop"), for: UIControl.State.normal)
                break;
            }
        }
    }
    
    @IBAction func handle_opr(_ sender: Any) {
        if downloadModel?.status == DownloadStatus.downloading{
            downloadModel?.downloadSession?.suspend()
//            self.uibu_opr.setTitle("继续", for: UIControl.State.normal)
            self.uibu_opr.setImage(UIImage(named: "icon_download_stop"), for: UIControl.State.normal)
            downloadModel?.status = .paused
        }else if downloadModel?.status == DownloadStatus.paused{
            downloadModel?.downloadSession?.resume()
//            self.uibu_opr.setTitle("暂停", for: UIControl.State.normal)
            self.uibu_opr.setImage(UIImage(named: "icon_download_start"), for: UIControl.State.normal)
            downloadModel?.status = .downloading
        }else if downloadModel?.status == DownloadStatus.finished{
            //已完成，点击播放
            print("\(self.superview?.superview?.superview)")
            if downloadModel!.fileUrl != nil{
                playVideo(playview: (self.superview?.superview?.superview)!, localPath: downloadModel!.fileUrl! )
            }
            return
        }
        self.uila_status.text = downloadModel!.status!.rawValue
    }
    
    
    func downloadBytesChange(httpUrl: String, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        DispatchQueue.main.async(execute: {

            var percent = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
            self.uila_processing.text = "\(percent)%"
        })
    }
    
    func downloadStatusChange(httpUrl: String, status: DownloadStatus) {
        DispatchQueue.main.async(execute: {
            print("downloadStatusChange")
            self.uila_status.text = status.rawValue
            
            switch status {
            case .downloading:
                self.uibu_opr.setTitle("暂停", for: UIControl.State.normal)
                self.uibu_opr.setImage(UIImage(named: "icon_download_start"), for: UIControl.State.normal)
                break;
            case .finished:
                self.uibu_opr.setTitle("播放", for: UIControl.State.normal)
                self.uibu_opr.setImage(UIImage(named: "icon_download_play"), for: UIControl.State.normal)
                break;
            default:
                self.uibu_opr.setTitle("继续", for: UIControl.State.normal)
                self.uibu_opr.setImage(UIImage(named: "icon_download_stop"), for: UIControl.State.normal)
                break;
            }
        })
    }
    
    
    private func playVideo(playview : UIView, localPath : String) {


        print("play path=" + localPath)
        self.player = AVPlayer(url: URL(fileURLWithPath: localPath))
           
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.frame = playview.frame
           playview.layer.addSublayer(self.playerLayer!)
           self.player?.play()
        
    }
}
