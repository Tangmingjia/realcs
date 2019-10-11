import UIKit
import Starscream
import CoreLocation
import Kingfisher
import Alamofire
import SVProgressHUD

public var mapPath : String?
class GameViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITableViewDelegate,UITableViewDataSource,WebSocketDelegate,ZFJVoiceBubbleDelegate,CLLocationManagerDelegate,BMKMapViewDelegate,GCDAsyncSocketDelegate,BMKLocationManagerDelegate{

    var weatherMain : String?    //主要天气
    var weatherDescription : String?  //具体天气
    var weather : WHWeatherType?   //天气类型
    var syncTile = BMKLocalSyncTileLayer()   //瓦片
    var btn : ZFJVoiceBubble!            //语音工具
    var clientSocket : GCDAsyncSocket?   //socket连接mina服务器
    let gps = CLLocationManager()        //gps
    var websocket : WebSocket?           //websocket
    var gameRule : Int?
    var LastBlood : Int = 0
    var MyName : String?
    var MyLat: CLLocationDegrees?
    var MyLon: CLLocationDegrees?
    var MyStatus : Int?
    var gunNO : String?
    var hatNO : String?
    var clothesNO : String?
    var ReportArray : Array = [String]()
    var Equip : Dictionary = [Int? : gpsEquipTypeListItem]()
    var centerLat: CLLocationDegrees?
    var centerLon: CLLocationDegrees?
    var center : CLLocationCoordinate2D?
    var i = 0
    var j = 0
    var airdrop : [AirdropEntityListItem]?
    var gameCountDown_h : Int?
    var gameCountDown_m : Int?
    var gameCountDown_s : Int?
    var MyTeamName : Array = [String]()
    var MyTeamIcon : Array = [String]()
    var MyTeamBlood : Array = [Int]()
    var MyTeamDyingBlood : Array = [Int]()
    var MyTeamArmor : Array = [Int]()
    var MyTeamStatus : Array = [Int]()
    var MyTeamKill : Array = [Int]()
    var MyTeamDamage : Array = [Int]()
    var TeamName : Array = [String]()
    var TeamIcon : Array = [String]()
    var TeamDamage : Array = [Int]()
    var TeamKill : Array = [Int]()
    var TeamSurvival : Array = [Int]()
    var TeamDead : Array = [Int]()
    var TeamStatus : Array = [Int]()
    var TeamSurvival_h : Int?
    var TeamSurvival_m : Int?
    var TeamSurvival_s : Int?
    var TeamRank : Int?
    var results_stats : Int?
    var MyTeamPersonId : Array = [Int]()
    var savePersonId : Int?
    var annotationArray = [BMKPointAnnotation()]
    var airdropArray = [BMKPointAnnotation()]
    var airdropCenter : Array = [String]()
    var LonArray : Array = [CLLocationDegrees]()
    var LatArray : Array = [CLLocationDegrees]()
    var IconArray : Array = [String]()
    var bagItemImage : Array = [String]()
    var bagItemName : Array = [String]()
    var bagItemNum : Array = [Int]()
    var bagItemNo : Array = [[String]]()
    var nearItemImage : Array = [String]()
    var nearItemName : Array = [String]()
    var nearItemNum : Array = [Int]()
    var nearItemNo : Array = [[String]]()
    var nearItemId : Array = [Int]()
    var ItemRow : Int?
    var num = 5
    var timer : Timer?
    var talkTimer : Timer?
    var talknum = 10
    var BombAnnotation = BMKPointAnnotation()
    var bombCenter : Array = [String]()
    var BombCircle : BMKCircle?
    var BombCenter : CLLocationCoordinate2D?
    var BombRadius : CLLocationDistance?
    var BCountDown : Int?
    var Bh : Int?
    var Bm : Int?
    var Bs : Int?
    var PoisonAnnotation = BMKPointAnnotation()
    var bCenter : Array = [String]()
    var sCenter : Array = [String]()
    var PoisonCircle_B : BMKCircle?
    var PoisonCenter_B : CLLocationCoordinate2D?
    var PoisonRadius_B : CLLocationDistance?
    var PoisonCircle_S : BMKCircle?
    var PoisonCenter_S : CLLocationCoordinate2D?
    var PoisonRadius_S : CLLocationDistance?
    var PCountDown : Int?
    var Ph : Int?
    var Pm : Int?
    var Ps : Int?
    var CircleBomb = RealcsGameCircleBomb()
    var CirclePoison = RealcsGameCirclePoison()
    var game : GameView?
    var gpsstr : String = ""
    var whoami : String = ""
    var heartTimer : Timer?
    var getDataTimer : Timer?
    var heartjsonData : Data?
    var gpsjsonData : Data?
    var msgjsonData : Data?
    var url : URL?
    var cafstr : String = ""
    var caf : String?
    var teamorworld : String?
    var TeamVoiceName : Array = [String]()
    var TeamUrlArray : Array = [URL]()
    var WorldVoiceName : Array = [String]()
    var WorldUrlArray : Array = [URL]()
    var userLocation: BMKUserLocation = BMKUserLocation()  //定位
    var param: BMKLocationViewDisplayParam = BMKLocationViewDisplayParam()  //精度圈
    var TeamdataSources: [TeamModel] = []      //队伍模型
    var gpsTimer : Timer?
    lazy var onecode : Void = {
        gpsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendgps), userInfo: nil, repeats: true)
        gpsTimer?.fire()
    }()
    
    //MARK:Lazy loading
    lazy var locationManager: BMKLocationManager = {
        //初始化BMKLocationManager的实例
        let manager = BMKLocationManager()
        //设置定位管理类实例的代理
        manager.delegate = self
        //设定定位坐标系类型，默认为 BMKLocationCoordinateTypeGCJ02
        manager.coordinateType = BMKLocationCoordinateType.BMK09LL
        //设定定位精度，默认为 kCLLocationAccuracyBest
        manager.desiredAccuracy = kCLLocationAccuracyBest
        //设定定位类型，默认为 CLActivityTypeAutomotiveNavigation
        manager.activityType = CLActivityType.automotiveNavigation
        //指定定位是否会被系统自动暂停，默认为NO
        manager.pausesLocationUpdatesAutomatically = false
        /**
         是否允许后台定位，默认为NO。只在iOS 9.0及之后起作用。
         设置为YES的时候必须保证 Background Modes 中的 Location updates 处于选中状态，否则会抛出异常。
         由于iOS系统限制，需要在定位未开始之前或定位停止之后，修改该属性的值才会有效果。
         */
        manager.allowsBackgroundLocationUpdates = false
        /**
         指定单次定位超时时间,默认为10s，最小值是2s。注意单次定位请求前设置。
         注意: 单次定位超时时间从确定了定位权限(非kCLAuthorizationStatusNotDetermined状态)
         后开始计算。
         */
        manager.locationTimeout = 10
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(noti(n:)), name: NSNotification.Name(rawValue: "noti"), object: nil)
        
        //gps
        gps.delegate = self
        gps.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        gps.distanceFilter = 1
        gps.requestAlwaysAuthorization()
        gps.requestWhenInUseAuthorization()
        gps.startUpdatingLocation()
        
        //webscoket
        websocket = WebSocket(url: URL(string: "http://\(Host!):8998/websocket/\(game_id!)/0/\(team_id!)")!)
        websocket!.delegate = self
        websocket!.connect()
        
        //心跳包
        whoami = "{\"ACTION\":\"phone-whoami\",\"REQUEST_ID\":\"\(UIDevice.current.identifierForVendor!.uuidString)\",\"DATA\":{\"GAME_ID\":\(game_id!),\"PACKAGE_ID\":\"\(packageNo!)\",\"TEAM_ID\":\(team_id!)}}\r\n"
        heartjsonData = whoami.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        //发送心跳包
        heartTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(heart), userInfo: nil, repeats: true)
        
        //scoket
        do {
            clientSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global())
            try clientSocket?.connect(toHost: Host!, onPort: 25409)
        }
        catch {
        }

        game = GameView()
        game?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.view.addSubview(game!)

        game?.map?.mapView?.delegate = self
        //开启定位服务
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        
        game?.talkbtn?.Button1?.addTarget(self, action: #selector(msgchange(sender:)), for: .touchUpInside)
        game?.talkbtn?.Button2?.addTarget(self, action: #selector(msgchange(sender:)), for: .touchUpInside)
        game?.talkbtn?.Button3?.addTarget(self, action: #selector(msgchange(sender:)), for: .touchUpInside)
        game?.TeamButton?.addTarget(self, action: #selector(openTeam), for: .touchUpInside)
        game?.talk?.TableView1?.delegate = self
        game?.talk?.TableView1?.dataSource = self
        game?.talk?.TableView2?.delegate = self
        game?.talk?.TableView2?.dataSource = self
        game?.talk?.TableView3?.delegate = self
        game?.talk?.TableView3?.dataSource = self
        game?.TeamCollectionView?.delegate = self
        game?.TeamCollectionView?.dataSource = self
        game?.TeamTableView?.delegate = self
        game?.TeamTableView?.dataSource = self
        game?.bag?.bagTableView?.delegate = self
        game?.bag?.bagTableView?.dataSource = self
        game?.bag?.nearTableView?.delegate = self
        game?.bag?.nearTableView?.dataSource = self
        game?.bag?.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap_2(sender:))))
        game?.results?.teamResultsTableView?.delegate = self
        game?.results?.teamResultsTableView?.dataSource = self
        if isAllowed == true {
            game?.Speech?.sendURLAction = {(_ voiceUrl: URL) -> Void in
                self.url = URL(fileURLWithPath: voiceUrl.absoluteString)
            }
        }
        
        game?.BagButton?.addTarget(self, action: #selector(openbag), for: .touchUpInside)
        game?.operation?.useButton?.addTarget(self, action: #selector(useItem), for: .touchUpInside)
        game?.operation?.dropButton?.addTarget(self, action: #selector(dropItem), for: .touchUpInside)
        game?.operation?.cancelButton?.addTarget(self, action: #selector(hiddenOperation), for: .touchUpInside)
        game?.SaveView?.okbtn?.addTarget(self, action: #selector(save), for: .touchUpInside)
//        game?.results?.continueButton?.addTarget(self, action: #selector(Continue), for: .touchUpInside)
        game?.results?.logoutButton?.addTarget(self, action: #selector(Logout), for: .touchUpInside)
        
        //打开个性化地图
        BMKMapView.enableCustomMapStyle(true)
        //隐藏精度圈
        param.isAccuracyCircleShow = false
        //更新定位图层个性化样式
        param.locationViewImage = UIImage(named: "locationImage.png")
        game?.map?.mapView?.updateLocationView(with: param)
        game?.map?.mapView?.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(handleTap(sender:))))
        
//        currentNetReachability()
    }
    
    //MARK:Initialization method
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //获取个性化地图模板文件路径
        let path = Bundle.main.path(forResource: "custom_map_config", ofType: "json")!
        //设置个性化地图样式
        BMKMapView.customMapStyle(path)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false  //防止右滑返回
        game?.map?.mapView?.viewWillAppear()
        SVProgressHUD.dismiss()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        game?.map?.mapView?.viewWillDisappear()
        websocket?.disconnect()
        clientSocket?.disconnect()
        heartTimer?.invalidate()
        heartTimer = nil
        getDataTimer?.invalidate()
        getDataTimer = nil
        gpsTimer?.invalidate()
        gpsTimer = nil
        websocket?.delegate = nil
        clientSocket?.delegate = nil
        websocket = nil
        clientSocket = nil
        game?.dyingImage?.animationImages = nil
        game?.shieldImage?.animationImages = nil
        game?.my?.Blood?.animationImages = nil
        game?.my?.DyingBlood?.animationImages = nil
        game?.my?.Armor?.animationImages = nil
        GameCollectionViewCell().TeamBlood?.animationImages = nil
        GameCollectionViewCell().TeamDyingBlood?.animationImages = nil
        GameCollectionViewCell().TeamArmor?.animationImages = nil
        TeamTableViewCell().TeamBlood?.animationImages = nil
        TeamTableViewCell().TeamDyingBlood?.animationImages = nil
        TeamTableViewCell().TeamArmor?.animationImages = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        websocket?.disconnect(forceTimeout: 0)
        websocket?.delegate = nil
    }
    //登出
    @objc func Logout(){
        isContinue = false
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc func Continue(){
//
//    }
    //救援
    @objc func save(){
        if MyStatus == 1 {
            Alamofire.request("http://\(Host!):8080/apps/ResurrectionPerson", method: .get, parameters: ["gameId": game_id!, "personId": savePersonId!, "randang": Int(SaveNum)]).responseString { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
                        let msg = self.stringValueDic(jsonString)
                        if (msg?.keys.contains("100001"))!{
                            SVProgressHUD.showError(withStatus: "\((msg!["100001"])!)")
                        }else if (msg?.keys.contains("200"))!{
                            SVProgressHUD.showSuccess(withStatus: "\((msg!["200"])!)")
                        }
                    }
                }
            }
        }else{
            SVProgressHUD.showInfo(withStatus: "救援失败")
        }
    }
    //打开救援界面
    @objc func openSave(sender: UIButton){
        game?.SaveView?.cancel()
        savePersonId = MyTeamPersonId[sender.tag]
        if game?.SaveView?.isHidden == true{
            game?.SaveView?.isHidden = false
        }else{
            game?.SaveView?.isHidden = true
        }
    }
    //打开队伍界面
    @objc func openTeam(){
        if game?.TeamView?.isHidden == true{
            game?.TeamView?.isHidden = false
        }else{
            game?.TeamView?.isHidden = true
        }
    }
    
//    func hiddenBtn(){
//        let array = game?.bagTableView?.indexPathsForVisibleRows
//        for indexPath in array! {
//            let cell = game?.bagTableView?.cellForRow(at: indexPath) as? BagTableViewCell
//            cell?.useButton?.isHidden = true
//            cell?.dropButton?.isHidden = true
//        }
//    }
    //丢弃道具
    @objc func dropItem(){
//        hiddenBtn()
        //操作太快会导致selectRow > numberOfRows-1 报错
        if (game?.bag?.bagTableView?.numberOfRows(inSection: 0))!-1 >= ItemRow! && bagItemNo.count != 0 && bagItemNo[ItemRow!].count != 0{
            Alamofire.request("http://\(Host!):8080/apps/deleteEquip", method: .get, parameters: ["gameId": game_id!, "personId": person_id!, "equipNo": bagItemNo[ItemRow!][0]]).responseString { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
                        let msg = self.stringValueDic(jsonString)
                        if (msg?.keys.contains("100001"))!{
                            SVProgressHUD.showError(withStatus: "\((msg!["100001"])!)")
                        }else if (msg?.keys.contains("200"))!{
                            SVProgressHUD.showSuccess(withStatus: "\((msg!["200"])!)")
                        }
                    }
                }
            }
            hiddenOperation()
        } else {
            SVProgressHUD.showError(withStatus: "操作失败")
        }
    }
    //使用道具
    @objc func useItem(){
//        hiddenBtn()
        if (game?.bag?.bagTableView?.numberOfRows(inSection: 0))!-1 >= ItemRow! && bagItemNo.count != 0 && bagItemNo[ItemRow!].count != 0{
            Alamofire.request("http://\(Host!):8080/apps/addBlood", method: .get, parameters: ["gameId": game_id!, "personId": person_id!, "equipNo": bagItemNo[ItemRow!][0]]).responseString { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
//                        print(jsonString)
                        let msg = self.stringValueDic(jsonString)
                        if (msg?.keys.contains("100001"))!{
                            SVProgressHUD.showError(withStatus: "\((msg!["100001"])!)")
                        }else if (msg?.keys.contains("200"))!{
                            SVProgressHUD.showSuccess(withStatus: "\((msg!["200"])!)")
                        }
                    }
                }
            }
            hiddenOperation()
        } else {
            SVProgressHUD.showError(withStatus: "操作失败")
        }
    }
    //关闭物品操作提示界面
    @objc func hiddenOperation(){
        game?.operation?.isHidden = true
    }
    //创建聊天屏道自动隐藏定时器
    func talkcloseOpen(){
        if talkTimer == nil{
            talkTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(talkclose), userInfo: nil, repeats: true)
            talkTimer?.fire()
        }
    }
    //聊天屏道自动隐藏方法
    @objc func talkclose(){
        if talknum > 0{
            game?.talk?.isHidden = false
            talknum -= 1
        }else{
            talkTimer?.invalidate()
            talkTimer = nil
            talknum = 10
            game?.talk?.isHidden = true
        }
    }
    //打开背包
    @objc func openbag() {
        if game?.bag?.isHidden == true{
            game?.bag?.isHidden = false
        }else{
            game?.bag?.isHidden = true
        }
    }
    //创建getData定时器
    func startgetData(){
        if getDataTimer == nil {
            //每秒获取数据
            getDataTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
            getDataTimer?.fire()
        }
    }
    //停止getData并销毁定时器
    func stopgetData(){
        if getDataTimer != nil{
            getDataTimer?.invalidate()  //销毁定时器
            getDataTimer = nil
        }
    }
    //轮询获取数据
    @objc func getData(){
        Alamofire.request("http://\(Host!):8080/apps/getAppData", method: .get, parameters: ["gameId": game_id!, "teamId": team_id!, "personId": person_id!]).responseString { (response) in
            if response.result.isSuccess {
                self.game?.InternetLabel?.isHidden = true
                self.game?.GameStatus?.isHidden = false
                if let jsonString = response.result.value {
//                    print(jsonString)
                    self.MyTeamName.removeAll()
                    self.MyTeamIcon.removeAll()
                    self.MyTeamBlood.removeAll()
                    self.MyTeamDyingBlood.removeAll()
                    self.MyTeamArmor.removeAll()
                    self.MyTeamStatus.removeAll()
                    self.MyTeamKill.removeAll()
                    self.MyTeamDamage.removeAll()
                    self.TeamStatus.removeAll()
                    self.TeamDamage.removeAll()
                    self.TeamKill.removeAll()
                    self.TeamSurvival.removeAll()
                    self.TeamDead.removeAll()
                    self.Equip.removeAll()
                    self.IconArray.removeAll()
                    self.LatArray.removeAll()
                    self.LonArray.removeAll()
                    self.game?.map?.mapView?.removeAnnotations(self.annotationArray)
                    self.annotationArray.removeAll()
                    self.game?.map?.mapView?.removeAnnotations(self.airdropArray)
                    self.airdropArray.removeAll()
                    self.nearItemImage.removeAll()
                    self.nearItemName.removeAll()
                    self.nearItemNum.removeAll()
                    self.nearItemNo.removeAll()
                    self.nearItemId.removeAll()
                    self.bagItemImage.removeAll()
                    self.bagItemName.removeAll()
                    self.bagItemNum.removeAll()
                    self.bagItemNo.removeAll()
                    if let responseModel = GpsModel.deserialize(from: jsonString) {
                        if jsonString != "{}" {
                            if responseModel.data?.status == 6 {
                                self.game?.GameStatus?.text = "游戏准备中"
                            }
                            else if responseModel.data?.status == 3 {
                                self.gameRule = responseModel.data?.gameRule
                                if self.gameRule == 1 {
                                    self.game?.GameStatus?.text = "绝地求生"
                                    let attributeString = NSMutableAttributedString(string: "剩余人数:"+"\(responseModel.data!.total)"+"/\(responseModel.data!.totalNum)")
                                    let range: NSRange = (attributeString.string as NSString).range(of:"\(responseModel.data!.total)")
                                    attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 142/255, green: 184/255, blue: 200/255, alpha: 1), range: range)
                                    self.game?.TotalNum?.attributedText = attributeString
                                    self.game?.TotalNum?.isHidden = false
                                    self.game?.gameKillNum?.isHidden = true
                                    self.game?.gameCountDown?.isHidden = true
                                }else if self.gameRule == 2 {
                                    self.game?.GameStatus?.text = "王者吃鸡"
                                    self.game?.TotalNum?.isHidden = true
                                    if responseModel.data!.gameKillNum != 0 {
                                        let attributeString = NSMutableAttributedString(string: "最高击杀数:"+"\(responseModel.data!.killNum)"+"/\(responseModel.data!.gameKillNum)")
                                        let range: NSRange = (attributeString.string as NSString).range(of:"\(responseModel.data!.killNum)")
                                        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 142/255, green: 184/255, blue: 200/255, alpha: 1), range: range)
                                        self.game?.gameKillNum?.attributedText = attributeString
                                        self.game?.gameKillNum?.isHidden = false
                                    }else{
                                        self.game?.gameKillNum?.isHidden = true
                                    }
                                    if responseModel.data!.gameDuration != 0 {
                                        self.gameCountDown_h = Int(floor(Double(responseModel.data!.duration/3600)))
                                        self.gameCountDown_m = Int(floor(Double((responseModel.data!.duration%3600)/60)))
                                        self.gameCountDown_s = (responseModel.data!.duration%3600)%60
                                        let attributeString = NSMutableAttributedString(string: "结束倒计时:"+String(format:"%02d",self.gameCountDown_h!)+":"+String(format:"%02d",self.gameCountDown_m!)+":"+String(format:"%02d",self.gameCountDown_s!))
                                        let range: NSRange = (attributeString.string as NSString).range(of:String(format:"%02d",self.gameCountDown_h!)+":"+String(format:"%02d",self.gameCountDown_m!)+":"+String(format:"%02d",self.gameCountDown_s!))
                                        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 142/255, green: 184/255, blue: 200/255, alpha: 1), range: range)
                                        self.game?.gameCountDown?.attributedText = attributeString
                                        self.game?.gameCountDown?.isHidden = false
                                        self.game?.gameKillNum?.frame.origin.y = 30
                                    }else{
                                        self.game?.gameCountDown?.isHidden = true
                                        self.game?.gameKillNum?.frame.origin.y = 10
                                    }
                                }
                            }
                            else if responseModel.data?.status == 2 {
                                self.game?.GameStatus?.text = "游戏已结束"
                            }
                            else if responseModel.data?.status == 5 {
                                self.game?.GameStatus?.text = "游戏未开始"
                            }
                            if responseModel.data?.airdropEntityList != nil && responseModel.data?.airdropEntityList.count != 0{  //空投和物资
                                self.airdrop = responseModel.data?.airdropEntityList
                                for j in 0..<self.airdrop!.count {
                                    self.j = j
                                    self.airdropArray.append(BMKPointAnnotation())
                                    self.airdropCenter = (self.airdrop![j].center.components(separatedBy: ","))
                                    self.airdropArray[j].coordinate = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.airdropCenter[1]))!, longitude: (CLLocationDegrees(self.airdropCenter[0]))!)
                                    self.game?.map?.mapView?.addAnnotation(self.airdropArray[j])
                                }
                            }
                            if responseModel.data?.realcsGameCircleBomb != nil {   //轰炸区
                                self.game?.map?.mapView?.removeAnnotation(self.BombAnnotation)
                                self.game?.map?.mapView?.remove(self.BombCircle)
                                self.game?.Bombtitle?.removeFromSuperview()
                                if responseModel.data?.realcsGameCircleBomb?.status == 0 {  //轰炸倒计时
                                    self.BCountDown = responseModel.data?.realcsGameCircleBomb?.countDown
                                    self.Bh = Int(floor(Double(self.BCountDown!/3600)))
                                    self.Bm = Int(floor(Double((self.BCountDown!%3600)/60)))
                                    self.Bs = (self.BCountDown!%3600)%60
                                    self.bombCenter = (responseModel.data?.realcsGameCircleBomb?.center.components(separatedBy: ","))!
                                    self.BombCenter = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.bombCenter[1]))!, longitude: (CLLocationDegrees(self.bombCenter[0]))!)
                                    self.BombRadius = CLLocationDistance(responseModel.data!.realcsGameCircleBomb!.radius)
                                    self.BombCircle = BMKCircle(center: self.BombCenter!, radius: self.BombRadius!)
                                    self.game?.map?.mapView?.add(self.BombCircle)
                                    //添加倒计时
                                    self.BombAnnotation.coordinate = self.BombCenter!
                                    self.BombAnnotation.title = String(format:"%02d",self.Bh!)+":"+String(format:"%02d",self.Bm!)+":"+String(format:"%02d",self.Bs!)
                                    self.game?.map?.mapView?.addAnnotation(self.BombAnnotation)
                                }
                                else if responseModel.data?.realcsGameCircleBomb?.status == 2 {  //轰炸开始
                                    self.BCountDown = responseModel.data?.realcsGameCircleBomb?.countDown
                                    self.Bh = Int(floor(Double(self.BCountDown!/3600)))
                                    self.Bm = Int(floor(Double((self.BCountDown!%3600)/60)))
                                    self.Bs = (self.BCountDown!%3600)%60
                                    self.bombCenter = (responseModel.data?.realcsGameCircleBomb?.center.components(separatedBy: ","))!
                                    self.BombCenter = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.bombCenter[1]))!, longitude: (CLLocationDegrees(self.bombCenter[0]))!)
                                    self.BombRadius = CLLocationDistance(responseModel.data!.realcsGameCircleBomb!.radius)
                                    self.BombCircle = BMKCircle(center: self.BombCenter!, radius: self.BombRadius!)
                                    self.game?.map?.mapView?.add(self.BombCircle)
                                    //添加倒计时
                                    self.BombAnnotation.coordinate = self.BombCenter!
                                    self.BombAnnotation.title = String(format:"%02d",self.Bh!)+":"+String(format:"%02d",self.Bm!)+":"+String(format:"%02d",self.Bs!)
                                    self.game?.map?.mapView?.addAnnotation(self.BombAnnotation)
                                }
                                else if responseModel.data?.realcsGameCircleBomb?.status == 1 {  //轰炸结束
                                    self.BCountDown = responseModel.data?.realcsGameCircleBomb?.countDown
                                    self.Bh = Int(floor(Double(self.BCountDown!/3600)))
                                    self.Bm = Int(floor(Double((self.BCountDown!%3600)/60)))
                                    self.Bs = (self.BCountDown!%3600)%60
                                    self.game?.map?.mapView?.remove(self.BombCircle)
                                }
                            }
                            if responseModel.data?.realcsGameCirclePoison != nil{  //毒区
                                self.game?.Poisontitle?.removeFromSuperview()
                                self.game?.map?.mapView?.removeAnnotation(self.PoisonAnnotation)
                                self.game?.map?.mapView?.remove(self.PoisonCircle_B)
                                self.game?.map?.mapView?.remove(self.PoisonCircle_S)
                                if responseModel.data?.realcsGameCirclePoison?.status == 1{   //毒圈倒计时
                                    self.PCountDown = responseModel.data?.realcsGameCirclePoison?.countDown
                                    self.Ph = Int(floor(Double(self.PCountDown!/3600)))
                                    self.Pm = Int(floor(Double((self.PCountDown!%3600)/60)))
                                    self.Ps = (self.PCountDown!%3600)%60
                                    self.bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                                    self.PoisonCenter_B = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.bCenter[1]))!, longitude: (CLLocationDegrees(self.bCenter[0]))!)
                                    self.PoisonRadius_B = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.radius)
                                    self.PoisonCircle_B = BMKCircle(center: self.PoisonCenter_B!, radius: self.PoisonRadius_B!)
                                    self.game?.map?.mapView?.add(self.PoisonCircle_B)   //添加毒圈
                                    self.sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                                    self.PoisonCenter_S = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.sCenter[1]))!, longitude: (CLLocationDegrees(self.sCenter[0]))!)
                                    self.PoisonRadius_S = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.safetyRadius)
                                    self.PoisonCircle_S = BMKCircle(center: self.PoisonCenter_S!, radius: self.PoisonRadius_S!)
                                    self.game?.map?.mapView?.add(self.PoisonCircle_S)    //添加安全区
                                    //添加倒计时
                                    self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                                    self.PoisonAnnotation.title = String(format:"%02d",self.Ph!)+":"+String(format:"%02d",self.Pm!)+":"+String(format:"%02d",self.Ps!)
                                    self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                                }
                                else if responseModel.data?.realcsGameCirclePoison?.status == 2 {   //毒圈缩圈
                                    self.PCountDown = responseModel.data?.realcsGameCirclePoison?.countDown
                                    self.Ph = Int(floor(Double(self.PCountDown!/3600)))
                                    self.Pm = Int(floor(Double((self.PCountDown!%3600)/60)))
                                    self.Ps = (self.PCountDown!%3600)%60
                                    self.bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                                    self.PoisonCenter_B = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.bCenter[1]))!, longitude: (CLLocationDegrees(self.bCenter[0]))!)
                                    self.PoisonRadius_B = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.radius)
                                    self.PoisonCircle_B = BMKCircle(center: self.PoisonCenter_B!, radius: self.PoisonRadius_B!)
                                    self.game?.map?.mapView?.add(self.PoisonCircle_B)
                                    self.sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                                    self.PoisonCenter_S = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.sCenter[1]))!, longitude: (CLLocationDegrees(self.sCenter[0]))!)
                                    self.PoisonRadius_S = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.safetyRadius)
                                    self.PoisonCircle_S = BMKCircle(center: self.PoisonCenter_S!, radius: self.PoisonRadius_S!)
                                    self.game?.map?.mapView?.add(self.PoisonCircle_S)
                                    //添加倒计时
                                    self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                                    self.PoisonAnnotation.title = String(format:"%02d",self.Ph!)+":"+String(format:"%02d",self.Pm!)+":"+String(format:"%02d",self.Ps!)
                                    self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                                }
                                else if responseModel.data?.realcsGameCirclePoison?.status == 3 {  //缩圈结束
                                    self.bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                                    self.PoisonCenter_B = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.bCenter[1]))!, longitude: (CLLocationDegrees(self.bCenter[0]))!)
                                    self.PoisonRadius_B = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.radius)
                                    self.PoisonCircle_B = BMKCircle(center: self.PoisonCenter_B!, radius: self.PoisonRadius_B!)
                                    self.game?.map?.mapView?.add(self.PoisonCircle_B)
                                    self.sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                                    self.PoisonCenter_S = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.sCenter[1]))!, longitude: (CLLocationDegrees(self.sCenter[0]))!)
                                    self.PoisonRadius_S = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.safetyRadius)
                                    self.PoisonCircle_S = BMKCircle(center: self.PoisonCenter_S!, radius: self.PoisonRadius_S!)
                                    self.game?.map?.mapView?.add(self.PoisonCircle_S)
                                }
                                else if responseModel.data?.realcsGameCirclePoison?.status == 4 {  //暂停缩圈
                                    self.bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                                    self.PoisonCenter_B = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.bCenter[1]))!, longitude: (CLLocationDegrees(self.bCenter[0]))!)
                                    self.PoisonRadius_B = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.radius)
                                    self.PoisonCircle_B = BMKCircle(center: self.PoisonCenter_B!, radius: self.PoisonRadius_B!)
                                    self.game?.map?.mapView?.add(self.PoisonCircle_B)
                                    self.sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                                    self.PoisonCenter_S = CLLocationCoordinate2D(latitude: (CLLocationDegrees(self.sCenter[1]))!, longitude: (CLLocationDegrees(self.sCenter[0]))!)
                                    self.PoisonRadius_S = CLLocationDistance(responseModel.data!.realcsGameCirclePoison!.safetyRadius)
                                    self.PoisonCircle_S = BMKCircle(center: self.PoisonCenter_S!, radius: self.PoisonRadius_S!)
                                    self.game?.map?.mapView?.add(self.PoisonCircle_S)
                                    //添加倒计时
                                    self.PoisonAnnotation.coordinate = self.PoisonCenter_S!
                                    self.PoisonAnnotation.title = String(format:"%02d",self.Ph!)+":"+String(format:"%02d",self.Pm!)+":"+String(format:"%02d",self.Ps!)
                                    self.game?.map?.mapView?.addAnnotation(self.PoisonAnnotation)
                                }
                                else if responseModel.data?.realcsGameCirclePoison?.status == 5 {  //重置毒圈
                                }
                            }else{
                                self.game?.map?.mapView?.remove(self.PoisonCircle_B)
                                self.game?.map?.mapView?.remove(self.PoisonCircle_S)
                                self.game?.map?.mapView?.removeAnnotation(self.PoisonAnnotation)
                            }
                            if responseModel.data?.gpsEntityList != nil && responseModel.data!.gpsEntityList.count != 0{
                                responseModel.data?.gpsEntityList.forEach({ (model_1) in
                                    if model_1.personId != person_id{  //队友gps
                                        self.MyTeamName.append(model_1.personName)
                                        self.MyTeamIcon.append(model_1.realcsUpload!.accesslocation)
                                        self.MyTeamBlood.append(model_1.blood)
                                        self.MyTeamDyingBlood.append(model_1.dyingBlood)
                                        self.MyTeamArmor.append(model_1.defence)
                                        self.MyTeamStatus.append(model_1.status)
                                        self.MyTeamKill.append(model_1.killNum)
                                        self.MyTeamDamage.append(model_1.damage)
                                        if model_1.phoneStatus == 1{
                                            self.IconArray.append(model_1.realcsUpload!.accesslocation)
                                            self.LatArray.append(model_1.lat)
                                            self.LonArray.append(model_1.lon)
                                        }
                                    }
                                    if model_1.personId == person_id{  //自己
                                        self.game?.my?.MyName?.text = model_1.personName
                                        self.game?.bag?.IconView?.kf.setImage(with: URL(string: model_1.realcsUpload!.accesslocation!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholder: UIImage(named: "logo.png"))
                                        self.game?.bag?.nickName?.text = model_1.personName
                                        if model_1.airdropEntityList != nil && model_1.airdropEntityList.count != 0 {  //附近物品
                                            model_1.airdropEntityList.forEach({(model_2) in
                                                model_2.airdropEquipList.forEach({(model_3) in
                                                    self.nearItemImage.append(model_3.realcsUpload!.accesslocation)
                                                    self.nearItemName.append(model_3.equipName)
                                                    self.nearItemNum.append(model_3.number)
                                                    self.nearItemId.append(model_2.airdropId)
                                                    self.nearItemNo.append(model_3.equipNo)
                                                })
                                            })
                                        }
                                        if model_1.equipEntityList != nil && model_1.equipEntityList.count != 0 {  //包内物品
                                            model_1.equipEntityList.forEach({(model_2) in
                                                self.bagItemImage.append(model_2.realcsUpload!.accesslocation)
                                                self.bagItemName.append(model_2.equipName)
                                                self.bagItemNum.append(model_2.number)
                                                self.bagItemNo.append(model_2.equipNo)
                                            })
                                        }
                                        self.game?.dyingLabel?.text = "\(model_1.randang)"
                                        self.game?.bag?.myBlood?.text = "血量：\(model_1.blood)"
                                        self.game?.bag?.myArmor?.text = "护甲：\(model_1.defence)"
                                        self.game?.bag?.KillNum?.text = "击杀：\(model_1.killNum)"
                                        self.game?.bag?.Damage?.text = "伤害：\(model_1.damage)"
                                        if model_1.blood < self.LastBlood {
                                            self.game?.dyingImage?.isHidden = false
                                        }else{
                                            self.game?.dyingImage?.isHidden = true
                                        }
                                        self.LastBlood = model_1.blood
                                        self.game?.my?.Blood?.frame.size = CGSize(width: model_1.blood*205/100, height: 6)
                                        self.game?.my?.DyingBlood?.frame.size = CGSize(width: model_1.dyingBlood*205/100, height: 6)
                                        self.game?.my?.Armor?.frame.size = CGSize(width: model_1.defence*175/100, height: 6)
                                        UIView.animate(withDuration: 0.3, animations: {
                                            self.game?.my?.Blood_2?.frame.size = CGSize(width: model_1.blood*205/100, height: 6)
                                            self.game?.my?.DyingBlood_2?.frame.size = CGSize(width: model_1.dyingBlood*205/100, height: 6)
                                            self.game?.my?.Armor_2?.frame.size = CGSize(width: model_1.defence*175/100, height: 6)
                                        })
                                        self.MyStatus = model_1.status
                                        self.myStatus(sender: model_1.status)
                                        self.packageStatus(sender: model_1.connectStatus)
                                        self.isshield(sender: model_1.shieldFlag)
                                        if model_1.gpsEquipTypeList != nil {
                                            model_1.gpsEquipTypeList.forEach({ (model_3) in
                                                self.Equip[model_3.equipTypeId] = model_3
                                            })
                                            if self.Equip.keys.contains(2) {   //主武器
                                                if let url = URL(string: (self.Equip[2]?.accesslocation?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                    self.game?.GunView?.kf.setImage(with: url)
                                                }
                                                if self.Equip[2]?.equipNo != self.gunNO{
                                                    //                                                        playAudio(audioName: "music.mp3", isAlert: true, completion: nil)
                                                    if self.gunNO != nil {
                                                        stringSpeak(voiceString: "更换武器")
                                                    }
                                                    self.gunNO = self.Equip[2]?.equipNo
                                                }
                                            } else {
                                                self.game?.GunView?.image = UIImage(named: "gun.png")
                                            }
                                            if self.Equip.keys.contains(9) {   //头盔
                                                if let url = URL(string: (self.Equip[9]?.accesslocation?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                    self.game?.HatView?.kf.setImage(with: url)
                                                }
                                                if self.Equip[9]?.equipNo != self.hatNO{
                                                    //                                                        playAudio(audioName: "music.mp3", isAlert: true, completion: nil)
                                                    if self.hatNO != nil {
                                                        stringSpeak(voiceString: "更换头盔")
                                                    }
                                                    self.hatNO = self.Equip[9]?.equipNo
                                                }
                                            } else {
                                                self.game?.HatView?.image = UIImage(named: "hat.png")
                                            }
                                            if self.Equip.keys.contains(8) {   //背心
                                                if let url = URL(string: (self.Equip[8]?.accesslocation?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                    self.game?.ClothesView?.kf.setImage(with: url)
                                                }
                                                if self.Equip[8]?.equipNo != self.clothesNO{
                                                    //                                                        playAudio(audioName: "music.mp3", isAlert: true, completion: nil)
                                                    if self.clothesNO != nil {
                                                        stringSpeak(voiceString: "更换背心")
                                                    }
                                                    self.clothesNO = self.Equip[8]?.equipNo
                                                }
                                            } else {
                                                self.game?.ClothesView?.image = UIImage(named: "clothes.png")
                                            }
                                        }
                                    }
                                    self.TeamStatus.append(model_1.status)
                                })
                                self.freshData()
                                self.game?.bag?.nearTableView?.reloadData()
                                self.game?.bag?.bagTableView?.reloadData()
                                if self.gameRule == 1 {
                                    if !self.TeamStatus.contains(1) && !self.TeamStatus.contains(3) && responseModel.data?.status == 3 { //只包含2（死亡）
                                        self.game?.results?.isHidden = false
                                        if self.game?.results?.battleResultsView?.isHidden == true {
                                            self.game?.results?.ResultsView?.isHidden = false
                                        }else{
                                            self.game?.results?.ResultsView?.isHidden = true
                                        }
                                        self.results_stats = 1
                                        self.getResults()
                                    }else{
                                        self.game?.results?.isHidden = true
                                    }
                                }
                            }
                            //添加暴露人员
                            if responseModel.data?.exposePersonList != nil && responseModel.data?.exposePersonList.count != 0{
                                responseModel.data?.exposePersonList.forEach({(model_2) in
                                    if model_2.phoneStatus == 1{
                                        self.IconArray.append(model_2.realcsUpload!.accesslocation)
                                        self.LatArray.append(model_2.lat)
                                        self.LonArray.append(model_2.lon)
                                    }
                                })
                            }
                            //添加队友及暴露人员定位
                            for i in 0..<self.IconArray.count {
                                self.i = i
                                self.annotationArray.append(BMKPointAnnotation())
                                self.annotationArray[i].coordinate = CLLocationCoordinate2DMake(self.LatArray[i],self.LonArray[i])
                                self.game?.map?.mapView?.addAnnotation(self.annotationArray[i])
                            }
                        }
                    }
                }
            }else{
                self.game?.InternetLabel?.isHidden = false
                self.game?.GameStatus?.isHidden = true
            }
        }
    }
    //更新team数据
    func freshData(){
        if isContinue == true {
            if !websocket!.isConnected {
                websocket?.connect()
            }
        }
        if TeamdataSources.count > 0 {
            for i in 0..<TeamdataSources.count {
                TeamdataSources[i].TeamName = MyTeamName[i]
                TeamdataSources[i].TeamIcon = MyTeamIcon[i]
                TeamdataSources[i].TeamBlood = MyTeamBlood[i]
                TeamdataSources[i].TeamDyingBlood = MyTeamDyingBlood[i]
                TeamdataSources[i].TeamArmor = MyTeamArmor[i]
                TeamdataSources[i].TeamStatus = MyTeamStatus[i]
                TeamdataSources[i].TeamKill = MyTeamKill[i]
                TeamdataSources[i].TeamDamage = MyTeamDamage[i]
                TeamdataSources[i].myStatus = MyStatus!
            }
        }
    }
    //获取结算
    func getResults(){
        Alamofire.request("http://\(Host!):8080/apps/getPersonByRecord", method: .get, parameters: ["gameId": game_id!, "teamId": team_id!, "stats": results_stats!]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
//                    print(jsonString)
                    if let responseModel = ResultsModel.deserialize(from: jsonString) {
                        if responseModel.data != nil {
                            self.TeamDamage.removeAll()
                            self.TeamKill.removeAll()
                            self.TeamSurvival.removeAll()
                            self.TeamDead.removeAll()
                            responseModel.data?.recordList?.forEach({(model) in
                                self.TeamDamage.append(model.damage)
                                self.TeamKill.append(model.killNum)
                                self.TeamSurvival.append(model.survivalTime)
                                self.TeamDead.append(model.dieNum)
                                if model.personId == person_id {
                                    self.TeamRank = model.ranking
                                }
                            })
                            self.game?.results?.rank?.text = "第\(self.TeamRank!)名"
                            if self.TeamRank == 1 {
                                self.game?.results?.battleResultsView?.image = UIImage(named: "zhanbao_2.png")
                            }else{
                                self.game?.results?.battleResultsView?.image = UIImage(named: "zhanbao_1.png")
                            }
                            self.game?.results?.ResultsView?.isHidden = true
                            if self.gameRule == 1 {
                                self.game?.results?.survival?.isHidden = false
                                self.game?.results?.dead?.isHidden = true
                            }else if self.gameRule == 2 {
                                self.game?.results?.survival?.isHidden = true
                                self.game?.results?.dead?.isHidden = false
                            }
                            self.game?.results?.teamResultsTableView?.reloadData()
                            self.game?.results?.battleResultsView?.isHidden = false
                            self.game?.results?.ResultsView?.isHidden = true
                        } else {
                            let msg = self.stringValueDic(jsonString)
                            SVProgressHUD.showError(withStatus: "\((msg!["100001"])!)")
                        }
                    }
                }
            }
        }
    }
    
    @objc func heart(){
        clientSocket?.write(heartjsonData!, withTimeout: -1, tag: 0)
    }
    
    @objc func sendgps(){
        clientSocket?.write(gpsjsonData!, withTimeout: -1, tag: 0)
    }
    
    @objc func sendmsg(){
        clientSocket?.write(msgjsonData!, withTimeout: -1, tag: 0)
    }

    @objc func noti(n: Notification) {
        if game?.talkbtn?.SelectBtn?.tag == 0 || game?.talkbtn?.SelectBtn?.tag == 2{
            teamorworld = "team"
        }else if game?.talkbtn?.SelectBtn?.tag == 1{
            teamorworld = "world"
        }
        let name = n.object as! String
        if url != nil{ //判断是否有语音的路径
            if endState == 1 { //判断是否需要发送
                Alamofire.upload(multipartFormData: {(Formdata) in
                    Formdata.append(self.url!, withName: "file", fileName: name, mimeType: "caf")
                }, to: "http://\(Host!):8998/voice/uploadVoice", encodingCompletion: {(encodingResult) in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON(completionHandler: { (response) in
                            let str = String(data:response.data!, encoding: String.Encoding.utf8)!
                            if let responseModel = flagModel.deserialize(from: str){
                                self.caf = responseModel.data
                                self.cafstr = "{\"ACTION\":\"phone-send-msg\",\"DATA\":{\"PERSON_NAME\":\"\(self.MyName!)\",\"MSG_TYPE\":\"MSG_VOICE\",\"MSG_VOICE\":\"\(self.caf!)\",\"GAME_ID\":\(game_id!),\"PACKAGE_ID\":\"\(packageNo!)\",\"TEAM_ID\":\(team_id!),\"MSG_CHANNEL\":\"\(self.teamorworld!)\"},\"REQUEST_ID\":\"\(UIDevice.current.identifierForVendor!.uuidString)\"}\r\n"
                                self.msgjsonData = self.cafstr.data(using: String.Encoding.utf8, allowLossyConversion: false)
                                self.sendmsg()
                            }
                        })
                    case .failure(let error):
                        print(error)
                    }
                })
            }
        }else{
            SVProgressHUD.showError(withStatus: "发送失败")
        }
    }

    func startTime(){
        game?.StartLabel?.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    @objc func updateTime(){
        if num >= 1{
            game?.StartLabel?.text = "游戏将在\(num)秒后开始"
            num -= 1
        }else{
            stopTime()
            num = 5
        }
    }
    
    func stopTime() {
        if timer != nil {
            timer!.invalidate() //销毁timer
            timer = nil
            game?.StartLabel?.isHidden = true
        }
    }
    
    @objc func msgchange(sender: UIButton){
        if  game?.talkbtn?.SelectBtn?.isSelected == true{
            game?.talkbtn?.SelectBtn?.isSelected = false
        }
        sender.isSelected = true
        game?.talkbtn?.SelectBtn = sender
        game?.talk?.ScrollView?.contentOffset.x = CGFloat(sender.tag) * 150
        if sender.tag == 0{
            game?.talkbtn?.NewTip1?.isHidden = true
        }else if sender.tag == 1{
            game?.talkbtn?.NewTip2?.isHidden = true
        }else if sender.tag == 2{
            game?.talkbtn?.NewTip3?.isHidden = true
        }
        talknum = 10
        talkcloseOpen()
    }
    
    func msgchange2(sender: Int){
        if sender == 0{   //队伍
            game?.talkbtn?.Button1?.isSelected = true
            game?.talkbtn?.Button2?.isSelected = false
            game?.talkbtn?.Button3?.isSelected = false
            game?.talkbtn?.SelectBtn = game?.talkbtn?.Button1
        }else if sender == 1{  //世界
            game?.talkbtn?.Button1?.isSelected = false
            game?.talkbtn?.Button2?.isSelected = true
            game?.talkbtn?.Button3?.isSelected = false
            game?.talkbtn?.SelectBtn = game?.talkbtn?.Button2
        }else if sender == 2{  //系统
            game?.talkbtn?.Button1?.isSelected = false
            game?.talkbtn?.Button2?.isSelected = false
            game?.talkbtn?.Button3?.isSelected = true
            game?.talkbtn?.SelectBtn = game?.talkbtn?.Button3
        }
        game?.talk?.ScrollView?.contentOffset.x = CGFloat(sender * 150)
    }
    
    func isshield(sender: Int){
        if sender != 1{
            game?.shieldView?.isHidden = true
        } else {
            game?.shieldView?.isHidden = false
        }
    }
    
    func myStatus(sender: Int){
        if sender == 1 {  //正常
            game?.deadImage?.isHidden = true
            game?.my?.Blood?.isHidden = false
            game?.my?.Blood_2?.isHidden = false
            game?.my?.DyingBlood?.isHidden = true
            game?.my?.DyingBlood_2?.isHidden = true
            game?.dyingView?.isHidden = true
        }else if sender == 2 {  //死亡
            game?.deadImage?.isHidden = false
            game?.dyingView?.isHidden = true
            game?.dyingImage?.isHidden = true
        }else if sender == 3 {  //濒死
            game?.deadImage?.isHidden = true
            game?.my?.Blood?.isHidden = true
            game?.my?.Blood_2?.isHidden = true
            game?.my?.DyingBlood?.isHidden = false
            game?.my?.DyingBlood_2?.isHidden = false
            game?.dyingView?.isHidden = false
            game?.dyingImage?.isHidden = false
        }
    }
    
    func packageStatus(sender: Int){
        if sender == 1{
            game?.PackageView?.isHidden = true
        } else {
            game?.PackageView?.isHidden = false
        }
    }
    //webscoket相关协议
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket连接成功")
        DispatchQueue.main.async {
            self.game?.InternetLabel?.isHidden = true
            self.game?.GameStatus?.isHidden = false
        }
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        print("连接失败:\(String(describing: error))")
        print("websocket连接失败")
        DispatchQueue.main.async {
            self.game?.InternetLabel?.isHidden = false
            self.game?.GameStatus?.isHidden = true
        }
        if isContinue == true {
            if !websocket!.isConnected {
                websocket?.connect()
            }
        }
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("接收消息:\(text)")
        if let responseModel = flagModel.deserialize(from: text) {
            if responseModel.flag == nil {
                startgetData()
                MyTeamName.removeAll()
                MyTeamIcon.removeAll()
                MyTeamBlood.removeAll()
                MyTeamDyingBlood.removeAll()
                MyTeamArmor.removeAll()
                MyTeamStatus.removeAll()
                MyTeamPersonId.removeAll()
                TeamIcon.removeAll()
                TeamName.removeAll()
                Equip.removeAll()
                TeamdataSources.removeAll()
                if let responseModel = firstModel.deserialize(from: text) {
                    if responseModel.data?.status == 6 {
                        game?.GameStatus?.text = "游戏准备中"
                    }
                    else if responseModel.data?.status == 3 {
                        game?.GameStatus?.text = "游戏进行中"
                    }
                    else if responseModel.data?.status == 2 {
                        game?.GameStatus?.text = "游戏已结束"
                    }
                    else if responseModel.data?.status == 5 {
                        game?.GameStatus?.text = "游戏未开始"
                    }
                    if responseModel.data?.realcsGameMap?.mapPath != nil {
                        mapPath = responseModel.data?.realcsGameMap?.mapPath
                        //瓦片
//                        syncTile.maxZoom = 21
//                        syncTile.minZoom = 16
                        game?.map?.mapView?.add(syncTile)
                    }
                    if responseModel.data?.realcsGameMap?.centerLat != nil && responseModel.data?.realcsGameMap?.centerLon != nil {
                        centerLat = responseModel.data?.realcsGameMap?.centerLat
                        centerLon = responseModel.data?.realcsGameMap?.centerLon
                        center = CLLocationCoordinate2D(latitude: centerLat!, longitude: centerLon!)
                        //设置地图的显示范围（越小越精确）
                        let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        //设置地图最终显示区域
                        let region = BMKCoordinateRegion(center: center!, span: span)
                        game?.map?.mapView?.region = region
                        //设置显示天气状况
                        getWeather()
                    }
                    if responseModel.data?.realcsGameTeams != nil{
                        responseModel.data?.realcsGameTeams.forEach({ (model_1) in
                            if model_1.teamId == team_id{
                                model_1.realcsGamePersonList.forEach({ (model_2) in
                                    self.TeamIcon.append(model_2.realcsUpload!.accesslocation)
                                    self.TeamName.append(model_2.personName)
                                    if model_2.personId != person_id{  //队友
                                        self.MyTeamName.append(model_2.personName)
                                        self.MyTeamIcon.append(model_2.realcsUpload!.accesslocation)
                                        self.MyTeamPersonId.append(model_2.personId)
                                        self.MyTeamBlood.append(model_2.blood)
                                        self.MyTeamDyingBlood.append(model_2.dyingBlood)
                                        self.MyTeamArmor.append(model_2.defence)
                                        self.MyTeamStatus.append(model_2.status)
                                    }
                                    if model_2.personId == person_id{  //自己
                                        self.MyName = model_2.personName
                                        self.LastBlood = model_2.blood
                                        self.game?.my?.MyName?.text = model_2.personName
                                        self.game?.bag?.IconView?.kf.setImage(with: URL(string: model_2.realcsUpload!.accesslocation!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholder: UIImage(named: "logo.png"))
                                        self.game?.bag?.nickName?.text = model_2.personName
                                        self.game?.my?.Blood?.frame.size = CGSize(width: model_2.blood*230/100, height: 8)
                                        self.game?.my?.DyingBlood?.frame.size = CGSize(width: model_2.dyingBlood*230/100, height: 8)
                                        self.game?.my?.Armor?.frame.size = CGSize(width: model_2.defence*200/100, height: 8)
                                        UIView.animate(withDuration: 0.3, animations: {
                                            self.game?.my?.Blood_2?.frame.size = CGSize(width: model_2.blood*230/100, height: 8)
                                            self.game?.my?.DyingBlood_2?.frame.size = CGSize(width: model_2.dyingBlood*230/100, height: 8)
                                            self.game?.my?.Armor_2?.frame.size = CGSize(width: model_2.defence*200/100, height: 8)
                                        })
                                        self.MyStatus = model_2.status
                                        self.myStatus(sender: model_2.status)
                                        self.packageStatus(sender: model_2.connectStatus)
                                        self.isshield(sender: model_2.shieldFlag)
                                    }
                                })
                            }
                            MyTeamName.forEach({_ in
                                let model = TeamModel.init()
                                TeamdataSources.append(model)
                            })
                            if MyTeamName.count > 3 {
                                self.game?.TeamTableView?.isHidden = true
                                self.game?.TeamButton?.isHidden = false
                                self.game?.TeamCollectionView?.reloadData()
                            }else{
                                self.game?.TeamTableView?.reloadData()
                            }
                        })
                    }
                }
            }
            else if responseModel.flag == "开始游戏"{
                startgetData()
                startTime()
                game?.GameStatus?.text = "游戏进行中"
                //重新上传头像
                Alamofire.request("http://\(Host!):8080/apps/getHeadimgurl", method: .get, parameters: ["gameId": game_id!, "personId": person_id!, "headimgurl": headimgurl, "nickname": nickname])
            }
            else if responseModel.flag == "战报" {
                if self.game?.talkbtn?.SelectBtn?.tag != 2{
                    self.game?.talkbtn?.NewTip3?.isHidden = false
                }
                ReportArray.append(responseModel.data)
                game?.talk?.TableView3?.reloadData()
                msgchange2(sender: 2)
                talknum = 10
                talkcloseOpen()
            }
            else if responseModel.flag == "重载游戏" {
                game?.GameStatus?.text = "游戏未开始"
                ReportArray.removeAll()
                WorldUrlArray.removeAll()
                WorldVoiceName.removeAll()
                TeamUrlArray.removeAll()
                TeamVoiceName.removeAll()
                self.game?.talk?.TableView1?.reloadData()
                self.game?.talk?.TableView2?.reloadData()
                self.game?.talk?.TableView3?.reloadData()
                self.game?.talkbtn?.NewTip1?.isHidden = true
                self.game?.talkbtn?.NewTip2?.isHidden = true
                self.game?.talkbtn?.NewTip3?.isHidden = true
                self.game?.results?.isHidden = true
                self.gunNO = nil
                self.hatNO = nil
                self.clothesNO = nil
            }
            else if responseModel.flag == "准备游戏" {
                startgetData()
                game?.GameStatus?.text = "游戏准备中"
            }
            else if responseModel.flag == "游戏结束" {
                stopgetData()
                game?.GameStatus?.text = "游戏已结束"
                game?.map?.mapView?.removeAnnotation(PoisonAnnotation)
                game?.map?.mapView?.removeAnnotation(BombAnnotation)
                game?.map?.mapView?.remove(PoisonCircle_B)
                game?.map?.mapView?.remove(PoisonCircle_S)
                game?.map?.mapView?.remove(BombCircle)
                MyTeamBlood.removeAll()
                MyTeamDyingBlood.removeAll()
                MyTeamArmor.removeAll()
                MyTeamStatus.removeAll()
                Equip.removeAll()
                if let responseModel = firstModel.deserialize(from: text) {
                    let numString = NSMutableAttributedString(string: "剩余人数:"+"\(responseModel.data!.total)"+"/\(responseModel.data!.totalNum)")
                    let range: NSRange = (numString.string as NSString).range(of:"\(responseModel.data!.total)")
                    numString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 142/255, green: 184/255, blue: 200/255, alpha: 1), range: range)
                    self.game?.TotalNum?.attributedText = numString
                    if responseModel.data?.realcsGameTeams != nil{
                        responseModel.data?.realcsGameTeams.forEach({ (model_1) in
                            model_1.realcsGamePersonList.forEach({(model_2) in
                                self.MyTeamBlood.append(model_2.blood)
                                self.MyTeamDyingBlood.append(model_2.dyingBlood)
                                self.MyTeamArmor.append(model_2.defence)
                                self.MyTeamStatus.append(model_2.status)
                                if model_2.personId == person_id{  //自己
                                    self.game?.my?.Blood?.frame.size = CGSize(width: model_2.blood*205/100, height: 6)
                                    self.game?.my?.DyingBlood?.frame.size = CGSize(width: model_2.dyingBlood*205/100, height: 6)
                                    self.game?.my?.Armor?.frame.size = CGSize(width: model_2.defence*175/100, height: 6)
                                    UIView.animate(withDuration: 0.3, animations: {
                                        self.game?.my?.Blood_2?.frame.size = CGSize(width: model_2.blood*205/100, height: 6)
                                        self.game?.my?.DyingBlood_2?.frame.size = CGSize(width: model_2.dyingBlood*205/100, height: 6)
                                        self.game?.my?.Armor_2?.frame.size = CGSize(width: model_2.defence*175/100, height: 6)
                                    })
                                    self.MyStatus = model_2.status
                                    self.myStatus(sender: model_2.status)
                                    self.packageStatus(sender: model_2.connectStatus)
                                    self.isshield(sender: model_2.shieldFlag)
                                }
                            })
                        })
                        self.freshData()
                    }
                }
                SVProgressHUD.showInfo(withStatus: "游戏结束")
                self.game?.results?.isHidden = false
                self.game?.results?.battleResultsView?.isHidden = true
                self.game?.results?.ResultsView?.isHidden = false
                self.results_stats = 2
                self.getResults()
            }
        }
    }
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("接收数据:\(data)")
    }
    
    //socket相关协议
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) -> Void {
        DispatchQueue.main.async {
            self.game?.InternetLabel?.isHidden = true
            self.game?.GameStatus?.isHidden = false
        }
        print("socket连接成功")
        heartTimer!.fire()
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) -> Void {
        //        print("connect error: \(String(describing: err!))")
        DispatchQueue.main.async {
            self.game?.InternetLabel?.isHidden = false
            self.game?.GameStatus?.isHidden = true
        }
        print("socket连接失败")
        if isContinue == true {
            do{
                try sock.connect(toHost: Host!, onPort: 25409)
            }
            catch{
            }
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) -> Void {
        // 1、获取服务端发来的数据，把 NSData 转 NSString
        //        let readClientDataString: NSString? = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        //服务端数据GBK编码，转String
        let readClientDataString: String? = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))))
        //        print(readClientDataString!)
        if let responseModel = SocketModel.deserialize(from: readClientDataString) {
            if responseModel.ACTION == "phone-receive-msg" { //判断是心跳还是其他回复
                if responseModel.DATA?.MSG_TYPE == "MSG_VOICE" { //判断是否是语音
                    if responseModel.DATA?.MSG_CHANNEL == "team"{ //队伍语音
                        TeamVoiceName.append(responseModel.DATA!.PERSON_NAME)
                        TeamUrlArray.append(URL(string: responseModel.DATA!.MSG_VOICE)!)
                        //主线程刷新tableview以及显示小红点
                        DispatchQueue.main.async {
                            if self.game?.talkbtn?.SelectBtn?.tag != 0{
                                self.game?.talkbtn?.NewTip1?.isHidden = false
                            }
                            self.game?.talk?.TableView1?.reloadData()
                            self.talknum = 10
                            self.talkcloseOpen()
                            self.msgchange2(sender: 0)
                        }
                    }else if responseModel.DATA?.MSG_CHANNEL == "world"{ //世界语音
                        WorldVoiceName.append(responseModel.DATA!.PERSON_NAME)
                        WorldUrlArray.append(URL(string: responseModel.DATA!.MSG_VOICE)!)
                        DispatchQueue.main.async {
                            if self.game?.talkbtn?.SelectBtn?.tag != 1{
                                self.game?.talkbtn?.NewTip2?.isHidden = false
                            }
                            self.game?.talk?.TableView2?.reloadData()
                            self.talknum = 10
                            self.talkcloseOpen()
                            self.msgchange2(sender: 1)
                        }
                    }
                }
                else if responseModel.DATA?.MSG_TYPE == "MSG_TXT" { //判断是否是干预信息
                    SVProgressHUD.showInfo(withStatus: "\((responseModel.DATA?.MSG_TXT)!)")
                }
            }
        }
        
        // 2、每次读完数据后，都要调用一次监听数据的方法
        sock.readData(withTimeout: -1, tag: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(game?.TeamTableView){
            return MyTeamName.count
        }
        else if tableView.isEqual(game?.talk?.TableView1) {
            return TeamVoiceName.count
        }
        else if tableView.isEqual(game?.talk?.TableView2) {
            return WorldVoiceName.count
        }
        else if tableView.isEqual(game?.talk?.TableView3) {
            return ReportArray.count
        }
        else if tableView.isEqual(game?.bag?.bagTableView) {
            return bagItemImage.count
        }
        else if tableView.isEqual(game?.bag?.nearTableView) {
            return nearItemImage.count
        }
        else if tableView.isEqual(game?.results?.teamResultsTableView) {
            return TeamName.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEqual(game?.TeamTableView){
            return 50
        }
        else if tableView.isEqual(game?.talk?.TableView1) {
            return 30
        }
        else if tableView.isEqual(game?.talk?.TableView2) {
            return 30
        }
        else if tableView.isEqual(game?.talk?.TableView3) {
            return 30
        }
        else if tableView.isEqual(game?.bag?.bagTableView) {
            return 60
        }
        else if tableView.isEqual(game?.bag?.nearTableView) {
            return 60
        }
        else if tableView.isEqual(game?.results?.teamResultsTableView) {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        if tableView.isEqual(game?.TeamTableView){
            var cell : TeamTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell") as? TeamTableViewCell
            if cell == nil {
                cell = TeamTableViewCell(style: .default, reuseIdentifier: "TeamTableViewCell")
            }
            if let cell = cell {
                cell.model = TeamdataSources[indexPath.row]
            }
            cell.saveButton?.tag = indexPath.row
            cell.saveButton?.addTarget(self, action: #selector(openSave(sender:)), for: .touchUpInside)
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.talk?.TableView1){
            var cell : GameTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell1") as? GameTableViewCell1
            if cell == nil {
                cell = GameTableViewCell1(style: .default, reuseIdentifier: "GameTableViewCell1")
            }
            cell.NameLabel?.text = TeamVoiceName[indexPath.row].removingPercentEncoding
            cell.SpeechView?.delegate = self
            btn = cell.SpeechView

            weak var weakSelf = self
            weakSelf?.btn.contentURL = TeamUrlArray[indexPath.row]
            weakSelf?.btn.isUserInteractionEnabled = true

            cell.SpeechView = btn
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.talk?.TableView2){
            var cell : GameTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell1") as? GameTableViewCell1
            if cell == nil {
                cell = GameTableViewCell1(style: .default, reuseIdentifier: "GameTableViewCell1")
            }
            cell.NameLabel?.text = WorldVoiceName[indexPath.row].removingPercentEncoding
            cell.SpeechView?.delegate = self
            btn = cell.SpeechView

            weak var weakSelf = self
            weakSelf?.btn.contentURL = WorldUrlArray[indexPath.row]
            weakSelf?.btn.isUserInteractionEnabled = true

            cell.SpeechView = btn
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.talk?.TableView3){
            var cell : GameTableViewCell2! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell2") as? GameTableViewCell2
            if cell == nil {
                cell = GameTableViewCell2(style: .default, reuseIdentifier: "GameTableViewCell2")
            }
            cell.ReportLabel?.text = ReportArray[indexPath.row]
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.bag?.bagTableView) {
            var cell : BagTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "BagTableViewCell") as? BagTableViewCell
            if cell == nil {
                cell = BagTableViewCell(style: .default, reuseIdentifier: "BagTableViewCell")
            }
            cell.itemImage?.kf.setImage(with: URL(string: bagItemImage[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
            cell.itemName?.text = bagItemName[indexPath.row]
            cell.itemNum?.text = "X\(bagItemNum[indexPath.row])"
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.bag?.nearTableView) {
            var cell : NearTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "NearTableViewCell") as? NearTableViewCell
            if cell == nil {
                cell = NearTableViewCell(style: .default, reuseIdentifier: "NearTableViewCell")
            }
            cell.itemImage?.kf.setImage(with: URL(string: nearItemImage[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
            cell.itemName?.text = nearItemName[indexPath.row]
            cell.itemNum?.text = "X\(nearItemNum[indexPath.row])"
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        else if tableView.isEqual(game?.results?.teamResultsTableView) {
            var cell : battleResultsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "battleResultsTableViewCell") as? battleResultsTableViewCell
            if cell == nil {
                cell = battleResultsTableViewCell(style: .default, reuseIdentifier: "battleResultsTableViewCell")
            }
            cell.Icon?.kf.setImage(with: URL(string: TeamIcon[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!))
            cell.Name?.text = TeamName[indexPath.row]
            cell.Damage?.text = "\(TeamDamage[indexPath.row])"
            cell.Kill?.text = "\(TeamKill[indexPath.row])"
            if gameRule == 1 {
                cell.Survival?.isHidden = false
                cell.dead?.isHidden = true
            } else if gameRule == 2 {
                cell.Survival?.isHidden = true
                cell.dead?.isHidden = false
            }
            self.TeamSurvival_h = Int(floor(Double(self.TeamSurvival[indexPath.row]/3600000)))
            self.TeamSurvival_m = Int(floor(Double((self.TeamSurvival[indexPath.row]%3600000)/60000)))
            self.TeamSurvival_s = ((self.TeamSurvival[indexPath.row]%3600000)%60000)/1000
            cell.Survival?.text = String(format:"%02d",self.TeamSurvival_h!)+":"+String(format:"%02d",self.TeamSurvival_m!)+":"+String(format:"%02d",self.TeamSurvival_s!)
            cell.dead?.text = "\(TeamDead[indexPath.row])"
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        hiddenBtn()
        if tableView.isEqual(game?.bag?.bagTableView){
            //设置当前所选cell
//            let cell = tableView.cellForRow(at: indexPath) as? BagTableViewCell
//            cell?.useButton?.isHidden = false
//            cell?.dropButton?.isHidden = false
            game?.operation?.isHidden = false
            ItemRow = indexPath.row
//            let alertView = UIAlertController(title: "操作道具", message: "", preferredStyle: .alert)
//            let action_1 = UIAlertAction(title: "使用", style: .default ,handler: { (UIAlertAction) -> Void in
//                self.useItem(sender: indexPath.row)
//            })
//            alertView.addAction(action_1)
//            let action_2 = UIAlertAction(title: "丢弃", style: .default ,handler: { (UIAlertAction) -> Void in
//                self.dropItem(sender: indexPath.row)
//            })
//            alertView.addAction(action_2)
//            let action_3 = UIAlertAction(title: "取消", style: .default ,handler: { (UIAlertAction) -> Void in
//            })
//            alertView.addAction(action_3)
//            self.present(alertView, animated: true, completion: nil)
        }
        else if tableView.isEqual(game?.bag?.nearTableView){
            let NoStr = nearItemNo[indexPath.row].joined(separator: ",")
            Alamofire.request("http://\(Host!):8080/apps/addEquip", method: .get, parameters: ["gameId": game_id!, "personId": person_id!, "airdropId": nearItemId[indexPath.row], "equipNos": NoStr]).responseString { (response) in
                if response.result.isSuccess {
                    if let jsonString = response.result.value {
//                        print(jsonString)
                        let msg = self.stringValueDic(jsonString)
                        if (msg?.keys.contains("100001"))!{
                            SVProgressHUD.showError(withStatus: "\((msg!["100001"])!)")
                        }
//                        else if (msg?.keys.contains("200"))!{
//                            SVProgressHUD.showSuccess(withStatus: "\((msg!["200"])!)")
//                        }
                    }
                }
            }
        }else if tableView.isEqual(game?.TeamTableView) {
            let cell = tableView.cellForRow(at: indexPath) as? TeamTableViewCell
            if cell?.TeamIconView?.isHidden == true {
                cell?.TeamIconView?.isHidden = false
                cell?.TeamView?.frame.origin.x = 34
                cell?.saveButton?.frame.origin.x = 209
                cell?.TeamKillView?.isHidden = false
                cell?.TeamDamageView?.isHidden = false
            }else{
                cell?.TeamIconView?.isHidden = true
                cell?.TeamView?.frame.origin.x = 0
                cell?.saveButton?.frame.origin.x = 175
                cell?.TeamKillView?.isHidden = true
                cell?.TeamDamageView?.isHidden = true
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyTeamName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : GameCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! GameCollectionViewCell
        cell.model = TeamdataSources[indexPath.item]
        cell.saveButton?.tag = indexPath.item
        cell.saveButton?.addTarget(self, action: #selector(openSave(sender:)), for: .touchUpInside)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    //语音工具必须实现的协议
    func voiceBubbleStratOrStop(_ voiceBubble: ZFJVoiceBubble, _ isStart: Bool) {
        //        NSLog("voiceBubbleStratOrStop")
    }
    
    func voiceBubbleDidStartPlaying(_ voiceBubble: ZFJVoiceBubble) {
        //        NSLog("voiceBubbleDidStartPlaying")
    }
    
    //gps
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        let currLocation:CLLocation = locations.last!
        MyLon = currLocation.coordinate.longitude
        MyLat = currLocation.coordinate.latitude
        //坐标转换
        let coodinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(MyLat!, MyLon!)
        let srctype = BMKLocationCoordinateType.WGS84    //原始坐标系
//        let srctype = BMKLocationCoordinateType.GCJ02    //火星坐标系
        let destype = BMKLocationCoordinateType.BMK09LL  //百度坐标系
        let cood: CLLocationCoordinate2D = BMKLocationManager.bmkLocationCoordinateConvert(coodinate, srcType: srctype, desType: destype)
        MyLon = cood.longitude
        MyLat = cood.latitude
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        gpsstr = "{\"lon\":\(MyLon!),\"gpsType\":\"phone\",\"time\":\(timeStamp),\"hdop\":\(currLocation.horizontalAccuracy),\"devid\":\"\(packageNo!)\",\"lat_type\":\"N\",\"height\":\(currLocation.altitude),\"state\":1,\"stars\":0,\"lon_type\":\"E\",\"locationTime\":0,\"direction\":\(currLocation.course),\"appType\":0,\"gameid\":\(game_id!),\"height_unit\":\"M\",\"lat\":\(MyLat!)}\r\n"
        gpsjsonData = gpsstr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        _ = onecode
//        //获取经度
//        print("经度：\(currLocation.coordinate.longitude)")
//        //获取纬度
//        print("纬度：\(currLocation.coordinate.latitude)")
//        //获取海拔
//        print("海拔：\(currLocation.altitude)")
//        //获取水平精度
//        print("水平精度：\(currLocation.horizontalAccuracy)")
//        //获取垂直精度
//        print("垂直精度：\(currLocation.verticalAccuracy)")
//        //获取方向
//        print("方向：\(currLocation.course)")
//        //获取速度
//        print("速度：\(currLocation.speed)")
    }
    
    func mapView(_ mapView: BMKMapView, viewFor annotation: BMKAnnotation) -> BMKAnnotationView? {
        if (annotation is BMKPointAnnotation) {
            if annotationArray.count > 0 {
                if annotation.isEqual(annotationArray[i]){
                    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationArray")
                    if annotationView == nil {
                        annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "annotationArray")
                    }
                    if ImageCache.default.isCached(forKey: IconArray[i]) == false {
                        var image : UIImage? = nil
                        do{
                            image = UIImage(data: try Data(contentsOf: URL(string: IconArray[i])!))
                            ImageCache.default.store(image!, forKey: IconArray[i])
                            annotationView?.image = ImageCache.default.retrieveImageInDiskCache(forKey: IconArray[i])
                        }catch{
                        }
                    }else{
                        annotationView?.image = ImageCache.default.retrieveImageInDiskCache(forKey: IconArray[i])
                    }
                    annotationView?.frame.size = CGSize(width: 20, height: 20)
                    annotationView?.layer.cornerRadius = (annotationView?.frame.width)!/2
                    annotationView?.layer.masksToBounds = true
                    return annotationView
                }
            }
            if airdropArray.count > 0{
                if annotation.isEqual(airdropArray[j]){
                    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "airdropArray")
                    if annotationView == nil {
                        annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "airdropArray")
                    }
                    if airdrop![j].status == 1{
                       annotationView?.image = UIImage(named: "kongtou.png")
                    }else if airdrop![j].status == 2{
                        annotationView?.image = UIImage(named: "wuzi.png")
                    }
                    return annotationView
                }
            }
            if annotation.isEqual(PoisonAnnotation){
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PoisonAnnotation")
                if annotationView == nil {
                    annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "PoisonAnnotation")
                }
                annotationView?.image = UIImage(named: "none.png")
                game?.Poisontitle?.text = annotation.title?()
                annotationView?.addSubview((game?.Poisontitle)!)
                return annotationView
            }else if annotation.isEqual(BombAnnotation){
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BombAnnotation")
                if annotationView == nil {
                    annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "BombAnnotation")
                }
                annotationView?.image = UIImage(named: "none.png")
                game?.Bombtitle?.text = annotation.title?()
                annotationView?.addSubview((game?.Bombtitle)!)
                return annotationView
            }
        }
        return nil
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        if (overlay is BMKCircle) {
            let circleView = BMKCircleView(overlay: overlay)
            if overlay.isEqual(BombCircle){
                circleView?.strokeColor = UIColor.red
                circleView?.fillColor = UIColor.red.withAlphaComponent(0.5)
            }
            else if overlay.isEqual(PoisonCircle_B){
                circleView?.strokeColor = UIColor.red
                circleView?.lineWidth = 1
            }
            else if overlay.isEqual(PoisonCircle_S){
                circleView?.strokeColor = UIColor.blue
                circleView?.lineWidth = 1
            }
            return circleView
        }
        if (overlay is BMKTileLayer) {
            let view = BMKTileLayerView(tileLayer: overlay as? BMKTileLayer)
            return view
        }
        return nil
    }
    
    
    //MARK:BMKLocationManagerDelegate
    /**
     @brief 该方法为BMKLocationManager提供设备朝向的回调方法
     @param manager 提供该定位结果的BMKLocationManager类的实例
     @param heading 设备的朝向结果
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        //        NSLog("用户方向更新")
        userLocation.heading = heading
        game?.map?.mapView?.updateLocationData(userLocation)
    }
    
    /**
     @brief 连续定位回调函数
     @param manager 定位 BMKLocationManager 类
     @param location 定位结果，参考BMKLocation
     @param error 错误信息。
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if let _ = error?.localizedDescription {
            NSLog("locError:%@;", (error?.localizedDescription)!)
        }
        userLocation.location = location?.location
        //实现该方法，否则定位图标不出现
        game?.map?.mapView?.updateLocationData(userLocation)
    }
    
    /**
     @brief 当定位发生错误时，会调用代理的此方法
     @param manager 定位 BMKLocationManager 类
     @param error 返回的错误，参考 CLError
     */
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        NSLog("定位失败")
    }
    
    //image旋转任意角度
//    func getRotationImage(_ image: UIImage?, rotation: CGFloat, point: CGPoint) -> UIImage? {
//        let num = Int(floor(rotation))
//        if CGFloat(num) == rotation && num % 360 == 0 {
//            return image
//        }
//        let radius = Double(rotation * .pi / 180)
//
//        let rotatedSize: CGSize? = image?.size
//        // Create the bitmap context
//        UIGraphicsBeginImageContext(rotatedSize!)
//        let bitmap = UIGraphicsGetCurrentContext()
//
//        // rotated image view
//        bitmap?.scaleBy(x: 1.0, y: -1.0)
//
//        // move to the rotation relative point
//        bitmap?.translateBy(x: point.x, y: -point.y)
//
//        // Rotate the image context
//        bitmap?.rotate(by: CGFloat(radius))
//
//        // Now, draw the rotated/scaled image into the context
//        bitmap?.draw((image?.cgImage)!, in: CGRect(x: -point.x, y: -(image?.size.height)! + point.y, width: (image?.size.width)!, height: (image?.size.height)!))
//
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
    
    // MARK: 字符串转字典
    func stringValueDic(_ str: String) -> [String : Any]?{
        let data = str.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
    
    //点击空白隐藏
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if game?.TeamView?.isHidden == false{
//            game?.TeamView?.isHidden = true
//        }
//        if game?.BagView?.isHidden == false{
//            game?.BagView?.isHidden = true
//        }
//        if game?.saveBg?.isHidden == false{
//            game?.saveBg?.isHidden = true
//        }
//    }
    //点击地图隐藏
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            game?.TeamView?.isHidden = true
            game?.bag?.isHidden = true
            game?.SaveView?.isHidden = true
            hiddenOperation()
            SVProgressHUD.dismiss()
        }
        sender.cancelsTouchesInView = false
    }
    //点击背包隐藏
    @objc func handleTap_2(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            hiddenOperation()
            SVProgressHUD.dismiss()
        }
        sender.cancelsTouchesInView = false
    }
    //获取天气
    func getWeather(){
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather", method: .get, parameters: ["lat": "\(centerLat!)", "lon": "\(centerLon!)", "appid": "12b2817fbec86915a6e9b4dbbd3d9036"]).responseString { (response) in
            if response.result.isSuccess {
                if let jsonString = response.result.value {
                    if let responseModel = weatherModel.deserialize(from: jsonString) {
                        if responseModel.cod == 200 {
                            self.weatherMain = responseModel.weather[0].main
                            self.weatherDescription = responseModel.weather[0].description
                            self.chooseWeather()
                        }
                    }
                }
            }
        }
    }
    //选择天气类型
    func chooseWeather(){
        if weatherMain == "Clear" {
            weather = WHWeatherType.sun
        }else if weatherMain == "Clouds" {
            weather = WHWeatherType.clound
        }else if weatherMain == "Rain" {
            if weatherDescription == "light rain" || weatherDescription == "light intensity shower rain"{
                weather = WHWeatherType.rainLighting
            }else{
                weather = WHWeatherType.rain
            }
        }else if weatherMain == "Snow" {
            weather = WHWeatherType.snow
        }else{
            weather = WHWeatherType.other
        }
        game?.weatherView?.showWeatherAnimation(with: weather!)
    }
    //检测网络状况
//    func currentNetReachability() {
//        let manager = NetworkReachabilityManager()
//        manager?.listener = { status in
//            var statusStr: String?
//            switch status {
//            case .unknown:
//                statusStr = "未识别的网络"
//                break
//            case .notReachable:
//                statusStr = "网络未连接"
//                SVProgressHUD.showInfo(withStatus: statusStr)
//                break
//            case .reachable:
//                if (manager?.isReachableOnWWAN)! {
//                    statusStr = "移动的网络"
//                } else if (manager?.isReachableOnEthernetOrWiFi)! {
//                    statusStr = "wifi的网络";
//                }
//                break
//            }
//        }
//        manager?.startListening()
//    }

}
