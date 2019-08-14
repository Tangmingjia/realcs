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
import Kingfisher
import SVProgressHUD

public var packageNo : String?
public var oId : String?
public var person_id : Int?
public var game_id : Int?
public var team_id : Int?
public var Host : String?
public var isContinue : Bool = false
public var access_token: String = ""
public var ticket: String = ""
public var refresh_token: String = ""
public var openid: String = ""
public var unionid: String = ""
public var nickname: String = ""
public var headimgurl: String = ""

class LoginViewController: UIViewController,LBXScanViewControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,WechatAuthAPIDelegate{

    var Login : LoginView?
    var timeStamp : Int?
    var autograph : String = ""
    var signature : String?
    var noncestr : String = ""
    var authSDK = WechatAuthSDK()
    var Array : Array = [String]()
    var HostName : String?
    var HostDictionary : Dictionary = ["成都":"118.24.90.156","漳州":"212.64.29.15","合肥":"129.211.8.106","丽水":"118.25.5.234","岳阳":"129.211.13.49","信阳":"118.25.151.128","遵义":"212.64.14.53","惠州":"111.231.108.101","跳马镇":"118.25.172.69","湘潭":"118.25.97.133","泰州":"212.64.4.119","上海-松江":"111.231.74.211","上海-宝山":"118.25.51.43","温州":"118.25.96.108","嘉兴":"112.124.202.110","德清":"111.231.118.148","红花岗":"118.126.114.23","安化":"148.70.207.211","丽江":"111.231.205.126","汕头":"39.108.229.218","本地":"192.168.31.67","惠州欧美城":"39.108.175.226","长沙自用":"47.98.202.211","河源":"119.23.234.184","湖南邵阳":"47.98.189.203","广州":"112.74.54.134","武汉汉阳":"47.97.157.41","贵州安顺":"47.110.152.114","江西抚州":"121.40.85.152","泉州":"47.111.139.19"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(NSNumber(value: UIDeviceOrientation.landscapeLeft.rawValue), forKey: "orientation")

        Login = LoginView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
        self.view.addSubview(Login!)
        
        Login?.HostField?.delegate = self
        Login?.packageField?.delegate = self
        Login?.oidField?.delegate = self
        Login?.LoginButton?.addTarget(self, action: #selector(login), for: .touchUpInside)
        Login?.ScanButton?.addTarget(self, action: #selector(scan), for: .touchUpInside)
        Login?.picker?.delegate = self
        Login?.picker?.dataSource = self
        Login?.cancelButton?.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        Login?.doneButton?.addTarget(self, action: #selector(doneClick), for: .touchUpInside)
        Login?.wechatButton?.addTarget(self, action: #selector(wechatClick), for: .touchUpInside)
        Login?.HostField?.text = UserDefaults.standard.object(forKey: "Host") as? String
        Login?.packageField?.text = UserDefaults.standard.object(forKey: "packageNo") as? String
        Login?.oidField?.text = UserDefaults.standard.object(forKey: "oId") as? String
        
        NotificationCenter.default.addObserver(self,selector: #selector(WXLoginSuccess(notification:)),name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"),object: nil)
        authSDK.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //登录方法
    @objc func login(){
        hud_5()
        if Login?.HostField?.text != nil{
            HostName = Login?.HostField?.text
            UserDefaults.standard.set(HostName, forKey: "Host")
            Host = HostDictionary[HostName!]
        }
        if Login?.packageField?.text != nil{
            packageNo = Login?.packageField?.text
            UserDefaults.standard.set(packageNo, forKey: "packageNo")
        }
        if Login?.oidField?.text != nil{
            oId = Login?.oidField?.text
            UserDefaults.standard.set(oId, forKey: "oId")
        }
        if Host != nil && packageNo != nil && oId != nil && Host != "" && packageNo != "" && oId != ""{
            Alamofire.request("http://\(Host!):8998/package/getPersonByPackageNo", method: .get, parameters: ["packageNo": packageNo!, "oId": Int(oId!), "unionid": unionid, "hosturl": Host!]).responseString { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
                        if let responseModel = LoginModel.deserialize(from: jsonString) {
                            if responseModel.respCode != "200" && responseModel.respCode != "300" {
                                self.hud()
                            }else{
                                person_id = responseModel.data!.person_id
                                game_id = responseModel.data!.game_id
                                team_id = responseModel.data!.team_id
                                self.upload()
                                isContinue = true
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
    //扫码方法
    @objc func scan(){
        LBXPermissions.authorizeCameraWith { [weak self] (granted) in
            if granted {
                self?.scanQrCode()
            } else {
                LBXPermissions.jumpToSystemPrivacySetting()
            }
        }
    }
    //创建扫码工具
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //扫描结果处理
    func scanFinished(scanResult: LBXScanResult, error: String?) {
//            print("扫描结果：" + scanResult.strScanned!)
        Array = scanResult.strScanned!.components(separatedBy: ",")
        if Array.count == 2{
            if Login?.HostField?.text != nil{
                HostName = Login?.HostField?.text
                UserDefaults.standard.set(HostName, forKey: "Host")
                Host = HostDictionary[HostName!]
                packageNo = Array[1]
                UserDefaults.standard.set(packageNo, forKey: "packageNo")
                oId = Array[0]
                UserDefaults.standard.set(oId, forKey: "oId")
                self.hud_5()
                Alamofire.request("http://\(Host!):8998/package/getPersonByPackageNo", method: .get, parameters: ["packageNo": packageNo!, "oId": Int(oId!), "unionid": unionid, "hosturl": Host!]).responseString { (response) in
                    if response.result.isSuccess {
                        if let jsonString = response.result.value {
                            if let responseModel = LoginModel.deserialize(from: jsonString) {
                                if responseModel.respCode != "200" && responseModel.respCode != "300" {
                                    self.hud()
                                }else{
                                    person_id = responseModel.data!.person_id
                                    game_id = responseModel.data!.game_id
                                    team_id = responseModel.data!.team_id
                                    self.upload()
                                    isContinue = true
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
                hud_7()
            }
        }else if Array.count == 1{
            if Login?.HostField?.text != nil{
                HostName = Login?.HostField?.text
                UserDefaults.standard.set(HostName, forKey: "Host")
                Host = HostDictionary[HostName!]
                packageNo = Array[0]
                UserDefaults.standard.set(packageNo, forKey: "packageNo")
                oId = "2"
                UserDefaults.standard.set(oId, forKey: "oId")
                self.hud_5()
                Alamofire.request("http://\(Host!):8998/package/getPersonByPackageNo", method: .get, parameters: ["packageNo": packageNo!, "oId": Int(oId!), "unionid": unionid, "hosturl": Host!]).responseString { (response) in
                    if response.result.isSuccess {
                        if let jsonString = response.result.value {
                            if let responseModel = LoginModel.deserialize(from: jsonString) {
                                if responseModel.respCode != "200" && responseModel.respCode != "300" {
                                    self.hud()
                                }else{
                                    person_id = responseModel.data!.person_id
                                    game_id = responseModel.data!.game_id
                                    team_id = responseModel.data!.team_id
                                    self.upload()
                                    isContinue = true
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
                hud_7()
            }
        }else{
            hud_4()
        }
    }
    //点击空白隐藏键盘
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
        SVProgressHUD.showInfo(withStatus: "游戏未开始")
    }
    func hud_2() {
        SVProgressHUD.showError(withStatus: "服务器异常")
    }
    func hud_3() {
        SVProgressHUD.showInfo(withStatus: "请正确填写服务器/腰包ID/机构ID")
    }
    func hud_4() {
        SVProgressHUD.showError(withStatus: "二维码错误")
    }
    func hud_5(){
        SVProgressHUD.show(withStatus: "正在加载…")
    }
    func hud_6() {
        SVProgressHUD.showInfo(withStatus: "未获取到微信数据")
    }
    func hud_7() {
        SVProgressHUD.showInfo(withStatus: "请选择服务器")
    }
    @objc func cancelClick(){
        Login?.pickerView?.removeFromSuperview()
    }
    @objc func doneClick(){
        Login?.HostField?.text = [String](HostDictionary.keys)[(Login?.picker?.selectedRow(inComponent: 0))!]
        Login?.pickerView?.removeFromSuperview()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return HostDictionary.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return HostDictionary.keys.map{$0}[row]   //字典的key的数组,排序随机
        return [String](HostDictionary.keys)[row]  //强转字典key的数组,排序随机
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 130
    }
    
    //微信登录
    @objc func wechatClick() {
        if WXApi.isWXAppInstalled() {  //如果本机安装了微信
            let req = SendAuthReq.init()
            req.scope = "snsapi_userinfo"
            req.state = "App"
            WXApi.send(req)
        }else{                        //没有安装微信则扫码登陆
            getAccess_token()
            Login?.QRImageView?.isHidden = false
            Login?.nickName?.isHidden = false
            Login?.headImage?.isHidden = true
            Login?.nickName?.text = "微信扫码"
        }
    }
    
    //微信成功通知
    @objc func WXLoginSuccess(notification:Notification) {
        let code = notification.object as! String
        //获取access_token
        Alamofire.request("https://api.weixin.qq.com/sns/oauth2/access_token", method: .get, parameters: ["appid": "\(appid)", "secret": "\(secret)", "code": code, "grant_type": "authorization_code"]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = wechatModel.deserialize(from: jsonString) {
                        if responseModel.access_token != nil {
                            access_token = responseModel.access_token    //获取access_token
                            openid = responseModel.openid                //获取openid
                            self.getUserInfo()
                        }else{
                            self.hud_6()
                        }
                    }
                }
            }else{
                self.hud_6()
            }
        }
    }
    
    //获取用户信息
    func getUserInfo(){
        Alamofire.request("https://api.weixin.qq.com/sns/userinfo", method: .get, parameters: ["access_token": access_token, "openid": openid]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = userInfoModel.deserialize(from: jsonString) {
                        nickname = responseModel.nickname
                        headimgurl = responseModel.headimgurl
                        unionid = responseModel.unionid
                        
                        //昵称转码
                        nickname = String(cString: nickname.cString(using: String.Encoding(rawValue: String.Encoding.isoLatin1.rawValue))!, encoding: .utf8)!
                        //头像链接删除指定符号
                        headimgurl = headimgurl.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
                        
                        self.Login?.headImage?.kf.setImage(with: URL(string: headimgurl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
                        self.Login?.headImage?.isHidden = false
                        self.Login?.nickName?.text = nickname
                        self.Login?.nickName?.isHidden = false
                        self.Login?.QRImageView?.isHidden = true
                        self.login()
                    }
                }
            }else{
                self.hud_6()
            }
        }
    }
    //上传头像和昵称
    func upload(){
        Alamofire.request("http://\(Host!):8080/apps/getHeadimgurl", method: .get, parameters: ["gameId": game_id!, "personId": person_id!, "headimgurl": headimgurl, "nickname": nickname])
    }
    
    //直接获取access_token
    func getAccess_token(){
        Alamofire.request("https://api.weixin.qq.com/cgi-bin/token", method: .get, parameters: ["grant_type": "client_credential", "appid": "\(appid)", "secret": "\(secret)"]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = wechatModel.deserialize(from: jsonString) {
                        access_token = responseModel.access_token
                        self.getTicket()
                    }
                }
            }
        }
    }
    
    //获取ticket
    func getTicket(){
        Alamofire.request("https://api.weixin.qq.com/cgi-bin/ticket/getticket", method: .get, parameters: ["access_token": "\(access_token)", "type": "2"]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = wechatModel.deserialize(from: jsonString) {
                        ticket = responseModel.ticket
                        self.getString()
                    }
                }
            }
        }
    }
    
    func getString(){
        timeStamp = Int(NSDate().timeIntervalSince1970)
        noncestr = RandomString.sharedInstance.getRandomStringOfLength(length: 10)
        autograph = "appid=\(appid)&noncestr=\(noncestr)&sdk_ticket=\(ticket)&timestamp=\(timeStamp!)"
        signature = autograph.sha1()
        loadQRCode()
    }
    
    func loadQRCode() {
        authSDK.auth(appid, nonceStr: "\(noncestr)", timeStamp: "\(timeStamp!)", scope: "snsapi_userinfo", signature: signature!, schemeData: nil)
    }
    //自动监听回调二维码图片
    func onAuthGotQrcode(_ image: UIImage) {
        Login?.QRImageView?.image = image
    }
    //自动监听扫码完成确认授权回调
    func onAuthFinish(_ errCode: Int32, authCode: String?) {
        //获取access_token
        Alamofire.request("https://api.weixin.qq.com/sns/oauth2/access_token", method: .get, parameters: ["appid": "\(appid)", "secret": "\(secret)", "code": authCode!, "grant_type": "authorization_code"]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = wechatModel.deserialize(from: jsonString) {
                        if responseModel.access_token != nil {
                            access_token = responseModel.access_token    //获取access_token
                            openid = responseModel.openid                //获取openid
                            self.getUserInfo()
                        }else{
                            self.hud_6()
                        }
                    }
                }
            }else{
                self.hud_6()
            }
        }
    }
}

extension String {
    //sha1加密算法
    func sha1() -> String{
        let data : Data = self.data(using: String.Encoding.utf8, allowLossyConversion: true)!
        var digest = [UInt8](repeating:0,count:Int(CC_SHA1_DIGEST_LENGTH))
        
        let dataBytes = data.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return bytes
        }
        let dataLength = CC_LONG(data.count)
        
        CC_SHA1(dataBytes, dataLength, &digest)
        
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest{
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
}
