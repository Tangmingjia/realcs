import UIKit

class battleResults : UIView {
    
    var battleResultsView : UIImageView?       //战绩结果
//    var battleResultsView_2 : UIImageView?       //战绩结果-吃鸡
    var playerId : UILabel?                   //玩家ID
    var damage : UILabel?                     //伤害
    var kill : UILabel?                       //击杀次数
    var survival : UILabel?                   //存活时间
    var dead : UILabel?                       //死亡次数
    var rank : UILabel?                       //排名
    var teamResultsTableView : UITableView?   //战绩表单
//    var continueButton : UIButton?      //继续按钮
    var logoutButton : UIButton?        //退出按钮
    var ResultsView : UIImageView?      //结算图片
    
    override init(frame : CGRect)
        
    {
        super.init(frame: frame)
        
        self.battleResultsView = UIImageView()
        self.addSubview(battleResultsView!)
        
//        self.battleResultsView_2 = UIImageView()
//        self.addSubview(battleResultsView_2!)
        
        self.playerId = UILabel()
        self.battleResultsView?.addSubview(playerId!)
        
        self.damage = UILabel()
        self.battleResultsView?.addSubview(damage!)
        
        self.kill = UILabel()
        self.battleResultsView?.addSubview(kill!)
        
        self.survival = UILabel()
        self.battleResultsView?.addSubview(survival!)
        
        self.dead = UILabel()
        self.battleResultsView?.addSubview(dead!)
        
        self.rank = UILabel()
        self.battleResultsView?.addSubview(rank!)
        
        self.teamResultsTableView = UITableView()
        self.battleResultsView?.addSubview(teamResultsTableView!)
        
//        self.continueButton = UIButton()
//        self.addSubview(continueButton!)
        
        self.logoutButton = UIButton()
        self.battleResultsView?.addSubview(logoutButton!)
        
        self.ResultsView = UIImageView()
        self.addSubview(ResultsView!)
        
        setUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.battleResultsView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
//        self.battleResultsView?.image = UIImage(named: "zhanbao_1.png")
        self.battleResultsView?.isHidden = true
        self.battleResultsView?.isUserInteractionEnabled = true
        
//        self.battleResultsView_2?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
//        self.battleResultsView_2?.image = UIImage(named: "zhanbao_2.png")
//        self.battleResultsView_2?.isHidden = true
        
        self.playerId?.frame = CGRect(x: ScreenSize.width/2-185, y: ScreenSize.height/2-90, width: 50, height: 20)
        self.playerId?.text = "玩家ID"
        self.playerId?.textColor = UIColor.white
        self.playerId?.font = UIFont.systemFont(ofSize: 16)
        
        self.damage?.frame = CGRect(x: ScreenSize.width/2-75, y: ScreenSize.height/2-90, width: 50, height: 20)
        self.damage?.text = "伤害"
        self.damage?.textColor = UIColor.white
        self.damage?.font = UIFont.systemFont(ofSize: 16)
        
        self.kill?.frame = CGRect(x: ScreenSize.width/2+50, y: ScreenSize.height/2-90, width: 50, height: 20)
        self.kill?.text = "击杀"
        self.kill?.textColor = UIColor.white
        self.kill?.font = UIFont.systemFont(ofSize: 16)
        
        self.survival?.frame = CGRect(x: ScreenSize.width/2+170, y: ScreenSize.height/2-90, width: 80, height: 20)
        self.survival?.text = "存活时间"
        self.survival?.textColor = UIColor.white
        self.survival?.font = UIFont.systemFont(ofSize: 16)
        self.survival?.isHidden = true
        
        self.dead?.frame = CGRect(x: ScreenSize.width/2+190, y: ScreenSize.height/2-90, width: 80, height: 20)
        self.dead?.text = "死亡"
        self.dead?.textColor = UIColor.white
        self.dead?.font = UIFont.systemFont(ofSize: 16)
        self.dead?.isHidden = true
        
        self.rank?.frame = CGRect(x: ScreenSize.width-120, y: ScreenSize.height/2-140, width: 120, height: 30)
        self.rank?.font = UIFont.systemFont(ofSize: 30)
        self.rank?.textColor = UIColor.orange
        self.rank?.textAlignment = .center
        
        self.teamResultsTableView?.frame = CGRect(x: ScreenSize.width/2-250, y: ScreenSize.height/2-70, width: 500, height: 200)
        self.teamResultsTableView?.backgroundColor = UIColor.clear
        self.teamResultsTableView?.separatorStyle = .none
        
//        self.continueButton?.frame = CGRect(x: ScreenSize.width-200, y: ScreenSize.height-50, width: 80, height: 20)
//        self.continueButton?.setTitle("继续", for: .normal)
//        self.continueButton?.setTitleColor(UIColor.white, for: .normal)
//        self.continueButton?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
//        self.continueButton?.layer.cornerRadius = 5
//        self.continueButton?.layer.masksToBounds = true
        
        self.logoutButton?.frame = CGRect(x: ScreenSize.width-100, y: ScreenSize.height-50, width: 80, height: 20)
        self.logoutButton?.setTitle("返回登录界面", for: .normal)
        self.logoutButton?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.logoutButton?.setTitleColor(UIColor.white, for: .normal)
        self.logoutButton?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
        self.logoutButton?.layer.cornerRadius = 5
        self.logoutButton?.layer.masksToBounds = true
        
        self.ResultsView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.ResultsView?.image = UIImage(named: "jiesuan.png")
    }
    
}
