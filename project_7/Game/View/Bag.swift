import UIKit

class Bag : UIView {
    
    var BagView : UIView?             //背包框
    var informationtitle : UIImageView?  //个人信息标题栏
    var informationView : UIView?        //个人信息框
    var IconView : UIImageView?       //个人头像
    var nickName : UILabel?           //个人昵称
    var KillNum : UILabel?            //击杀数
    var Damage : UILabel?             //伤害值
    var myBlood : UILabel?            //我的血量
    var myArmor : UILabel?            //我的护甲
    var bagtitle : UIImageView?       //包内框标题栏
    var bagView : UIView?             //包内框
    var bagTableView : UITableView?   //包内的物品
    var neartitle : UIImageView?      //附近物品框标题栏
    var nearView : UIView?            //附近物品框
    var nearTableView : UITableView?  //附近的物品
    
    override init(frame : CGRect)
        
    {
        super.init(frame: frame)
        
        self.BagView = UIView()
        self.addSubview(BagView!)
        
        self.informationtitle = UIImageView()
        self.BagView?.addSubview(informationtitle!)
        
        self.informationView = UIView()
        self.BagView?.addSubview(informationView!)
        
        self.IconView = UIImageView()
        self.informationView?.addSubview(IconView!)
        
        self.nickName = UILabel()
        self.informationView?.addSubview(nickName!)
        
        self.KillNum = UILabel()
        self.informationView?.addSubview(KillNum!)
        
        self.Damage = UILabel()
        self.informationView?.addSubview(Damage!)
        
        self.myBlood = UILabel()
        self.informationView?.addSubview(myBlood!)
        
        self.myArmor = UILabel()
        self.informationView?.addSubview(myArmor!)
        
        self.bagtitle = UIImageView()
        self.BagView?.addSubview(bagtitle!)
        
        self.bagView = UIView()
        self.BagView?.addSubview(bagView!)
        
        self.bagTableView = UITableView()
        self.bagView?.addSubview(bagTableView!)
        
        self.neartitle = UIImageView()
        self.BagView?.addSubview(neartitle!)
        
        self.nearView = UIView()
        self.BagView?.addSubview(nearView!)
        
        self.nearTableView = UITableView()
        self.nearView?.addSubview(nearTableView!)
        
        setUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.BagView?.frame = CGRect(x: 0, y: 0, width: 390, height: 320)
        
        self.informationtitle?.frame = CGRect(x: 0, y: 0, width: 130, height: 23)
        self.informationtitle?.image = UIImage(named: "informationtitle.png")
        
        self.informationView?.frame = CGRect(x: 0, y: 23, width: 130, height: 296)
        self.informationView?.backgroundColor = UIColor(patternImage: UIImage(named: "bagbg.png")!)
        
        self.IconView?.frame = CGRect(x: 40, y: 30, width: 50, height: 50)
        
        self.nickName?.frame = CGRect(x: 30, y: 90, width: 70, height: 20)
        self.nickName?.textAlignment = .center
        self.nickName?.textColor = UIColor.white
        self.nickName?.font = UIFont.systemFont(ofSize: 14)
        
        self.myBlood?.frame = CGRect(x: 30, y: 130, width: 70, height: 20)
        self.myBlood?.textColor = UIColor.white
        self.myBlood?.font = UIFont.systemFont(ofSize: 14)
        self.myBlood?.textAlignment = .left
        
        self.myArmor?.frame = CGRect(x: 30, y: 160, width: 70, height: 20)
        self.myArmor?.textColor = UIColor.white
        self.myArmor?.font = UIFont.systemFont(ofSize: 14)
        self.myArmor?.textAlignment = .left
        
        self.KillNum?.frame = CGRect(x: 30, y: 190, width: 70, height: 20)
        self.KillNum?.textColor = UIColor.white
        self.KillNum?.font = UIFont.systemFont(ofSize: 14)
        self.KillNum?.textAlignment = .left
        
        self.Damage?.frame = CGRect(x: 30, y: 220, width: 70, height: 20)
        self.Damage?.textColor = UIColor.white
        self.Damage?.font = UIFont.systemFont(ofSize: 14)
        self.Damage?.textAlignment = .left
        
        self.bagtitle?.frame = CGRect(x: 130, y: 0, width: 130, height: 23)
        self.bagtitle?.image = UIImage(named: "bagtitle.png")
        
        self.bagView?.frame = CGRect(x: 130, y: 23, width: 130, height: 296)
        self.bagView?.backgroundColor = UIColor(patternImage: UIImage(named: "bagbg.png")!)
        
        self.bagTableView?.frame = CGRect(x: 0, y: 0, width: 130, height: 290)
        self.bagTableView?.backgroundColor = UIColor.clear
        self.bagTableView?.separatorStyle = .none
        
        self.neartitle?.frame = CGRect(x: 260, y: 0, width: 130, height: 23)
        self.neartitle?.image = UIImage(named: "neartitle.png")
        
        self.nearView?.frame = CGRect(x: 260, y: 23, width: 130, height: 296)
        self.nearView?.backgroundColor = UIColor(patternImage: UIImage(named: "bagbg.png")!)
        
        self.nearTableView?.frame = CGRect(x: 0, y: 0, width: 130, height: 290)
        self.nearTableView?.backgroundColor = UIColor.clear
        self.nearTableView?.separatorStyle = .none
        
    }
    
}
