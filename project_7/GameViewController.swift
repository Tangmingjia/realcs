import UIKit
import WebKit
import Starscream
import CoreLocation
import Kingfisher
import Alamofire

public var mapPath : String?
class GameViewController: UIViewController,WKUIDelegate,WKNavigationDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WebSocketDelegate,ZFJVoiceBubbleDelegate,CLLocationManagerDelegate,BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource,GCDAsyncSocketDelegate{
    
    var syncTile = BMKLocalSyncTileLayer()
    var btn : ZFJVoiceBubble!
    var clientSocket:GCDAsyncSocket!
    let gps = CLLocationManager()
    var websocket : WebSocket?
    var MyName : String?
    var MyBlood : Int = 0
    var MyDyingBlood : Int = 0
    var MyArmor : Int = 0
    var MyStatus : Int = 0
    var Mylat : CLLocationDegrees?
    var Mylon : CLLocationDegrees?
    var connectStatus : Int = 0
    var ReportArray : Array = [String]()
    var Equip : Dictionary = [Int? : String]()
    var centerLat: CGFloat = 0.0
    var centerLon: CGFloat = 0.0
    var center : CLLocationCoordinate2D?
    var i = 0
    var MyTeam : [RealcsGamePersonListItem]? = nil
    var annotationArray = [BMKPointAnnotation()]
    var LonArray : Array = [CLLocationDegrees]()
    var LatArray : Array = [CLLocationDegrees]()
    var IconArray : Array = [String]()
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
    var game : GameView?
    var location : BMKPointAnnotation?
    var gpsstr : String = ""
    var whoami : String = ""
    var timer_2 : Timer?
    var jsonData : Data?
    var jsonData2 : Data?
    var jsonData3 : Data?
    var url : URL?
    var cafstr : String = ""
    var caf : String?
    var teamorworld : String?
    var TeamVoiceName : Array = [String]()
    var TeamUrlArray : Array = [URL]()
    var WorldVoiceName : Array = [String]()
    var WorldUrlArray : Array = [URL]()
    var TeamVoiceNum : Int = 0
    var WorldVoiceNum : Int = 0
    lazy var onecode : Void = {
        let timer_3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sendgps), userInfo: nil, repeats: true)
        timer_3.fire()
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
        
        //scoket
        do {
            clientSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.global())
            try clientSocket.connect(toHost: Host!, onPort: 25409)
            }
        catch {
            }
        
        whoami = "{\"ACTION\":\"phone-whoami\",\"REQUEST_ID\":\"\(UIDevice.current.identifierForVendor!.uuidString)\",\"DATA\":{\"GAME_ID\":\(game_id!),\"PACKAGE_ID\":\"\(packageNo!)\",\"TEAM_ID\":\(team_id!)}}\r\n"
        jsonData = whoami.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        //发送心跳包
        timer_2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(heart), userInfo: nil, repeats: true)
        

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
            self.url = URL(fileURLWithPath: voiceUrl.absoluteString)
        }
        //隐藏百度logo
        let mView = game?.mapView?.subviews.first
        for logoView in mView!.subviews {
            if logoView is UIImageView {
                let b_logo = logoView as? UIImageView
                b_logo?.isHidden = true
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false  //防止右滑返回
        game?.mapView?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
//        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        game?.mapView?.viewWillDisappear()
        websocket!.disconnect()
//        //清理内存缓存
//        cache.clearMemoryCache()
//        // 清理硬盘缓存，这是一个异步的操作
//        cache.clearDiskCache()
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
    
    @objc func heart(){
        clientSocket.write(jsonData!, withTimeout: -1, tag: 0)
    }
    
    @objc func sendgps(){
        clientSocket.write(jsonData2!, withTimeout: -1, tag: 0)
    }
    
    @objc func sendmsg(){
        clientSocket.write(jsonData3!, withTimeout: -1, tag: 0)
    }
    
    @objc func noti(n: Notification) {
        if game?.SelectBtn?.tag == 0 || game?.SelectBtn?.tag == 2{
            teamorworld = "team"
        }else if game?.SelectBtn?.tag == 1{
            teamorworld = "world"
        }
        let name = n.object as! String
        Alamofire.upload(multipartFormData: {(Formdata) in
            Formdata.append(self.url!, withName: "file", fileName: name, mimeType: "caf")
        }, to: "http://\(Host!):8998/voice/uploadVoice", encodingCompletion: {(encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    let str = String(data:response.data!, encoding: String.Encoding.utf8)!
                    if let responseModel = Model_3.deserialize(from: str){
                        self.caf = responseModel.data
                        self.cafstr = "{\"ACTION\":\"phone-send-msg\",\"DATA\":{\"PERSON_NAME\":\"\(self.MyName!)\",\"MSG_TYPE\":\"MSG_VOICE\",\"MSG_VOICE\":\"\(self.caf!)\",\"GAME_ID\":\(game_id!),\"PACKAGE_ID\":\"\(packageNo!)\",\"TEAM_ID\":\(team_id!),\"MSG_CHANNEL\":\"\(self.teamorworld!)\"},\"REQUEST_ID\":\"\(UIDevice.current.identifierForVendor!.uuidString)\"}\r\n"
                        self.jsonData3 = self.cafstr.data(using: String.Encoding.utf8, allowLossyConversion: false)
                        self.sendmsg()
                    }
                })
            case .failure(let error):
                print(error)
            }
        })
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
        if !websocket!.isConnected {
            websocket?.connect()
        }
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
//        print("接收消息:\(text)")
        if let responseModel = Model_3.deserialize(from: text) {
            if responseModel.flag == nil {
                Equip.removeAll()
                IconArray.removeAll()
                LatArray.removeAll()
                LonArray.removeAll()
                game?.mapView?.removeAnnotations(annotationArray)
                annotationArray.removeAll()
                if let responseModel = Model_2.deserialize(from: text) {
                    if responseModel.data?.realcsGameMap?.mapPath != nil {
                        mapPath = responseModel.data?.realcsGameMap?.mapPath
                        //瓦片
                        syncTile.maxZoom = 21
                        syncTile.minZoom = 16
                        game?.mapView?.add(syncTile)
                    }
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
                                MyTeam = model_1.realcsGamePersonList
                                model_1.realcsGamePersonList.forEach({ (model_2) in
                                    self.IconArray.append(model_2.realcsUpload!.accesslocation)
                                    self.LatArray.append(CLLocationDegrees(model_2.lat))
                                    self.LonArray.append(CLLocationDegrees(model_2.lon))
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
                            MyTeam = model_1.realcsGamePersonList
                            model_1.realcsGamePersonList.forEach({(model_2) in
                                self.IconArray.append(model_2.realcsUpload!.accesslocation)
                                self.LatArray.append(CLLocationDegrees(model_2.lat))
                                self.LonArray.append(CLLocationDegrees(model_2.lon))
                                if model_2.personId == person_id{  //自己
                                    if model_2.status == 1 {
                                        self.game?.Blood?.isHidden = false
                                        self.game?.DyingBlood?.isHidden = true
                                    }else{
                                        self.game?.Blood?.isHidden = true
                                        self.game?.DyingBlood?.isHidden = false
                                    }
                                    self.MyName = model_2.personName
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
                ReportArray.append(responseModel.data)
                self.game?.TableView3?.reloadData()
            }
            if responseModel.flag == "正在游戏" {
                startTime()
            }
            if responseModel.flag == "游戏结束" {
                game?.GameStatus?.text = "游戏已结束"
                Equip.removeAll()
                if let responseModel = Model_2.deserialize(from: text) {
                    game?.TotalNum?.text = "剩余 \(responseModel.data!.total) 人"
                    if responseModel.data?.realcsGameTeams != nil{
                        responseModel.data?.realcsGameTeams.forEach({ (model_1) in
                            MyTeam = model_1.realcsGamePersonList
                            model_1.realcsGamePersonList.forEach({(model_2) in
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
        return MyTeam?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCollectionViewCell", for: indexPath) as! GameCollectionViewCell
    
        cell.NameLabel?.text = MyTeam![indexPath.item].personName
        if MyTeam?[indexPath.item].personId == person_id {
            cell.NameLabel?.textColor = UIColor.orange
            cell.layer.borderColor = UIColor.orange.cgColor
            cell.layer.borderWidth = 1
        }else{
            cell.NameLabel?.textColor = UIColor.white
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
        }
        
        if let url = URL(string: MyTeam![indexPath.item].realcsUpload!.accesslocation){
            cell.IconImageView?.kf.setImage(with: url, placeholder: UIImage(named: "logo.png"), options: nil, progressBlock: nil, completionHandler: {(image, error, cacheType, imageUrl) in
                if error == nil{
                    cell.IconImageView?.image = image
                }
            })
        }
        
        if MyTeam?[indexPath.item].status == 1{   //正常
            cell.TeamBlood?.isHidden = false
            cell.TeamDyingBlood?.isHidden = true
            cell.DeadView?.isHidden = true
        }
        else if MyTeam?[indexPath.item].status == 3{   //濒死
            cell.TeamBlood?.isHidden = true
            cell.TeamDyingBlood?.isHidden = false
            cell.DeadView?.isHidden = true
        }
        else if MyTeam?[indexPath.item].status == 2{   //死亡
            cell.DeadView?.isHidden = false
        }
//        UIView.animate(withDuration: 0.3, animations: {
            cell.TeamBlood?.frame = CGRect(x: 0, y: 0, width: self.MyTeam![indexPath.item].blood*50/100, height: 5)
            cell.TeamDyingBlood?.frame = CGRect(x: 0, y: 0, width: self.MyTeam![indexPath.item].dyingBlood*50/100, height: 5)
            cell.TeamArmor?.frame = CGRect(x: 0, y: 0, width: self.MyTeam![indexPath.item].defence*50/100, height: 2)
//        })

        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(game?.TableView1) {
            return TeamVoiceNum
        }
        if tableView.isEqual(game?.TableView2) {
            return WorldVoiceNum
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
        if tableView.isEqual(game?.TableView1){
            var cell : GameTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell1") as? GameTableViewCell1
            if cell == nil {
                cell = GameTableViewCell1(style: .default, reuseIdentifier: "GameTableViewCell1")
            }
            cell.NameLabel?.text = TeamVoiceName[indexPath.row]
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
        if tableView.isEqual(game?.TableView2){
            var cell : GameTableViewCell1! = tableView.dequeueReusableCell(withIdentifier: "GameTableViewCell1") as? GameTableViewCell1
            if cell == nil {
                cell = GameTableViewCell1(style: .default, reuseIdentifier: "GameTableViewCell1")
            }
            cell.NameLabel?.text = WorldVoiceName[indexPath.row]
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
//        game?.mapView?.removeAnnotation(location)
        let currLocation:CLLocation = locations.last!
        Mylon = currLocation.coordinate.longitude
        Mylat = currLocation.coordinate.latitude
        //坐标转换
        let coodinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(Mylat!, Mylon!)
        let srctype = BMKLocationCoordinateType.WGS84    //原始坐标系
        let destype = BMKLocationCoordinateType.BMK09LL  //百度坐标系
        let cood: CLLocationCoordinate2D = BMKLocationManager.bmkLocationCoordinateConvert(coodinate, srcType: srctype, desType: destype)
        Mylon = cood.longitude
        Mylat = cood.latitude
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        
        gpsstr = "{\"lon\":\(Mylon!),\"gpsType\":\"phone\",\"time\":\(timeStamp),\"hdop\":\(currLocation.horizontalAccuracy),\"devid\":\"\(packageNo!)\",\"lat_type\":\"N\",\"height\":\(currLocation.altitude),\"state\":1,\"stars\":0,\"lon_type\":\"E\",\"locationTime\":0,\"direction\":\(currLocation.course),\"appType\":0,\"gameid\":\(game_id!),\"height_unit\":\"M\",\"lat\":\(Mylat!)}\r\n"
        jsonData2 = gpsstr.data(using: String.Encoding.utf8, allowLossyConversion: false)
        _ = onecode

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
        if (overlay is BMKTileLayer) {
            let view = BMKTileLayerView(tileLayer: overlay as? BMKTileLayer)
            return view
        }
        return nil
    }
    
    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
        sock.readData(withTimeout: -1, tag: 0)
    }

    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) -> Void {
        print("connect success")
        timer_2!.fire()
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) -> Void {
        print("connect error: \(String(describing: err!))")
        do{
            try sock.connect(toHost: Host!, onPort: 25409)
        }
        catch{
        }
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) -> Void {
        let bytes = [UInt8](data)
// 1、获取服务端发来的数据，把 NSData 转 NSString
//        let readClientDataString: NSString? = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if bytes.count > 250{
            //gbk解码
            let readClientDataString: String? = String(data: data, encoding: String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue))))
            if let responseModel = Model_4.deserialize(from: readClientDataString) {
                if responseModel.DATA?.MSG_CHANNEL == "team"{
                    TeamVoiceNum += 1
                    TeamVoiceName.append(responseModel.DATA!.PERSON_NAME)
                    TeamUrlArray.append(URL(string: responseModel.DATA!.MSG_VOICE)!)
                    //主线程刷新tableview
                    DispatchQueue.main.async {
                        self.game?.TableView1?.reloadData()
                    }
                }else if responseModel.DATA?.MSG_CHANNEL == "world"{
                    WorldVoiceNum += 1
                    WorldVoiceName.append(responseModel.DATA!.PERSON_NAME)
                    WorldUrlArray.append(URL(string: responseModel.DATA!.MSG_VOICE)!)
                    DispatchQueue.main.async {
                        self.game?.TableView2?.reloadData()
                    }
                }
            }
        }
//            print(readClientDataString! as Any)
    
        // 2、每次读完数据后，都要调用一次监听数据的方法
        sock.readData(withTimeout: -1, tag: 0)
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
    
}
