import UIKit
var mapType : BMKUserTrackingMode = BMKUserTrackingModeFollowWithHeading //地图类型，默认罗盘模式
class LoginView : UIView {
    
    var BgImage : UIImageView?
    
    var LogoImage : UIImageView?
    
    var LogoImage_2 : UIImageView?
    
    var rainEmitterLayer: CAEmitterLayer?
    
    var rainCell: CAEmitterCell?
    
    var HostField : UITextField?
    
    var packageField : UITextField?
    
    //    var oidField : UITextField?
    
    var LoginButton : UIButton?
    
    var ScanButton : UIButton?
    
    var pickerView : UIView?
    
    var picker : UIPickerView?
    
    var doneButton : UIButton?
    
    var cancelButton : UIButton?
    
    var wechatButton : UIButton?
    
    var headImage : UIImageView?
    
    var nickName : UILabel?
    
    var QRImageView : UIImageView?
    
    var mapLabel : UILabel?
    
    var mapSwitch : UISwitch?
    
    override init(frame : CGRect)
        
    {
        
        super.init(frame: frame)
        
        self.BgImage = UIImageView()
        self.addSubview(BgImage!)
        
        self.LogoImage = UIImageView()
        self.BgImage?.addSubview(LogoImage!)
        
        self.LogoImage_2 = UIImageView()
        self.BgImage?.addSubview(LogoImage_2!)
        
        self.rainEmitterLayer = CAEmitterLayer()
        self.BgImage?.layer.addSublayer(rainEmitterLayer!)
        
        self.rainCell = CAEmitterCell()
        
        self.HostField = UITextField()
        self.addSubview(HostField!)
        
        self.packageField = UITextField()
        self.addSubview(packageField!)
        
        //        self.oidField = UITextField()
        //        self.addSubview(oidField!)
        
        self.ScanButton = UIButton()
        self.addSubview(ScanButton!)
        
        self.LoginButton = UIButton()
        self.addSubview(LoginButton!)
        
        self.wechatButton = UIButton()
        self.addSubview(wechatButton!)
        
        self.pickerView = UIView()
        //        self.addSubview(pickerView!)
        
        self.picker = UIPickerView()
        self.pickerView?.addSubview(picker!)
        
        self.doneButton = UIButton()
        self.pickerView?.addSubview(doneButton!)
        
        self.cancelButton = UIButton()
        self.pickerView?.addSubview(cancelButton!)

        self.headImage = UIImageView()
        self.addSubview(headImage!)
        
        self.nickName = UILabel()
        self.addSubview(nickName!)
        
        self.QRImageView = UIImageView()
        self.addSubview(QRImageView!)
        
        self.mapLabel = UILabel()
        self.addSubview(mapLabel!)
        
        self.mapSwitch = UISwitch()
        self.addSubview(mapSwitch!)
        
        setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.BgImage?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.BgImage?.image = UIImage(named: "bg.png")
        
        self.LogoImage?.frame = CGRect(x: 20, y: 20, width: 100, height: 100)
        self.LogoImage?.image = UIImage(named: "logo.png")
        
        self.LogoImage_2?.frame = CGRect(x: ScreenSize.width/2-100, y: 20, width: 200, height: 68)
        self.LogoImage_2?.image = UIImage(named: "jyzc.png")
        
        // 发射源的形状 是枚举类型 ,因为是下雨 所以要作为 直线发射
        self.rainEmitterLayer?.emitterShape = .line
        // 发射模式
        self.rainEmitterLayer?.emitterMode = .surface
        // 发射源的size 据定了发射源的大小 (有倾斜度，我们需要加宽发射源)
        self.rainEmitterLayer?.emitterSize = (BgImage?.frame.size)!
        // 发射源的位置 从屏幕上方往下发射
        self.rainEmitterLayer?.emitterPosition = CGPoint(x: (BgImage?.frame.size.width)! * 0.55, y: 0)
        // 设置粒子图片
        self.rainCell?.contents = UIImage(named: "rain.png")?.cgImage
        // 设置粒子产生率
        self.rainCell?.birthRate = 60.0
        // 设置粒子生命周期
        self.rainCell?.lifetime = 40.0
        // 设置粒子持续时间，持续时间制约粒子生命周期
        self.rainCell?.speed = 5.0
        // 设置粒子速度
        self.rainCell?.velocity = 20.0
        // 设置粒子速度范围
        self.rainCell?.velocityRange = 100.0
        // 设置粒子下落加速度 Y轴
        self.rainCell?.yAcceleration = 1000.0
        // 设置粒子下落加速度 X轴  负值是向左，因为rain图片是向左下
        self.rainCell?.xAcceleration = -300.0
        // 设置缩放比例 雨图片需要缩放统一大小 不能使用范围
        self.rainCell?.scale = 0.5
        // 设置粒子颜色 会附和图片修改图片颜色
        self.rainCell?.color = UIColor.white.cgColor
        // 添加到粒子发射器
        self.rainEmitterLayer?.emitterCells = [rainCell] as? [CAEmitterCell]
        
        self.HostField?.frame = CGRect(x: ScreenSize.width/2-90, y: ScreenSize.height/2-70, width: 180, height: 30)
        //        self.HostField?.backgroundColor = UIColor.white
        self.HostField?.attributedPlaceholder = NSAttributedString.init(string:"请选择服务器", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        self.HostField?.textAlignment = .center
        self.HostField?.textColor = UIColor.white
        self.HostField?.font = UIFont.systemFont(ofSize: 13)
        //        self.HostField?.layer.borderColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1).cgColor
        //        self.HostField?.layer.borderWidth = 1
        //        self.HostField?.layer.cornerRadius = 5
        //        self.HostField?.layer.masksToBounds = true
        self.HostField?.borderStyle = .none
        self.HostField?.background = UIImage(named:"srk.png")
        //        self.HostField?.keyboardType = .decimalPad
        self.HostField?.inputView = pickerView
        
        self.packageField?.frame = CGRect(x: ScreenSize.width/2-90, y: ScreenSize.height/2-35, width: 180, height: 30)
        //        self.packageField?.backgroundColor = UIColor.white
        self.packageField?.attributedPlaceholder = NSAttributedString.init(string:"腰包ID", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        self.packageField?.textAlignment = .center
        self.packageField?.textColor = UIColor.white
        self.packageField?.font = UIFont.systemFont(ofSize: 13)
        //        self.packageField?.layer.borderColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1).cgColor
        //        self.packageField?.layer.borderWidth = 1
        //        self.packageField?.layer.cornerRadius = 5
        //        self.packageField?.layer.masksToBounds = true
        self.packageField?.borderStyle = .none
        self.packageField?.background = UIImage(named:"srk.png")
        self.packageField?.keyboardType = .numbersAndPunctuation
        self.packageField?.returnKeyType = .done
        
        //        self.oidField?.frame = CGRect(x: ScreenSize.width/2+40, y: ScreenSize.height/2-35, width: 50, height: 30)
        //        self.oidField?.backgroundColor = UIColor.white
        //        self.oidField?.attributedPlaceholder = NSAttributedString.init(string:"机构ID", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        //        self.oidField?.textAlignment = .center
        //        self.oidField?.font = UIFont.systemFont(ofSize: 13)
        //        self.oidField?.layer.borderColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1).cgColor
        //        self.oidField?.layer.borderWidth = 1
        //        self.oidField?.layer.cornerRadius = 5
        //        self.oidField?.layer.masksToBounds = true
        //        self.oidField?.keyboardType = .numberPad
        //        self.oidField?.returnKeyType = .done
        
        self.LoginButton?.frame = CGRect(x: ScreenSize.width/2-90, y: ScreenSize.height/2, width: 85, height: 75)
        self.LoginButton?.setImage(UIImage(named: "ykdl.png"), for: .normal)
        //        self.LoginButton?.setTitle("登录", for: .normal)
        //        self.LoginButton?.setTitleColor(UIColor.white, for: .normal)
        //        self.LoginButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        //        self.LoginButton?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
        //        self.LoginButton?.layer.cornerRadius = 5
        //        self.LoginButton?.layer.masksToBounds = true
        
        self.wechatButton?.frame = CGRect(x: ScreenSize.width/2+5, y: ScreenSize.height/2, width: 85, height: 75)
        self.wechatButton?.setImage(UIImage(named: "wxdl.png"), for: .normal)
        //        self.wechatButton?.setTitle("微信登陆", for: .normal)
        //        self.wechatButton?.setTitleColor(UIColor.white, for: .normal)
        //        self.wechatButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        //        self.wechatButton?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
        //        self.wechatButton?.layer.cornerRadius = 5
        //        self.wechatButton?.layer.masksToBounds = true
        
        self.ScanButton?.frame = CGRect(x: ScreenSize.width/2-90, y: ScreenSize.height/2+80, width: 180, height: 80)
        self.ScanButton?.setImage(UIImage(named: "smdl.png"), for: .normal)
        //        self.ScanButton?.setTitle("扫一扫", for: .normal)
        //        self.ScanButton?.setTitleColor(UIColor.white, for: .normal)
        //        self.ScanButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        //        self.ScanButton?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
        //        self.ScanButton?.layer.cornerRadius = 5
        //        self.ScanButton?.layer.masksToBounds = true
        
        self.pickerView?.frame = CGRect(x: 0, y: ScreenSize.height-(200+UIApplication.shared.statusBarFrame.height), width: ScreenSize.width, height: 200)
        self.pickerView?.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        self.picker?.frame = CGRect(x: 0, y: 50, width: ScreenSize.width, height: 150)
        self.picker?.backgroundColor = UIColor.white
        self.picker?.layer.masksToBounds = true
        
        self.cancelButton?.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        self.cancelButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.cancelButton?.setTitle("取 消", for: .normal)
        self.cancelButton?.setTitleColor(UIColor(red: 18/255, green: 93/255, blue: 255/255, alpha: 1), for: .normal)
        
        self.doneButton?.frame = CGRect(x: ScreenSize.width-60, y: 0, width: 60, height: 50)
        self.doneButton?.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.doneButton?.setTitle("确 定", for: .normal)
        self.doneButton?.setTitleColor(UIColor(red: 18/255, green: 93/255, blue: 255/255, alpha: 1), for: .normal)
        
        self.headImage?.frame = CGRect(x: ScreenSize.width-150, y: ScreenSize.height/2-50, width: 100, height: 100)
        self.headImage?.layer.cornerRadius = 5
        self.headImage?.layer.masksToBounds = true
        self.headImage?.isHidden = true
        
        self.nickName?.frame = CGRect(x: ScreenSize.width-150, y: ScreenSize.height/2+50, width: 100, height: 20)
        self.nickName?.textColor = UIColor.white
        self.nickName?.font = UIFont.systemFont(ofSize: 14)
        self.nickName?.textAlignment = .center
        self.nickName?.isHidden = true
        
        self.QRImageView?.frame = CGRect(x: ScreenSize.width-150, y: ScreenSize.height/2-50, width: 100, height: 100)
        self.QRImageView?.layer.cornerRadius = 5
        self.QRImageView?.layer.masksToBounds = true
        self.QRImageView?.isHidden = true
        
        self.mapLabel?.frame = CGRect(x: ScreenSize.width-110, y: 55, width: 60, height: 20)
        self.mapLabel?.text = "罗盘地图"
        self.mapLabel?.font = UIFont.systemFont(ofSize: 14)
        self.mapLabel?.textColor = UIColor.white
        
        self.mapSwitch?.frame = CGRect(x: ScreenSize.width-50, y: 50, width: 40, height: 20)
        //开关无法设置大小，只能设置缩放
        self.mapSwitch?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        //设置开启状态显示的颜色
        self.mapSwitch?.onTintColor = UIColor.orange
        //设置关闭状态的颜色
        self.mapSwitch?.tintColor = UIColor.orange
        //设置开关默认开启状态
        self.mapSwitch?.isOn = true
        self.mapSwitch?.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
        //获取保存的状态值
        let state = UserDefaults.standard.bool(forKey: "switchState")
        self.mapSwitch?.setOn(state, animated: true)
    }
    
    @objc func switchDidChange(sender: UISwitch){
        //把当前状态保存起来
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        if sender.isOn {
            mapType = BMKUserTrackingModeFollowWithHeading   //罗盘模式
        } else {
            mapType = BMKUserTrackingModeHeading   //跟随模式
        }
    }
}
