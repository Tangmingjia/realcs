import UIKit

class GameView : UIView {
    
    var map : Map?                  //地图
//    var cloudView : UIImageView?    //云层
    var weatherView : WHWeatherView?  //天气
//    var randomNum : UInt32 = 0      //随机数
//    var weather : WHWeatherType?    //天气类型
    var my : myInformation?         //我的信息
    var Hatbg : UIImageView?        //我的头盔框
    var HatView : UIImageView?      //我的头盔
    var Clothesbg : UIImageView?    //我的背心框
    var ClothesView : UIImageView?  //我的背心
    var Gunbg : UIImageView?        //我的武器框
    var GunView : UIImageView?      //我的武器
    var gameStatusView : UIImageView?  //游戏状态框
    var InternetLabel : UILabel?  //网络状态
    var GameStatus : UILabel?     //游戏状态
    var TotalNum : UILabel?       //剩余人数
    var gameCountDown : UILabel?   //游戏倒计时
    var gameKillNum : UILabel?     //游戏最高杀人数
    var Poisontitle : UILabel?    //毒圈倒计时
    var Bombtitle : UILabel?      //轰炸倒计时
    var BagButton : UIButton?     //背包按钮
    var Speech : ZFJChatInputTool?    //语音相关工具
    var talkbtn : talkButton?    //语音频道控件
    var talk : Talk?             //语音系统
    var TeamButton : UIButton?    //队伍按钮
    var TeamView : UIView?        //队伍框
    var TeamCollectionView : UICollectionView?    //队伍 大于4人 用collectionView
    var TeamTableView : UITableView?  //队伍 小于4人  用tableView
    var bag : Bag?                    //背包
    var operation : Operation?        //操作框
    var SaveView : Save?              //救人控件
    var PackageView : UIImageView?    //腰包状态
    var shieldView : UIView?          //干扰状态底层
    var shieldImage : UIImageView?    //干扰状态
    var dyingView : UIView?          //濒死状态底层
    var dyingImage : UIImageView?     //濒死状态
    var dyingLabel : UILabel?         //濒死时显示的数字
    var StartLabel : UILabel?         //游戏开始
    var deadImage : UIImageView?       //死亡状态
    var results : battleResults?       //战绩
    
    override init(frame : CGRect)
        
    {
        
        super.init(frame: frame)
        
        self.map = Map()
        self.addSubview(map!)
        
//        self.cloudView = UIImageView()
//        self.addSubview(cloudView!)
        
        self.weatherView = WHWeatherView()
        self.addSubview(weatherView!)
        
        self.my = myInformation()
        self.addSubview(my!)
        
        self.Hatbg = UIImageView()
        self.addSubview(Hatbg!)
        
        self.HatView = UIImageView()
        self.Hatbg?.addSubview(HatView!)
        
        self.Clothesbg = UIImageView()
        self.addSubview(Clothesbg!)

        self.ClothesView = UIImageView()
        self.Clothesbg?.addSubview(ClothesView!)
        
        self.Gunbg = UIImageView()
        self.addSubview(Gunbg!)

        self.GunView = UIImageView()
        self.Gunbg?.addSubview(GunView!)
        
        self.gameStatusView = UIImageView()
        self.addSubview(gameStatusView!)
        
        self.InternetLabel = UILabel()
        self.gameStatusView?.addSubview(InternetLabel!)

        self.GameStatus = UILabel()
        self.gameStatusView?.addSubview(GameStatus!)

        self.TotalNum = UILabel()
        self.addSubview(TotalNum!)
        
        self.gameCountDown = UILabel()
        self.addSubview(gameCountDown!)
        
        self.gameKillNum = UILabel()
        self.addSubview(gameKillNum!)

        self.Poisontitle = UILabel()

        self.Bombtitle = UILabel()
        
        self.BagButton = UIButton()
        self.addSubview(BagButton!)
        
        self.Speech = ZFJChatInputTool()
        self.addSubview(Speech!)
        
        self.talkbtn = talkButton()
        self.addSubview(talkbtn!)
        
        self.talk = Talk()
        self.addSubview(talk!)
        
        self.TeamButton = UIButton()
        self.addSubview(TeamButton!)
        
        self.TeamView = UIView()
        self.addSubview(TeamView!)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 195, height: 52)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        self.TeamCollectionView = UICollectionView(frame: CGRect(x: 15, y: 10, width: 400, height: 280), collectionViewLayout: layout)
        self.TeamCollectionView?.backgroundColor = UIColor.clear
        self.TeamCollectionView?.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        self.TeamView?.addSubview(TeamCollectionView!)

        self.TeamTableView = UITableView()
        self.addSubview(TeamTableView!)
        
        self.bag = Bag()
        self.addSubview(bag!)
        
        self.operation = Operation()
        self.addSubview(operation!)
        
        self.SaveView = Save()
        self.addSubview(SaveView!)
        
        self.PackageView = UIImageView()
        self.addSubview(PackageView!)
        
        self.shieldView = UIView()
        self.addSubview(shieldView!)

        self.shieldImage = UIImageView()
        self.shieldView?.addSubview(shieldImage!)
        
        self.dyingView = UIView()
        self.addSubview(dyingView!)
        
        self.dyingImage = UIImageView()
        self.addSubview(dyingImage!)
        
        self.dyingLabel = UILabel()
        self.dyingView?.addSubview(dyingLabel!)

        self.StartLabel = UILabel()
        self.addSubview(StartLabel!)
        
        self.deadImage = UIImageView()
        self.addSubview(deadImage!)
        
        self.results = battleResults()
        self.addSubview(results!)
        
        setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.map?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        
        self.weatherView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: 0)
//        random()
//        self.weatherView?.showWeatherAnimation(with: weather!)
        
//        self.cloudView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
//        self.cloudView?.image = UIImage(named: "yun.png")
        
        self.my?.frame = CGRect(x: 10, y: 10, width: 250, height: 36)
        
        self.Hatbg?.frame = CGRect(x: 10, y: ScreenSize.height-70, width: 80, height: 60)
        self.Hatbg?.image = UIImage(named: "equipbg.png")
        
        self.HatView?.frame = CGRect(x: 20, y: 10, width: 40, height: 40)
        self.HatView?.image = UIImage(named: "hat.png")
        self.HatView?.contentMode = .scaleAspectFill

        self.Clothesbg?.frame = CGRect(x: 100, y: ScreenSize.height-70, width: 80, height: 60)
        self.Clothesbg?.image = UIImage(named: "equipbg.png")
        
        self.ClothesView?.frame = CGRect(x: 20, y: 10, width: 40, height: 40)
        self.ClothesView?.image = UIImage(named: "clothes.png")
        self.ClothesView?.contentMode = .scaleAspectFill
        
        self.Gunbg?.frame = CGRect(x: ScreenSize.width/2-80, y: ScreenSize.height-70, width: 160, height: 60)
        self.Gunbg?.image = UIImage(named: "gunview.png")

        self.GunView?.frame = CGRect(x: 20, y: 10, width: 120, height: 40)
        self.GunView?.image = UIImage(named: "gun.png")
//        self.GunView?.contentMode = .scaleAspectFill

        self.TotalNum?.frame = CGRect(x: ScreenSize.width-120, y: 10, width: 110, height: 20)
        self.TotalNum?.backgroundColor = UIColor.clear
        self.TotalNum?.textColor = UIColor.orange
        self.TotalNum?.textAlignment = .right
        self.TotalNum?.font = UIFont.systemFont(ofSize: 10)
        self.TotalNum?.isHidden = true
        
        self.gameKillNum?.frame = CGRect(x: ScreenSize.width-120, y: 30, width: 110, height: 20)
        self.gameKillNum?.backgroundColor = UIColor.clear
        self.gameKillNum?.textColor = UIColor.orange
        self.gameKillNum?.textAlignment = .left
        self.gameKillNum?.font = UIFont.systemFont(ofSize: 10)
        self.gameKillNum?.isHidden = true
        
        self.gameCountDown?.frame = CGRect(x: ScreenSize.width-120, y: 10, width: 110, height: 20)
        self.gameCountDown?.backgroundColor = UIColor.clear
        self.gameCountDown?.textColor = UIColor.orange
        self.gameCountDown?.textAlignment = .left
        self.gameCountDown?.font = UIFont.systemFont(ofSize: 10)
        self.gameCountDown?.isHidden = true

        self.gameStatusView?.frame = CGRect(x: ScreenSize.width/2-50, y: 10, width: 100, height: 30)
        self.gameStatusView?.image = UIImage(named: "nosign.png")
        
        self.InternetLabel?.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.InternetLabel?.text = "网络无响应"
        self.InternetLabel?.textAlignment = .center
        self.InternetLabel?.textColor = UIColor.orange
        self.InternetLabel?.font = UIFont.systemFont(ofSize: 10)
        self.InternetLabel?.backgroundColor = UIColor.clear
        self.InternetLabel?.isHidden = true
        
        self.GameStatus?.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        self.GameStatus?.backgroundColor = UIColor.clear
        self.GameStatus?.textColor = UIColor.orange
        self.GameStatus?.textAlignment = .center
        self.GameStatus?.font = UIFont.systemFont(ofSize: 10)

        self.Poisontitle?.frame = CGRect(x: -50, y: 0, width: 100, height: 20)
        self.Poisontitle?.textColor = UIColor.white
        self.Poisontitle?.textAlignment = .center
        self.Poisontitle?.font = UIFont.systemFont(ofSize: 14)
        
        self.Bombtitle?.frame = CGRect(x: -50, y: 0, width: 100, height: 20)
        self.Bombtitle?.textColor = UIColor.white
        self.Bombtitle?.textAlignment = .center
        self.Bombtitle?.font = UIFont.systemFont(ofSize: 14)
        
        self.BagButton?.frame = CGRect(x: ScreenSize.width-140, y: ScreenSize.height-70, width: 60, height: 60)
        self.BagButton?.setImage(UIImage(named: "beibao.png"), for: .normal)
        
        self.Speech?.frame = CGRect(x: ScreenSize.width-70, y: ScreenSize.height-70, width: 60, height: 60)
        
        self.talk?.frame = CGRect(x: ScreenSize.width-180, y: ScreenSize.height/2-63, width: 150, height: 126)
        self.talk?.isHidden = true
        
        self.talkbtn?.frame = CGRect(x: ScreenSize.width-30, y: ScreenSize.height/2-63, width: 30, height: 126)
        
        self.TeamButton?.frame = CGRect(x: 10, y: 60, width: 60, height: 40)
        self.TeamButton?.setBackgroundImage(UIImage(named: "teambtn.png"), for: .normal)
        self.TeamButton?.isHidden = true
        
        self.TeamView?.frame = CGRect(x: ScreenSize.width/2-215, y: ScreenSize.height/2-150, width: 430, height: 300)
        self.TeamView?.backgroundColor = UIColor(patternImage: UIImage(named: "teamviewbg.png")!)
        self.TeamView?.isHidden = true
        
        self.TeamTableView?.frame = CGRect(x: 10, y: 50, width: 290, height: 180)
        self.TeamTableView?.backgroundColor = UIColor.clear
        self.TeamTableView?.separatorStyle = .none
        self.TeamTableView?.isScrollEnabled = false
        
        self.bag?.frame = CGRect(x: ScreenSize.width/2-195, y: ScreenSize.height/2-160, width: 390, height: 320)
        self.bag?.isHidden = true
        
        self.operation?.frame = CGRect(x: ScreenSize.width/2-150, y: ScreenSize.height/2-50, width: 300, height: 100)
        self.operation?.isHidden = true
        
        self.SaveView?.frame = CGRect(x: ScreenSize.width/2-245, y: ScreenSize.height/2-125, width: 490, height: 250)
        self.SaveView?.isHidden = true
        
        self.PackageView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.PackageView?.image = UIImage(named: "nopackage.png")
        self.PackageView?.isHidden = true
        
        self.shieldView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.shieldView?.isHidden = true
        
        self.shieldImage?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        animation(ImageName: "xinhaoganrao", ImageView: shieldImage!)
        
        self.dyingView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.dyingView?.isHidden = true
        
        self.dyingImage?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        animation(ImageName: "binsi", ImageView: dyingImage!)
        self.dyingImage?.isHidden = true
        
        self.dyingLabel?.frame = CGRect(x: ScreenSize.width/2-250, y: ScreenSize.height/2-68, width: 500, height: 136)
        self.dyingLabel?.backgroundColor = UIColor(patternImage: UIImage(named: "saveNumBG.png")!)
        self.dyingLabel?.textAlignment = .center
        self.dyingLabel?.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight(1))
        self.dyingLabel?.textColor = UIColor.white
        
        self.StartLabel?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.StartLabel?.textAlignment = .center
        self.StartLabel?.textColor = UIColor.white
        self.StartLabel?.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight(rawValue: 2))
        self.StartLabel?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.StartLabel?.isHidden = true
        
        self.deadImage?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.deadImage?.image = UIImage(named: "dead.png")
        self.deadImage?.isHidden = true
        
        self.results?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.results?.isHidden = true
        
        //隐藏手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        tap.numberOfTapsRequired = 3   //点击次数
        tap.numberOfTouchesRequired = 3  //所需手指数
        self.addGestureRecognizer(tap)
    }
    
//    func random(){
//        randomNum = arc4random_uniform(5)
//        switch randomNum {
//        case 0:
//            weather = WHWeatherType.sun
//        case 1:
//            weather = WHWeatherType.clound
//        case 2:
//            weather = WHWeatherType.rain
//        case 3:
//            weather = WHWeatherType.rainLighting
//        case 4:
//            weather = WHWeatherType.snow
//        default:
//            weather = WHWeatherType.other
//        }
//    }
    
    @objc func tap(_ tapGesture: UITapGestureRecognizer) {
        PackageView?.removeFromSuperview()
    }
}
