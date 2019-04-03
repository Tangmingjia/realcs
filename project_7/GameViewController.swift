import UIKit
import WebKit
import Starscream
import CoreBluetooth
import CoreLocation
import Kingfisher

class GameViewController: UIViewController,WKUIDelegate,WKNavigationDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WebSocketDelegate,ZFJVoiceBubbleDelegate,CLLocationManagerDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,GCDAsyncSocketDelegate{
    var btn : ZFJVoiceBubble!
    var team_id : Int = 0
    var game_id : Int = 0
    var person_id : Int = 0
    var packageNo : String!
    let cache = ImageCache.default
//    let serverPort:UInt16 = 25409
//    var clientSocket:GCDAsyncSocket!
//    var mainQueue = DispatchQueue.main
//    var msgView: UITextView!
    let gps = CLLocationManager()
    var websocket : WebSocket?
    var Hat : String = ""
    var Clothes : String = ""
    var Gun : String = ""
    var HandGun : String = ""
    var Weapon : String = ""
    var MyBlood : Int = 0
    var MyDyingBlood : Int = 0
    var MyArmor : Int = 0
    var MyStatus : Int = 0
    var MyIcon : String?
    var Mylat : CLLocationDegrees?
    var Mylon : CLLocationDegrees?
    var connectStatus : Int = 0
    var ReportArray : Array = [String]()
    var Equip : Dictionary = [Int? : String]()
    var centerLat: CGFloat = 0.0
    var centerLon: CGFloat = 0.0
    var center : CLLocationCoordinate2D?
    var i = 0
//    var MyTeam : Array = [RealcsGamePersonListItem()]
    var annotationArray = [BMKPointAnnotation()]
    var LonArray : Array = [CLLocationDegrees]()
    var LatArray : Array = [CLLocationDegrees]()
    var IconArray : Array = [String]()
    var TeamIcon : Array = [String]()
    var TeamName : Array = [String]()
    var TeamPersonId : Array = [Int]()
    var TeamStatus : Array = [Int]()
    var TeamBoold : Array = [Int]()
    var TeamDyingBoold : Array = [Int]()
    var TeamArmor  : Array = [Int]()
    var num = 5
    var timer : Timer?
    var bombCenter : Array = [String]()
    var Bomb = RealcsGameCircleBomb()
    var BombCircle : BMKCircle?
    var BombCenter : CLLocationCoordinate2D?
    var BombRadius : CLLocationDistance?
    var bCenter : Array = [String]()
    var sCenter : Array = [String]()
    var Poison = RealcsGameCirclePoison()
    var PoisonCircle_B : BMKCircle?
    var PoisonCenter_B : CLLocationCoordinate2D?
    var PoisonRadius_B : CLLocationDistance?
    var PoisonCircle_S : BMKCircle?
    var PoisonCenter_S : CLLocationCoordinate2D?
    var PoisonRadius_S : CLLocationDistance?
    var CircleBomb = RealcsGameCircleBomb()
    var CirclePoison = RealcsGameCirclePoison()
    var Num1 : Int = 0
    var Num2 : Int = 0
    var UrlArray : Array = [URL]()
    var game : GameView?
    var location : BMKPointAnnotation?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(noti(n:)), name: NSNotification.Name("noti"), object: nil)
        
        //gps
        gps.delegate = self
        gps.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        gps.distanceFilter = 1
        gps.requestAlwaysAuthorization()
        gps.requestWhenInUseAuthorization()
        gps.startUpdatingLocation()
        
        //webscoket
        websocket = WebSocket(url: URL(string: "http://\(Host().Host):8998/websocket/\(self.game_id)/0/\(self.team_id)")!)
        websocket!.delegate = self
        websocket!.connect()
        
        //scoket
//        do {
//            clientSocket = GCDAsyncSocket()
//            clientSocket.delegate = self
//            clientSocket.delegateQueue = DispatchQueue.global()
//            try clientSocket.connect(toHost: "\(Host().IP)", onPort: serverPort)
//            }
//        catch {
//            print("error")
//            }

        game = GameView()
        game?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.view.addSubview(game!)
        
        game?.mapView?.delegate = self
        game?.button1?.addTarget(self, action: #selector(change2(sender:)), for: .touchUpInside)
        game?.button2?.addTarget(self, action: #selector(change2(sender:)), for: .touchUpInside)
        game?.Button1?.addTarget(self, action: #selector(change(sender:)), for: .touchUpInside)
        game?.Button2?.addTarget(self, action: #selector(change(sender:)), for: .touchUpInside)
        game?.Button3?.addTarget(self, action: #selector(change(sender:)), for: .touchUpInside)
        game?.LocationBtn?.addTarget(self, action: #selector(reload), for: .touchUpInside)
        game?.TeamCollection?.register(GameCollectionViewCell.self, forCellWithReuseIdentifier: "GameCollectionViewCell")
        game?.TeamCollection?.delegate = self
        game?.TeamCollection?.dataSource = self
        game?.TableView1?.delegate = self
        game?.TableView1?.dataSource = self
        game?.TableView2?.delegate = self
        game?.TableView2?.dataSource = self
        game?.TableView3?.delegate = self
        game?.TableView3?.dataSource = self
        game?.Speech?.sendURLAction = {(_ voiceUrl: URL) -> Void in
            let url = URL(fileURLWithPath: voiceUrl.absoluteString)
            self.UrlArray.append(url)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        game?.mapView?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        btn.stop()
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        game?.mapView?.viewWillDisappear()
        websocket?.disconnect()
//        //清理内存缓存
//        cache.clearMemoryCache()
//
//        // 清理硬盘缓存，这是一个异步的操作
//        cache.clearDiskCache()
//
//        // 清理过期或大小超过磁盘限制缓存。这是一个异步的操作
//        cache.cleanExpiredDiskCache()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        websocket!.disconnect(forceTimeout: 0)
        websocket!.delegate = nil
    }
    
    @objc func noti(n: Notification) {
        if UrlArray.count > 0 {
            if game?.SelectBtn?.tag == 0{
                Num1 += 1
                game?.TableView1?.reloadData()
            }
            else if game?.SelectBtn?.tag == 1{
                Num2 += 1
                game?.TableView2?.reloadData()
            }
        }
    }
    
    @objc func reload(){
        let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = BMKCoordinateRegion(center: center!, span: span)
        game?.mapView?.region = region
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
            num = 0
        }
    }
    
    func stopTime() {
        if timer != nil {
            timer!.invalidate() //销毁timer
            timer = nil
            game?.StartLabel?.isHidden = true
        }
    }
    
    @objc func change(sender: UIButton){
        if  game?.SelectBtn?.isSelected == true{
            game?.SelectBtn?.isSelected = false
        }
        sender.isSelected = true
        game?.SelectBtn = sender
        game?.ScrollView?.contentOffset.x = CGFloat(sender.tag) * 150
    }
    
    @objc func change2(sender: UIButton){
        if  game?.selector?.isSelected == true{
            game?.selector?.isSelected = false
        }
        sender.isSelected = true
        game?.selector = sender
        if game?.button1?.isSelected == true {
            game?.mapView?.mapType = .standard
        }else{
            game?.mapView?.mapType = .satellite
        }
    }
    
    func ButtonStatus(sender: Int) -> Bool{
        switch sender {
        case 0:
            return false
        default:
            return true
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
//        print("连接成功")
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
//        print("连接失败:\(String(describing: error))")
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("接收消息:\(text)")
        if let responseModel = Model_3.deserialize(from: text) {
            if responseModel.flag == nil {
                TeamIcon.removeAll()
                TeamName.removeAll()
                TeamPersonId.removeAll()
                TeamStatus.removeAll()
                TeamBoold.removeAll()
                TeamDyingBoold.removeAll()
                TeamArmor.removeAll()
                Equip.removeAll()
                IconArray.removeAll()
                LatArray.removeAll()
                LonArray.removeAll()
                game?.mapView?.removeAnnotations(annotationArray)
                annotationArray.removeAll()
                if let responseModel = Model_2.deserialize(from: text) {
                    centerLat = (responseModel.data?.realcsGameMap!.centerLat)!
                    centerLon = (responseModel.data?.realcsGameMap!.centerLon)!
                    center = CLLocationCoordinate2D(latitude: CLLocationDegrees(centerLat), longitude: CLLocationDegrees(centerLon))
                    //设置地图的显示范围（越小越精确）
                    let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    //设置地图最终显示区域
                    let region = BMKCoordinateRegion(center: center!, span: span)
                    game?.mapView?.region = region
                    if responseModel.data?.realcsGameTeams != nil{
                        responseModel.data?.realcsGameTeams.forEach({ (model_1) in
                            if model_1.teamId == team_id{
                                model_1.realcsGamePersonList.forEach({ (model_2) in
                                    if model_2.personId == person_id {
                                        MyIcon = model_2.realcsUpload?.accesslocation
                                    }
                                    self.IconArray.append(model_2.realcsUpload!.accesslocation)
                                    self.LatArray.append(CLLocationDegrees(model_2.lat))
                                    self.LonArray.append(CLLocationDegrees(model_2.lon))
                                    self.TeamIcon.append(model_2.realcsUpload!.accesslocation)
                                    self.TeamName.append(model_2.personName)
                                    self.TeamPersonId.append(model_2.personId)
                                    self.TeamStatus.append(model_2.status)
                                    self.TeamBoold.append(model_2.blood)
                                    self.TeamDyingBoold.append(model_2.dyingBlood)
                                    self.TeamArmor.append(model_2.defence)
                                })
                            }
                            self.game?.TeamCollection?.reloadData()
                        })
                    }
                    for i in 0..<IconArray.count {
                        self.i = i
                        annotationArray.append(BMKPointAnnotation())
                        annotationArray[i].coordinate = CLLocationCoordinate2DMake(LatArray[i],LonArray[i])
                        game?.mapView?.addAnnotation(annotationArray[i])
                    }
                }
            }
            if responseModel.flag == "游戏"{
                TeamStatus.removeAll()
                TeamBoold.removeAll()
                TeamDyingBoold.removeAll()
                TeamArmor.removeAll()
                IconArray.removeAll()
                LatArray.removeAll()
                LonArray.removeAll()
                game?.mapView?.removeAnnotations(annotationArray)
                annotationArray.removeAll()
                if let responseModel = Model_2.deserialize(from: text) {
                    game?.TotalNum?.text = "剩余 \(responseModel.data!.total) 人"
                    if responseModel.data?.status == 6 {
                        game?.GameStatus?.text = "游戏准备中"
                    }
                    else if responseModel.data?.status == 3 {
                        game?.GameStatus?.text = "游戏进行中"
                    }
                    if responseModel.data?.realcsGameCircleBomb != nil {   //轰炸区
                        game?.mapView?.remove(BombCircle)
                        if responseModel.data?.realcsGameCircleBomb?.status == 0 {  //轰炸倒计时
                            Bomb = responseModel.data!.realcsGameCircleBomb!
                            bombCenter = (responseModel.data?.realcsGameCircleBomb?.center.components(separatedBy: ","))!
                            BombCenter = CLLocationCoordinate2D(latitude: (CLLocationDegrees(bombCenter[1]))!, longitude: (CLLocationDegrees(bombCenter[0]))!)
                            BombRadius = CLLocationDistance(Bomb.radius)
                            BombCircle = BMKCircle(center: BombCenter!, radius: BombRadius!)
                            game?.mapView?.add(BombCircle)
                        }
                        else if responseModel.data?.realcsGameCircleBomb?.status == 2 {  //轰炸开始
                            Bomb = responseModel.data!.realcsGameCircleBomb!
                            bombCenter = (responseModel.data?.realcsGameCircleBomb?.center.components(separatedBy: ","))!
                            BombCenter = CLLocationCoordinate2D(latitude: (CLLocationDegrees(bombCenter[1]))!, longitude: (CLLocationDegrees(bombCenter[0]))!)
                            BombRadius = CLLocationDistance(Bomb.radius)
                            BombCircle = BMKCircle(center: BombCenter!, radius: BombRadius!)
                            game?.mapView?.add(BombCircle)
                        }
                        else if responseModel.data?.realcsGameCircleBomb?.status == 1 {  //轰炸结束
                            game?.mapView?.remove(BombCircle)
                        }
                    }
                    if responseModel.data?.realcsGameCirclePoison != nil{  //毒区
                        game?.mapView?.remove(PoisonCircle_B)
                        game?.mapView?.remove(PoisonCircle_S)
                        if responseModel.data?.realcsGameCirclePoison?.status == 1{   //毒圈倒计时
                            Poison = responseModel.data!.realcsGameCirclePoison!
                            bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                            PoisonCenter_B = CLLocationCoordinate2D(latitude: (CLLocationDegrees(bCenter[1]))!, longitude: (CLLocationDegrees(bCenter[0]))!)
                            PoisonRadius_B = CLLocationDistance(Poison.radius)
                            PoisonCircle_B = BMKCircle(center: PoisonCenter_B!, radius: PoisonRadius_B!)
                            game?.mapView?.add(PoisonCircle_B)   //添加毒圈
                            sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                            PoisonCenter_S = CLLocationCoordinate2D(latitude: (CLLocationDegrees(sCenter[1]))!, longitude: (CLLocationDegrees(sCenter[0]))!)
                            PoisonRadius_S = CLLocationDistance(Poison.safetyRadius)
                            PoisonCircle_S = BMKCircle(center: PoisonCenter_S!, radius: PoisonRadius_S!)
                            game?.mapView?.add(PoisonCircle_S)    //添加安全区
                        }
                        else if responseModel.data?.realcsGameCirclePoison?.status == 2 {   //毒圈缩圈
                            Poison = responseModel.data!.realcsGameCirclePoison!
                            bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                            PoisonCenter_B = CLLocationCoordinate2D(latitude: (CLLocationDegrees(bCenter[1]))!, longitude: (CLLocationDegrees(bCenter[0]))!)
                            PoisonRadius_B = CLLocationDistance(Poison.radius)
                            PoisonCircle_B = BMKCircle(center: PoisonCenter_B!, radius: PoisonRadius_B!)
                            game?.mapView?.add(PoisonCircle_B)
                            sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                            PoisonCenter_S = CLLocationCoordinate2D(latitude: (CLLocationDegrees(sCenter[1]))!, longitude: (CLLocationDegrees(sCenter[0]))!)
                            PoisonRadius_S = CLLocationDistance(Poison.safetyRadius)
                            PoisonCircle_S = BMKCircle(center: PoisonCenter_S!, radius: PoisonRadius_S!)
                            game?.mapView?.add(PoisonCircle_S)
                        }
                        else if responseModel.data?.realcsGameCirclePoison?.status == 3 {  //缩圈结束
                            Poison = responseModel.data!.realcsGameCirclePoison!
                            bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                            PoisonCenter_B = CLLocationCoordinate2D(latitude: (CLLocationDegrees(bCenter[1]))!, longitude: (CLLocationDegrees(bCenter[0]))!)
                            PoisonRadius_B = CLLocationDistance(Poison.radius)
                            PoisonCircle_B = BMKCircle(center: PoisonCenter_B!, radius: PoisonRadius_B!)
                            game?.mapView?.add(PoisonCircle_B)
                            sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                            PoisonCenter_S = CLLocationCoordinate2D(latitude: (CLLocationDegrees(sCenter[1]))!, longitude: (CLLocationDegrees(sCenter[0]))!)
                            PoisonRadius_S = CLLocationDistance(Poison.safetyRadius)
                            PoisonCircle_S = BMKCircle(center: PoisonCenter_S!, radius: PoisonRadius_S!)
                            game?.mapView?.add(PoisonCircle_S)
                        }
                        else if responseModel.data?.realcsGameCirclePoison?.status == 4 {  //暂停缩圈
                            Poison = responseModel.data!.realcsGameCirclePoison!
                            bCenter = (responseModel.data?.realcsGameCirclePoison?.center.components(separatedBy: ","))!
                            PoisonCenter_B = CLLocationCoordinate2D(latitude: (CLLocationDegrees(bCenter[1]))!, longitude: (CLLocationDegrees(bCenter[0]))!)
                            PoisonRadius_B = CLLocationDistance(Poison.radius)
                            PoisonCircle_B = BMKCircle(center: PoisonCenter_B!, radius: PoisonRadius_B!)
                            game?.mapView?.add(PoisonCircle_B)
                            sCenter = (responseModel.data?.realcsGameCirclePoison?.safetyCenter.components(separatedBy: ","))!
                            PoisonCenter_S = CLLocationCoordinate2D(latitude: (CLLocationDegrees(sCenter[1]))!, longitude: (CLLocationDegrees(sCenter[0]))!)
                            PoisonRadius_S = CLLocationDistance(Poison.safetyRadius)
                            PoisonCircle_S = BMKCircle(center: PoisonCenter_S!, radius: PoisonRadius_S!)
                            game?.mapView?.add(PoisonCircle_S)
                        }
                        else if responseModel.data?.realcsGameCirclePoison?.status == 5 {  //重置毒圈
                            game?.mapView?.remove(PoisonCircle_B)
                            game?.mapView?.remove(PoisonCircle_S)
                        }
                    }
                    if responseModel.data?.realcsGameTeams != nil{
                        responseModel.data?.realcsGameTeams.forEach({ (model_1) in
                            model_1.realcsGamePersonList.forEach({(model_2) in
                                self.IconArray.append(model_2.realcsUpload!.accesslocation)
                                self.LatArray.append(CLLocationDegrees(model_2.lat))
                                self.LonArray.append(CLLocationDegrees(model_2.lon))
                                self.TeamStatus.append(model_2.status)
                                self.TeamBoold.append(model_2.blood)
                                self.TeamDyingBoold.append(model_2.dyingBlood)
                                self.TeamArmor.append(model_2.defence)
                                if model_2.personId == person_id{  //自己
                                    if model_2.status == 1 {
                                        self.game?.Blood?.isHidden = false
                                        self.game?.DyingBlood?.isHidden = true
                                    }else{
                                        self.game?.Blood?.isHidden = true
                                        self.game?.DyingBlood?.isHidden = false
                                    }
                                    self.connectStatus = model_2.connectStatus
                                    self.MyArmor = model_2.defence
                                    self.MyBlood = model_2.blood
                                    self.MyDyingBlood = model_2.dyingBlood
                                    UIView.animate(withDuration: 0.3, animations: {
                                        self.game?.Blood?.frame.size = CGSize(width: self.MyBlood*280/100, height: 10)
                                        self.game?.DyingBlood?.frame.size = CGSize(width: self.MyDyingBlood*280/100, height: 10)
                                        self.game?.Armor?.frame.size = CGSize(width: self.MyArmor*280/100, height: 2)
                                    })
                                    self.game?.BagView?.isHidden = ButtonStatus(sender: self.connectStatus)
                                    if model_2.shieldFlag != 1{
                                        game?.shieldImage?.stopAnimating()
                                        game?.shieldImage?.isHidden = true
                                    } else {
                                        game?.shieldImage?.startAnimating()
                                        game?.shieldImage?.isHidden = false
                                    }
                                    if model_2.realcsGamePersonEquipList != nil {
                                        model_2.realcsGamePersonEquipList.forEach({ (model_3) in
                                            Equip[model_3.realcsEquip?.realcsEquipCategory?.realcsEquipType?.equipTypeId] = model_3.realcsEquip?.realcsEquipCategory?.realcsUpload?.accesslocation
                                        })
                                        if Equip.keys.contains(2) {   //主武器
                                            if let url = URL(string: (Equip[2]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.GunView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.GunView?.image = UIImage(named: "gun.png")
                                        }
                                        if Equip.keys.contains(1) {   //副武器
                                            if let url = URL(string: (Equip[1]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.HandGunView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.HandGunView?.image = UIImage(named: "handgun.png")
                                        }
                                        if Equip.keys.contains(9) {   //头盔
                                            if let url = URL(string: (Equip[9]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.HatView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.HatView?.image = UIImage(named: "hat.png")
                                        }
                                        if Equip.keys.contains(8) {   //背心
                                            if let url = URL(string: (Equip[8]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                               game?.ClothesView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.ClothesView?.image = UIImage(named: "clothes.png")
                                        }
                                        if Equip.keys.contains(4) {   //近战武器
                                            if let url = URL(string: (Equip[4]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.WeaponView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.WeaponView?.image = UIImage(named: "weapon.png")
                                        }
                                    }
                                }
                            })
                        })
                        self.game?.TeamCollection?.reloadData()
                    }

                    //添加暴露人员
                    if responseModel.data?.exposePersonList != nil{
                        responseModel.data?.exposePersonList.forEach({(model_2) in
                            IconArray.append(model_2.realcsUpload!.accesslocation)
                            LatArray.append(CLLocationDegrees(model_2.lat))
                            LonArray.append(CLLocationDegrees(model_2.lon))
                        })
                    }
                    for i in 0..<IconArray.count {
                        self.i = i
                        annotationArray.append(BMKPointAnnotation())
                        annotationArray[i].coordinate = CLLocationCoordinate2DMake(LatArray[i],LonArray[i])
                        game?.mapView?.addAnnotation(annotationArray[i])
                    }
                }
            }
            if responseModel.flag == "战报" {
                if let responseModel = Model_4.deserialize(from: text) {
                    ReportArray.append(responseModel.data)
                }
                self.game?.TableView3?.reloadData()
            }
            if responseModel.flag == "正在游戏" {
                startTime()
            }
            if responseModel.flag == "游戏结束" {
                game?.GameStatus?.text = "游戏已结束"
                TeamStatus.removeAll()
                TeamBoold.removeAll()
                TeamDyingBoold.removeAll()
                TeamArmor.removeAll()
                Equip.removeAll()
                if let responseModel = Model_2.deserialize(from: text) {
                    game?.TotalNum?.text = "剩余 \(responseModel.data!.total) 人"
                    if responseModel.data?.realcsGameTeams != nil{
                        responseModel.data?.realcsGameTeams.forEach({ (model_1) in
                            model_1.realcsGamePersonList.forEach({(model_2) in
                                self.TeamStatus.append(model_2.status)
                                self.TeamBoold.append(model_2.blood)
                                self.TeamDyingBoold.append(model_2.dyingBlood)
                                self.TeamArmor.append(model_2.defence)
                                if model_2.personId == person_id{  //自己
                                    if model_2.status == 1 {
                                        self.game?.Blood?.isHidden = false
                                        self.game?.DyingBlood?.isHidden = true
                                    }else{
                                        self.game?.Blood?.isHidden = true
                                        self.game?.DyingBlood?.isHidden = false
                                    }
                                    self.connectStatus = model_2.connectStatus
                                    self.MyArmor = model_2.defence
                                    self.MyBlood = model_2.blood
                                    self.MyDyingBlood = model_2.dyingBlood
                                    UIView.animate(withDuration: 0.3, animations: {
                                        self.game?.Blood?.frame.size = CGSize(width: self.MyBlood*280/100, height: 10)
                                        self.game?.DyingBlood?.frame.size = CGSize(width: self.MyDyingBlood*280/100, height: 10)
                                        self.game?.Armor?.frame.size = CGSize(width: self.MyArmor*280/100, height: 2)
                                    })
                                    self.game?.BagView?.isHidden = ButtonStatus(sender: self.connectStatus)
                                    if model_2.shieldFlag != 1{
                                        game?.shieldImage?.stopAnimating()
                                        game?.shieldImage?.isHidden = true
                                    } else {
                                        game?.shieldImage?.startAnimating()
                                        game?.shieldImage?.isHidden = false
                                    }
                                    if model_2.realcsGamePersonEquipList != nil {
                                        model_2.realcsGamePersonEquipList.forEach({ (model_3) in
                                            Equip[model_3.realcsEquip?.realcsEquipCategory?.realcsEquipType?.equipTypeId] = model_3.realcsEquip?.realcsEquipCategory?.realcsUpload?.accesslocation
                                        })
                                        if Equip.keys.contains(2) {   //主武器
                                            if let url = URL(string: (Equip[2]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.GunView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.GunView?.image = UIImage(named: "gun.png")
                                        }
                                        if Equip.keys.contains(1) {   //副武器
                                            if let url = URL(string: (Equip[1]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.HandGunView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.HandGunView?.image = UIImage(named: "handgun.png")
                                        }
                                        if Equip.keys.contains(9) {   //头盔
                                            if let url = URL(string: (Equip[9]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.HatView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.HatView?.image = UIImage(named: "hat.png")
                                        }
                                        if Equip.keys.contains(8) {   //背心
                                            if let url = URL(string: (Equip[8]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.ClothesView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.ClothesView?.image = UIImage(named: "clothes.png")
                                        }
                                        if Equip.keys.contains(4) {   //近战武器
                                            if let url = URL(string: (Equip[4]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!){
                                                game?.WeaponView?.kf.setImage(with: url)
                                            }
                                        } else {
                                            game?.WeaponView?.image = UIImage(named: "weapon.png")
                                        }
                                    }
                                }
                            })
                        })
                        self.game?.TeamCollection?.reloadData()
                    }
                }
                let alertView = UIAlertController(title: "游戏结束", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "确定", style: .default ,handler: { (UIAlertAction) -> Void in
                })
                alertView.addAction(action)
                self.present(alertView, animated: true, completion: nil)
            }
            if responseModel.flag == "重载游戏" {
                game?.GameStatus?.text = "游戏未开始"
            }
        }
    }
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
//        print("接收数据:\(data)")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IconArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
    
        cell.NameLabel?.text = TeamName[indexPath.item]
        if TeamPersonId[indexPath.item] == person_id {
            cell.NameLabel?.textColor = UIColor.orange
        }else{
            cell.NameLabel?.textColor = UIColor.white
        }
        if let url = URL(string: TeamIcon[indexPath.item]){
            cell.IconImageView?.kf.setImage(with: ImageResource(downloadURL: url))
        }
        
        if TeamStatus[indexPath.item] == 1{   //正常
            cell.TeamBlood?.isHidden = false
            cell.TeamDyingBlood?.isHidden = true
            cell.DeadView?.isHidden = true
        }
        else if TeamStatus[indexPath.item] == 3{   //濒死
            cell.TeamBlood?.isHidden = true
            cell.TeamDyingBlood?.isHidden = false
            cell.DeadView?.isHidden = true
        }
        else if TeamStatus[indexPath.item] == 2{   //死亡
            cell.DeadView?.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            cell.TeamBlood?.frame = CGRect(x: 0, y: 0, width: self.TeamBoold[indexPath.item]*50/100, height: 5)
            cell.TeamDyingBlood?.frame = CGRect(x: 0, y: 0, width: self.TeamDyingBoold[indexPath.item]*50/100, height: 5)
            cell.TeamArmor?.frame = CGRect(x: 0, y: 0, width: self.TeamArmor[indexPath.item]*50/100, height: 2)
        })

        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(game?.TableView1) {
            return Num1
        }
        if tableView.isEqual(game?.TableView2) {
            return Num2
        }
        if tableView.isEqual(game?.TableView3) {
            return ReportArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEqual(game?.TableView1) {
            return 30
        }
        if tableView.isEqual(game?.TableView2) {
            return 30
        }
        if tableView.isEqual(game?.TableView3) {
            return 15
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        if tableView.isEqual(game?.TableView1) || tableView.isEqual(game?.TableView2){
            var cell : GameTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell1") as? GameTableViewCell1
            if cell == nil {
                cell = GameTableViewCell1(style: .default, reuseIdentifier: "GameTableViewCell1")
            }
            cell.NameLabel?.text = "队员100"
            cell.SpeechView?.delegate = self
            btn = cell.SpeechView
            
            weak var weakSelf = self
            weakSelf?.btn.contentURL = UrlArray[0]
            weakSelf?.btn.isUserInteractionEnabled = true
            
            cell.SpeechView = btn
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        if tableView.isEqual(game?.TableView3){
            var cell : GameTableViewCell2! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell2") as? GameTableViewCell2
            if cell == nil {
                cell = GameTableViewCell2(style: .default, reuseIdentifier: "GameTableViewCell2")
            }
            cell.ReportLabel?.text = ReportArray[indexPath.row]
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        }
        return cell!
    }
    
    //gps
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        game?.mapView?.removeAnnotation(location)
        let currLocation:CLLocation = locations.last!
        Mylon = currLocation.coordinate.longitude
        Mylat = currLocation.coordinate.latitude
        //坐标转换
        let coodinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Mylat!, Mylon!)
        let srctype = BMKLocationCoordinateType.WGS84    //原始坐标系
        let destype = BMKLocationCoordinateType.BMK09LL  //百度坐标系
        let cood: CLLocationCoordinate2D = BMKLocationManager.bmkLocationCoordinateConvert(coodinate, srcType: srctype, desType: destype)
        
        location = BMKPointAnnotation()
        location?.coordinate = cood
        game?.mapView?.addAnnotation(location!)
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
    
    func voiceBubbleStratOrStop(_ voiceBubble: ZFJVoiceBubble, _ isStart: Bool) {
        NSLog("voiceBubbleStratOrStop")
    }
    
    func voiceBubbleDidStartPlaying(_ voiceBubble: ZFJVoiceBubble) {
        NSLog("voiceBubbleDidStartPlaying")
    }
    
    func addAnnotations(_ annotations: [BMKAnnotation]) {
    }
    
    func mapView(_ mapView: BMKMapView, viewFor annotation: BMKAnnotation) -> BMKAnnotationView? {
        if (annotation is BMKPointAnnotation) {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationReuseIndetifier")
            if annotationView == nil {
                annotationView = BMKAnnotationView(annotation: annotation, reuseIdentifier: "annotationReuseIndetifier")
            }
            if annotation.isEqual(location){
                let image = UIImage(data: try! Data(contentsOf: URL(string: MyIcon!)!))
                ImageCache.default.store(image!, forKey: MyIcon!)
                ImageCache.default.retrieveImage(forKey: MyIcon!, options: nil) { (image, cacheType) in
                    annotationView?.image = image
                }
            }else{
                if cache.isCached(forKey: IconArray[i]) {
                    ImageCache.default.retrieveImage(forKey: IconArray[i], options: nil) { (image, cacheType) in
                        annotationView?.image = image
                    }
                }else{
                    let image = UIImage(data: try! Data(contentsOf: URL(string: IconArray[i])!))
                    ImageCache.default.store(image!, forKey: IconArray[i])
                    ImageCache.default.retrieveImage(forKey: IconArray[i], options: nil) { (image, cacheType) in
                        annotationView?.image = image
                    }
                }
            }

            return annotationView
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
            if overlay.isEqual(PoisonCircle_B){
                circleView?.strokeColor = UIColor.red
                circleView?.lineWidth = 1
            }
            if overlay.isEqual(PoisonCircle_S){
                circleView?.strokeColor = UIColor.blue
                circleView?.lineWidth = 1
            }
            
            return circleView
        }
        return nil
    }
    
//    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) -> Void {
//        print("connect success")
//        clientSocket.readData(withTimeout: -1, tag: 0)
//    }
//
//    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) -> Void {
//        print("connect error: \(String(describing: err))")
//    }
//
//    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) -> Void {
//        // 1、获取客户端发来的数据，把 NSData 转 NSString
//        print(data)
//        let readClientDataString: NSString? = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
//        print("---Data Recv---")
//        print(readClientDataString)
//
//        // 2、主界面UI显示数据
//        DispatchQueue.main.async {
//            let showStr: NSMutableString = NSMutableString()
//            showStr.append(self.msgView.text)
//            showStr.append(readClientDataString! as String)
//            showStr.append("\r\n")
//            self.msgView.text = showStr as String
//        }
//
//        print(msgView.text)
//
//        // 3、处理请求，返回数据给客户端OK
//        let serviceStr: NSMutableString = NSMutableString()
//        serviceStr.append("OK")
//        serviceStr.append("\r\n")
//        clientSocket.write(serviceStr.data(using: String.Encoding.utf8.rawValue)!, withTimeout: -1, tag: 0)
//
//        // 4、每次读完数据后，都要调用一次监听数据的方法
//        clientSocket.readData(withTimeout: -1, tag: 0)
//    }

}

