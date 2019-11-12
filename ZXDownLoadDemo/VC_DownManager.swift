//
//  VC_DownManager.swift
//  ZXDownLoadDemo
//
//  Created by xingxing on 2019/11/8.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit


class VC_DownloadManager : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var uitv_tableview: UITableView!
    
    @IBOutlet weak var uibu_downloading: UIButton!
    @IBOutlet weak var uibu_downloaded: UIButton!
    
    @IBOutlet weak var uiview_menuBottom: UIView!
    
    /**
     * @param type 1:正在下载。2:已下载
     */
    var  type = 1;
    let menuNumber = 2
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiview_menuBottom.frame.origin.x = SCREEN_WIDTH / 4 - ( uiview_menuBottom.frame.width / 2 )
    }
    
    
    @IBAction func handle_menu(_ sender: UIButton) {
        
        type = sender.tag - 100
        let gotoX = CGFloat(type - 1) * (SCREEN_WIDTH / 2.0) +  (SCREEN_WIDTH / 4.0) -  uiview_menuBottom.frame.width / 2.0
        
        uibu_downloading.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        uibu_downloaded.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
      
        sender.setTitleColor( UIColor.darkGray, for: UIControl.State.normal)
        
        if gotoX != self.uiview_menuBottom.frame.origin.x
        {
            UIView.animate(withDuration: 0.3) {
                self.uiview_menuBottom.frame.origin.x = gotoX
            }
//            page = 1
//            queryMessageList(loadType: .loadRefresh)
            
            self.uitv_tableview.reloadData()
        }
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 1{
            return DownloadManager.downloadList.count
        }else{
            return downloadDB.queryAllData().count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_download") as! Cell_DownloadManager
        
        if type == 1{
            //TODO:可能会出现并发问题
            if indexPath.row < DownloadManager.downloadList.count{
            let downloadModel =  DownloadManager.downloadList[indexPath.row]
                downloadModel.delegate = cell
                cell.setModel(downloadModel: downloadModel)
            }
        }else{
            
            let downloadList = downloadDB.queryAllData()
            //TODO:可能会出现并发问题
            if indexPath.row < downloadList.count{
                let downloadBean = downloadList[indexPath.row] as! DownloadBean
                let downloadModel = DownloadModel(downloadUrl: downloadBean.download_url, tfileUrl: downloadBean.file_url, addTime : downloadBean.addTime, status: .finished)
                
                
                cell.setModel(downloadModel: downloadModel)
            }
        }
        
        
        return cell
    }
    
    
}


