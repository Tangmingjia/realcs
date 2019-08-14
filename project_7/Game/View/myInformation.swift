import UIKit

class myInformation : UIView {
    
    var MyView : UIImageView?       //我的状态栏
    var MyName : UILabel?           //我的名字
    var BloodView : UIView?         //我的血条栏
    var Blood_2 : UIImageView?      //我的血条（白色）
    var Blood : UIImageView?        //我的血条
    var DyingBlood_2 : UIImageView? //我的濒死血条（白色）
    var DyingBlood : UIImageView?   //我的濒死血条
    var ArmorView : UIView?         //我的护甲栏
    var Armor_2 : UIImageView?      //我的护甲（白色）
    var Armor : UIImageView?        //我的护甲
    
    override init(frame : CGRect)
        
    {
        super.init(frame: frame)
        
        self.MyView = UIImageView()
        self.addSubview(MyView!)
        
        self.MyName = UILabel()
        self.MyView?.addSubview(MyName!)
        
        self.BloodView = UIView()
        self.MyView?.addSubview(BloodView!)
        
        self.Blood_2 = UIImageView()
        self.BloodView?.addSubview(Blood_2!)
        
        self.Blood = UIImageView()
        self.BloodView?.addSubview(Blood!)
        
        self.DyingBlood_2 = UIImageView()
        self.BloodView?.addSubview(DyingBlood_2!)
        
        self.DyingBlood = UIImageView()
        self.BloodView?.addSubview(DyingBlood!)
        
        self.ArmorView = UIView()
        self.MyView?.addSubview(ArmorView!)
        
        self.Armor_2 = UIImageView()
        self.ArmorView?.addSubview(Armor_2!)
        
        self.Armor = UIImageView()
        self.ArmorView?.addSubview(Armor!)
        
        setUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.MyView?.frame = CGRect(x: 0, y: 0, width: 220, height: 31)
        self.MyView?.image = UIImage(named: "myview.png")
        
        self.MyName?.frame = CGRect(x: 75, y: 0, width: 80, height: 10)
        self.MyName?.font = UIFont.systemFont(ofSize: 9)
        self.MyName?.textColor = UIColor.orange
        self.MyName?.textAlignment = .left
        
        self.BloodView?.frame = CGRect(x: 12, y: 13, width: 205, height: 6)
        self.BloodView?.backgroundColor = UIColor.clear
        
        self.Blood_2?.frame = CGRect(x: 0, y: 0, width: 205, height: 6)
        self.Blood_2?.image = UIImage(named: "myblood_2.png")
        self.Blood_2?.contentMode = .left
        self.Blood_2?.clipsToBounds = true
        
        self.Blood?.frame = CGRect(x: 0, y: 0, width: 205, height: 6)
        animation(ImageName: "myblood", ImageView: Blood!)
        self.Blood?.startAnimating()
        self.Blood?.contentMode = .left
        self.Blood?.clipsToBounds = true
        
        self.DyingBlood_2?.frame = CGRect(x: 0, y: 0, width: 205, height: 6)
        self.DyingBlood_2?.image = UIImage(named: "mydyingblood_2.png")
        self.DyingBlood_2?.contentMode = .left
        self.DyingBlood_2?.clipsToBounds = true
        self.DyingBlood_2?.isHidden = true
        
        self.DyingBlood?.frame = CGRect(x: 0, y: 0, width: 205, height: 6)
        animation(ImageName: "mydyingblood", ImageView: DyingBlood!)
        self.DyingBlood?.contentMode = .left
        self.DyingBlood?.clipsToBounds = true
        self.DyingBlood?.isHidden = true
        
        self.ArmorView?.frame = CGRect(x: 41, y: 21, width: 175, height: 6)
        self.ArmorView?.backgroundColor = UIColor.clear
        
        self.Armor_2?.frame = CGRect(x: 0, y: 0, width: 175, height: 6)
        self.Armor_2?.image = UIImage(named: "myarmor_2.png")
        self.Armor_2?.contentMode = .left
        self.Armor_2?.clipsToBounds = true
        
        self.Armor?.frame = CGRect(x: 0, y: 0, width: 175, height: 6)
        animation(ImageName: "myarmor", ImageView: Armor!)
        self.Armor?.contentMode = .left
        self.Armor?.clipsToBounds = true
        
    }
}
