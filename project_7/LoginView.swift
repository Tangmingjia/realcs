import UIKit

class LoginView : UIView {
    
    var BgImage : UIImageView?

    var LogoImage : UIImageView?
    
    var HostField : UITextField?
    
    var packageField : UITextField?
    
    var oidField : UITextField?
    
    var LoginButton : UIButton?
    
    var ScanButton : UIButton?
    
    override init(frame : CGRect)
        
    {
        
        super.init(frame: frame)
        
        self.BgImage = UIImageView()
        
        self.addSubview(BgImage!)
        
        self.LogoImage = UIImageView()
        
        self.BgImage?.addSubview(LogoImage!)
        
        self.HostField = UITextField()
        
        self.addSubview(HostField!)
        
        self.packageField = UITextField()
        
        self.addSubview(packageField!)
        
        self.oidField = UITextField()
        
        self.addSubview(oidField!)
        
        self.ScanButton = UIButton()
        
        self.addSubview(ScanButton!)
        
        self.LoginButton = UIButton()
        
        self.addSubview(LoginButton!)
        
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
        
        self.HostField?.frame = CGRect(x: ScreenSize.width/2-100, y: ScreenSize.height/2-80, width: 200, height: 30)
        self.HostField?.backgroundColor = UIColor.white
        self.HostField?.attributedPlaceholder = NSAttributedString.init(string:"IP地址", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        self.HostField?.textAlignment = .center
        self.HostField?.font = UIFont.systemFont(ofSize: 13)
        self.HostField?.layer.borderColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1).cgColor
        self.HostField?.layer.borderWidth = 1
        self.HostField?.layer.cornerRadius = 5
        self.HostField?.layer.masksToBounds = true
        self.HostField?.keyboardType = .decimalPad
        
        self.packageField?.frame = CGRect(x: ScreenSize.width/2-100, y: ScreenSize.height/2-40, width: 130, height: 30)
        self.packageField?.backgroundColor = UIColor.white
        self.packageField?.attributedPlaceholder = NSAttributedString.init(string:"腰包ID", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        self.packageField?.textAlignment = .center
        self.packageField?.font = UIFont.systemFont(ofSize: 13)
        self.packageField?.layer.borderColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1).cgColor
        self.packageField?.layer.borderWidth = 1
        self.packageField?.layer.cornerRadius = 5
        self.packageField?.layer.masksToBounds = true
        self.packageField?.keyboardType = .numbersAndPunctuation
        self.packageField?.returnKeyType = .done
        
        self.oidField?.frame = CGRect(x: ScreenSize.width/2+40, y: ScreenSize.height/2-40, width: 60, height: 30)
        self.oidField?.backgroundColor = UIColor.white
        self.oidField?.attributedPlaceholder = NSAttributedString.init(string:"机构ID", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        self.oidField?.textAlignment = .center
        self.oidField?.font = UIFont.systemFont(ofSize: 13)
        self.oidField?.layer.borderColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1).cgColor
        self.oidField?.layer.borderWidth = 1
        self.oidField?.layer.cornerRadius = 5
        self.oidField?.layer.masksToBounds = true
        self.oidField?.keyboardType = .numberPad
        self.oidField?.returnKeyType = .done
        
        self.LoginButton?.frame = CGRect(x: ScreenSize.width/2-100, y: ScreenSize.height/2, width: 200, height: 30)
        self.LoginButton?.setTitle("登录", for: .normal)
        self.LoginButton?.setTitleColor(UIColor.white, for: .normal)
        self.LoginButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.LoginButton?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
        self.LoginButton?.layer.cornerRadius = 5
        self.LoginButton?.layer.masksToBounds = true
        
        self.ScanButton?.frame = CGRect(x: ScreenSize.width/2-100, y: ScreenSize.height/2+40, width: 200, height: 30)
        self.ScanButton?.setTitle("扫一扫", for: .normal)
        self.ScanButton?.setTitleColor(UIColor.white, for: .normal)
        self.ScanButton?.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        self.ScanButton?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
        self.ScanButton?.layer.cornerRadius = 5
        self.ScanButton?.layer.masksToBounds = true
        
    }
}
