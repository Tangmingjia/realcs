//
//  ViewController.swift
//  project_7
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import Starscream
class LoginViewController: UIViewController,LBXScanViewControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    let kAppdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var webView: WKWebView!
    var Login : LoginView?
    var packageNo : String = ""
    var person_id : Int = 0
    var game_id : Int = 0
    var team_id : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
        let rotation : UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight]
        kAppdelegate?.blockRotation = rotation
        
        Login = LoginView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
        self.view.addSubview(Login!)
        
        Login?.TextField?.delegate = self
        Login?.LoginButton?.addTarget(self, action: #selector(login), for: .touchUpInside)
        Login?.ScanButton?.addTarget(self, action: #selector(scan), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @objc func login(){
        packageNo = (Login?.TextField?.text)!
        Alamofire.request("http://\(Host().Host):8998/package/getPersonByPackageNo", method: .get, parameters: ["packageNo": packageNo]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = Model_1.deserialize(from: jsonString) {
                        if responseModel.respCode != "200" {
                            self.hud()
                        }else{
                            self.person_id = responseModel.data.person_id
                            self.game_id = responseModel.data.game_id
                            self.team_id = responseModel.data.team_id
                            let vc = GameViewController()
                            vc.packageNo = self.packageNo
                            vc.game_id = self.game_id
                            vc.person_id = self.person_id
                            vc.team_id = self.team_id
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }else{
                self.hud_2()
            }
        }
    }
    @objc func scan(){
        LBXPermissions.authorizeCameraWith { [weak self] (granted) in
            if granted {
                self?.scanQrCode()
            } else {
                LBXPermissions.jumpToSystemPrivacySetting()
            }
        }
    }
    func scanQrCode() {
        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 60
        style.xScanRetangleOffset = 30
        if UIScreen.main.bounds.size.height <= 480 {
            //3.5inch 显示的扫码缩小
            style.centerUpOffset = 40
            style.xScanRetangleOffset = 20
        }
        style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2.0
        style.photoframeAngleW = 16
        style.photoframeAngleH = 16
        style.isNeedShowRetangle = false
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid
        style.animationImage = UIImage(named: "qrcode_scan_full_net.png")
        let vc = LBXScanViewController_2()
        vc.scanStyle = style
        vc.scanResultDelegate = self
        kAppdelegate?.blockRotation = .portrait
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scanFinished(scanResult: LBXScanResult, error: String?) {
//            print("扫描结果：" + scanResult.strScanned!)
        packageNo = scanResult.strScanned!
        let alertView = UIAlertController(title: "腰包绑定成功", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default ,handler: { (UIAlertAction) -> Void in
            Alamofire.request("http://\(Host().Host):8998/package/getPersonByPackageNo", method: .get, parameters: ["packageNo": self.packageNo]).responseString { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
                        if let responseModel = Model_1.deserialize(from: jsonString) {
                            if responseModel.msg == "游戏结束" {
                                self.hud()
                            }
                            else if responseModel.msg == "游戏未开始" {
                                self.hud()
                            }else{
                                self.person_id = responseModel.data.person_id
                                self.game_id = responseModel.data.game_id
                                self.team_id = responseModel.data.team_id
                                let vc = GameViewController()
                                vc.packageNo = self.packageNo
                                vc.game_id = self.game_id
                                vc.person_id = self.person_id
                                vc.team_id = self.team_id
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }else{
                    self.hud_2()
                }
            }
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Login?.TextField?.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func hud() {
        let alertView = UIAlertController(title: "游戏未开始", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default ,handler: { (UIAlertAction) -> Void in
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    func hud_2() {
        let alertView = UIAlertController(title: "服务器异常", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default ,handler: { (UIAlertAction) -> Void in
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
}

