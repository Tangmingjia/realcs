import UIKit

class talkButton : UIView {
    
    var Button1 : UIButton?       //队伍聊天按钮
    var Button2 : UIButton?       //世界聊天按钮
    var Button3 : UIButton?       //系统聊天按钮
    var SelectBtn : UIButton?     //选中的按钮
    var NewTip1 : UIView?         //队伍红点提示
    var NewTip2 : UIView?         //世界红点提示
    var NewTip3 : UIView?         //系统红点提示
    
    override init(frame : CGRect)
        
    {
        super.init(frame: frame)
        
        self.Button1 = UIButton()
        self.addSubview(Button1!)
        
        self.Button2 = UIButton()
        self.addSubview(Button2!)
        
        self.Button3 = UIButton()
        self.addSubview(Button3!)
        
        self.NewTip1 = UIView()
        self.Button1?.addSubview(NewTip1!)
        
        self.NewTip2 = UIView()
        self.Button2?.addSubview(NewTip2!)
        
        self.NewTip3 = UIView()
        self.Button3?.addSubview(NewTip3!)

        setUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.Button1?.frame = CGRect(x: 0, y: 0, width: 30, height: 42)
        self.Button1?.setBackgroundImage(UIImage(named: "talkbtn.png"), for: .normal)
        self.Button1?.setTitle("队\n伍", for: .normal)
        self.Button1?.titleLabel!.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(2))
        self.Button1?.titleLabel?.numberOfLines = 2
        self.Button1?.setTitleColor(UIColor.lightGray, for: .normal)
        self.Button1?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
        self.Button1?.tag = 0
        self.Button1?.isSelected = true
        self.SelectBtn = self.Button1
        
        self.Button2?.frame = CGRect(x: 0, y: 42, width: 30, height: 42)
        self.Button2?.setBackgroundImage(UIImage(named: "talkbtn.png"), for: .normal)
        self.Button2?.setTitle("世\n界", for: .normal)
        self.Button2?.titleLabel!.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(2))
        self.Button2?.titleLabel?.numberOfLines = 2
        self.Button2?.setTitleColor(UIColor.lightGray, for: .normal)
        self.Button2?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
        self.Button2?.tag = 1
        
        self.Button3?.frame = CGRect(x: 0, y: 84, width: 30, height: 42)
        self.Button3?.setBackgroundImage(UIImage(named: "talkbtn.png"), for: .normal)
        self.Button3?.setTitle("系\n统", for: .normal)
        self.Button3?.titleLabel!.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(2))
        self.Button3?.titleLabel?.numberOfLines = 2
        self.Button3?.setTitleColor(UIColor.lightGray, for: .normal)
        self.Button3?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
        self.Button3?.tag = 2
        
        self.NewTip1?.frame = CGRect(x: 25, y: 5, width: 2, height: 2)
        self.NewTip1?.backgroundColor = UIColor.red
        self.NewTip1?.isHidden = true
        
        self.NewTip2?.frame = CGRect(x: 25, y: 5, width: 2, height: 2)
        self.NewTip2?.backgroundColor = UIColor.red
        self.NewTip2?.isHidden = true
        
        self.NewTip3?.frame = CGRect(x: 25, y: 5, width: 2, height: 2)
        self.NewTip3?.backgroundColor = UIColor.red
        self.NewTip3?.isHidden = true
        
    }
    
}
