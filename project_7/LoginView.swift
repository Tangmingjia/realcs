import UIKit

class LoginView : UIView {
    
    var BgImage : UIImageView?

    var LogoImage : UIImageView?
    
    var TextField : UITextField?
    
    var LoginButton : UIButton?
    
    var ScanButton : UIButton?
    
    override init(frame : CGRect)
        
    {
        
        super.init(frame: frame)
        
        self.BgImage = UIImageView()
        
        self.addSubview(BgImage!)
        
        self.LogoImage = UIImageView()
        
        self.BgImage?.addSubview(LogoImage!)
        
        self.TextField = UITextField()
        
        self.addSubview(TextField!)
        
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
        
        self.TextField?.frame = CGRect(x: ScreenSize.width/2-100, y: ScreenSize.height/2-40, width: 200, height: 30)
        self.TextField?.backgroundColor = UIColor.white
        self.TextField?.attributedPlaceholder = NSAttributedString.init(string:"请输入腰包号", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        self.TextField?.textAlignment = .center
        self.TextField?.font = UIFont.systemFont(ofSize: 13)
        self.TextField?.layer.borderColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1).cgColor
        self.TextField?.layer.borderWidth = 1
        self.TextField?.layer.cornerRadius = 5
        self.TextField?.layer.masksToBounds = true
        self.TextField?.keyboardType = .default
        self.TextField?.returnKeyType = .done
        
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
