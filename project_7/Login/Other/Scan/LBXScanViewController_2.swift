//
//  LBXScanViewController.swift
//  swiftScan
//
//  Created by lbxia on 15/12/8.
//  Copyright © 2015年 xialibing. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class LBXScanViewController_2 : LBXScanViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = item
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //该页面显示时强制竖屏显示
        appDelegate.interfaceOrientations = .portrait
    }
    
    override open func handleCodeResult(arrayResult:[LBXScanResult])
    {
        if let delegate = scanResultDelegate  {
            //页面退出时还原强制横屏状态
            appDelegate.interfaceOrientations = [.landscapeRight]
            
            self.navigationController? .popViewController(animated: true)
            let result:LBXScanResult = arrayResult[0]
            
            delegate.scanFinished(scanResult: result, error: nil)
            
        }else{
            
            for result:LBXScanResult in arrayResult
            {
                print("%@",result.strScanned ?? "")
            }
            
            let result:LBXScanResult = arrayResult[0]
            
            showMsg(title: result.strBarCodeType, message: result.strScanned)
        }
    }
    @objc func back(){
        //页面退出时还原强制横屏状态
        appDelegate.interfaceOrientations = [.landscapeRight]
        self.navigationController!.popViewController(animated: true)
    }
}
