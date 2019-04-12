//
//  ViewController.swift
//  project_7
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Alamofire
import Starscream
public var packageNo : String?
public var oId : String?
public var person_id : Int?
public var game_id : Int?
public var team_id : Int?
public var Host : String?
class LoginViewController: UIViewController,LBXScanViewControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    let kAppdelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    var Login : LoginView?
    var Array : Array = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")
        let rotation : UIInterfaceOrientationMask = [.landscapeLeft, .landscapeRight]
        kAppdelegate?.blockRotation = rotation
        
        Login = LoginView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
        self.view.addSubview(Login!)
        
        Login?.HostField?.delegate = self
        Login?.packageField?.delegate = self
        Login?.oidField?.delegate = self
        Login?.LoginButton?.addTarget(self, action: #selector(login), for: .touchUpInside)
        Login?.ScanButton?.addTarget(self, action: #selector(scan), for: .touchUpInside)
        
        Login?.HostField?.text = UserDefaults.standard.object(forKey: "Host") as? String
        Login?.packageField?.text = UserDefaults.standard.object(forKey: "packageNo") as? String
        Login?.oidField?.text = UserDefaults.standard.object(forKey: "oId") as? String
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @objc func login(){
        if Login?.HostField?.text != nil{
            Host = Login?.HostField?.text
            UserDefaults.standard.set(Host, forKey: "Host")
        }
        if Login?.packageField?.text != nil{
            packageNo = Login?.packageField?.text
            UserDefaults.standard.set(packageNo, forKey: "packageNo")
        }
        if Login?.oidField?.text != nil{
            oId = Login?.oidField?.text
            UserDefaults.standard.set(oId, forKey: "oId")
        }
        if Host != nil && packageNo != nil && oId != nil{
            Alamofire.request("http://\(Host!):8998/package/getPersonByPackageNo", method: .get, parameters: ["packageNo": packageNo!, "oId": Int(oId!)]).responseString { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
                        if let responseModel = Model_1.deserialize(from: jsonString) {
                            if responseModel.respCode != "200" {
                                self.hud()
                            }else{
                                person_id = responseModel.data.person_id
                                game_id = responseModel.data.game_id
                                team_id = responseModel.data.team_id
                                let vc = GameViewController()
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }else{
                    self.hud_2()
                }
            }
        }else{
            hud_3()
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
        Array = scanResult.strScanned!.components(separatedBy: ",")
        if Array.count == 3 {
            Host = Array[2]
            packageNo = Array[1]
            oId = Array[0]
            let alertView = UIAlertController(title: "扫描成功", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default ,handler: { (UIAlertAction) -> Void in
                Alamofire.request("http://\(Host!):8998/package/getPersonByPackageNo", method: .get, parameters: ["packageNo": packageNo!, "oId": Int(oId!)]).responseString { (response) in
                    if response.result.isSuccess {
                        if let jsonString = response.result.value {
                            if let responseModel = Model_1.deserialize(from: jsonString) {
                                if responseModel.msg == "游戏结束" {
                                    self.hud()
                                }
                                else if responseModel.msg == "游戏未开始" {
                                    self.hud()
                                }else{
                                    person_id = responseModel.data.person_id
                                    game_id = responseModel.data.game_id
                                    team_id = responseModel.data.team_id
                                    let vc = GameViewController()
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
        }else{
            hud_4()
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        Login?.HostField?.resignFirstResponder()
        Login?.packageField?.resignFirstResponder()
        Login?.oidField?.resignFirstResponder()
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
    func hud_3() {
        let alertView = UIAlertController(title: "请正确输入IP地址和腰包ID和机构ID", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default ,handler: { (UIAlertAction) -> Void in
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    func hud_4() {
        let alertView = UIAlertController(title: "二维码错误", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default ,handler: { (UIAlertAction) -> Void in
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
}

