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
    let kAppdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = item
    }
    override open func handleCodeResult(arrayResult:[LBXScanResult])
    {
        if let delegate = scanResultDelegate  {
            let rotation : UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight]
            kAppdelegate?.blockRotation = rotation
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
        let rotation : UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight]
        kAppdelegate?.blockRotation = rotation
        self.navigationController!.popViewController(animated: true)
    }
}
