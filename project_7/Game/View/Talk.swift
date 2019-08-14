import UIKit

class Talk : UIView {
    
//    var Button1 : UIButton?       //队伍聊天按钮
//    var Button2 : UIButton?       //世界聊天按钮
//    var Button3 : UIButton?       //系统聊天按钮
//    var SelectBtn : UIButton?     //选中的按钮
//    var NewTip1 : UIView?         //队伍红点提示
//    var NewTip2 : UIView?         //世界红点提示
//    var NewTip3 : UIView?         //系统红点提示
    var TalkView : UIView?            //聊天框
    var ScrollView : UIScrollView?
    var TableView1 : UITableView?     //队伍聊天
    var TableView2 : UITableView?     //世界聊天
    var TableView3 : UITableView?     //系统聊天
    
    override init(frame : CGRect)
        
    {
        super.init(frame: frame)
        
//        self.Button1 = UIButton()
//        self.addSubview(Button1!)
//
//        self.Button2 = UIButton()
//        self.addSubview(Button2!)
//
//        self.Button3 = UIButton()
//        self.addSubview(Button3!)
//
//        self.NewTip1 = UIView()
//        self.Button1?.addSubview(NewTip1!)
//
//        self.NewTip2 = UIView()
//        self.Button2?.addSubview(NewTip2!)
//
//        self.NewTip3 = UIView()
//        self.Button3?.addSubview(NewTip3!)
        
        self.TalkView = UIView()
        self.addSubview(TalkView!)
        
        self.ScrollView = UIScrollView()
        self.TalkView?.addSubview(ScrollView!)
        
        self.TableView1 = UITableView()
        self.ScrollView?.addSubview(TableView1!)
        
        self.TableView2 = UITableView()
        self.ScrollView?.addSubview(TableView2!)
        
        self.TableView3 = UITableView()
        self.ScrollView?.addSubview(TableView3!)
        
        setUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
//        self.Button1?.frame = CGRect(x: 150, y: 0, width: 30, height: 42)
//        self.Button1?.setBackgroundImage(UIImage(named: "talkbtn.png"), for: .normal)
//        self.Button1?.setTitle("队\n伍", for: .normal)
//        self.Button1?.titleLabel!.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(2))
//        self.Button1?.titleLabel?.numberOfLines = 2
//        self.Button1?.setTitleColor(UIColor.lightGray, for: .normal)
//        self.Button1?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
//        self.Button1?.tag = 0
//        self.Button1?.isSelected = true
//        self.SelectBtn = self.Button1
//
//        self.Button2?.frame = CGRect(x: 150, y: 42, width: 30, height: 42)
//        self.Button2?.setBackgroundImage(UIImage(named: "talkbtn.png"), for: .normal)
//        self.Button2?.setTitle("世\n界", for: .normal)
//        self.Button2?.titleLabel!.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(2))
//        self.Button2?.titleLabel?.numberOfLines = 2
//        self.Button2?.setTitleColor(UIColor.lightGray, for: .normal)
//        self.Button2?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
//        self.Button2?.tag = 1
//
//        self.Button3?.frame = CGRect(x: 150, y: 84, width: 30, height: 42)
//        self.Button3?.setBackgroundImage(UIImage(named: "talkbtn.png"), for: .normal)
//        self.Button3?.setTitle("系\n统", for: .normal)
//        self.Button3?.titleLabel!.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(2))
//        self.Button3?.titleLabel?.numberOfLines = 2
//        self.Button3?.setTitleColor(UIColor.lightGray, for: .normal)
//        self.Button3?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
//        self.Button3?.tag = 2
//
//        self.NewTip1?.frame = CGRect(x: 25, y: 5, width: 2, height: 2)
//        self.NewTip1?.backgroundColor = UIColor.red
//        self.NewTip1?.isHidden = true
//
//        self.NewTip2?.frame = CGRect(x: 25, y: 5, width: 2, height: 2)
//        self.NewTip2?.backgroundColor = UIColor.red
//        self.NewTip2?.isHidden = true
//
//        self.NewTip3?.frame = CGRect(x: 25, y: 5, width: 2, height: 2)
//        self.NewTip3?.backgroundColor = UIColor.red
//        self.NewTip3?.isHidden = true
        
        self.TalkView?.frame = CGRect(x: 0, y: 0, width: 150, height: 126)
        self.TalkView?.backgroundColor = UIColor(patternImage: UIImage(named:"talkbg.png")!)
        
        self.ScrollView?.frame = CGRect(x: 0, y: 0, width: 150, height: 126)
        self.ScrollView?.contentSize = CGSize(width: 0, height: 120)
        self.ScrollView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.ScrollView?.showsHorizontalScrollIndicator = false
        self.ScrollView?.showsVerticalScrollIndicator = false
        self.ScrollView?.scrollsToTop = false
        
        self.TableView1?.frame = CGRect(x: 0, y: 5, width: 150, height: 116)
        self.TableView1?.backgroundColor = UIColor.clear
        self.TableView1?.separatorStyle = .none
        
        self.TableView2?.frame = CGRect(x: 150, y: 5, width: 150, height: 116)
        self.TableView2?.backgroundColor = UIColor.clear
        self.TableView2?.separatorStyle = .none
        
        self.TableView3?.frame = CGRect(x: 300, y: 5, width: 150, height: 116)
        self.TableView3?.backgroundColor = UIColor.clear
        self.TableView3?.separatorStyle = .none
        
    }
    
}
