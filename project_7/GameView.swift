import UIKit

class GameView : UIView {
    
    var mapView: BMKMapView?
    var button1 : UIButton?
    var button2 : UIButton?
    var selector : UIButton?
    var BloodView : UIView?
    var Blood : UIView?
    var DyingBlood : UIView?
    var ArmorView : UIView?
    var Armor : UIView?
    var HatView : UIImageView?
    var ClothesView : UIImageView?
    var WeaponView : UIImageView?
    var HandGunView : UIImageView?
    var GunView : UIImageView?
    var SelectButton : UIButton?
    var BagView : UILabel?
    var GameStatus : UILabel?
    var TotalNum : UILabel?
    var Speech : ZFJChatInputTool?
    var Button1 : UIButton?
    var Button2 : UIButton?
    var Button3 : UIButton?
    var SelectBtn : UIButton?
    var LocationBtn : UIButton?
    var TeamCollection : UICollectionView?
    var ScrollView : UIScrollView?
    var TableView1 : UITableView?
    var TableView2 : UITableView?
    var TableView3 : UITableView?
    var shieldImage : UIImageView?
    var label : UILabel?
    var StartLabel : UILabel?
    override init(frame : CGRect)
        
    {
        
        super.init(frame: frame)
        
        self.mapView = BMKMapView()
        self.addSubview(mapView!)

        self.button1 = UIButton()
        self.addSubview(button1!)

        self.button2 = UIButton()
        self.addSubview(button2!)

        self.BloodView = UIView()
        self.addSubview(BloodView!)

        self.Blood = UIView()
        self.BloodView?.addSubview(Blood!)

        self.DyingBlood = UIView()
        self.BloodView?.addSubview(DyingBlood!)

        self.ArmorView = UIView()
        self.addSubview(ArmorView!)

        self.Armor = UIView()
        self.ArmorView?.addSubview(Armor!)

        self.HatView = UIImageView()
        self.addSubview(HatView!)

        self.ClothesView = UIImageView()
        self.addSubview(ClothesView!)

        self.WeaponView = UIImageView()
        self.addSubview(WeaponView!)

        self.HandGunView = UIImageView()
        self.addSubview(HandGunView!)

        self.GunView = UIImageView()
        self.addSubview(GunView!)

        self.BagView = UILabel()
        self.addSubview(BagView!)

        self.GameStatus = UILabel()
        self.addSubview(GameStatus!)

        self.TotalNum = UILabel()
        self.addSubview(TotalNum!)

        self.Speech = ZFJChatInputTool()
        self.addSubview(Speech!)

        self.Button1 = UIButton()
        self.addSubview(Button1!)

        self.Button2 = UIButton()
        self.addSubview(Button2!)

        self.Button3 = UIButton()
        self.addSubview(Button3!)

        self.LocationBtn = UIButton()
        self.addSubview(LocationBtn!)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 50, height: 60)
        self.TeamCollection = UICollectionView(frame: CGRect(x: 10, y: 10, width: 170, height: 130), collectionViewLayout: layout)
        self.addSubview(TeamCollection!)

        self.ScrollView = UIScrollView()
        self.addSubview(ScrollView!)

        self.TableView1 = UITableView()
        self.ScrollView?.addSubview(TableView1!)

        self.TableView2 = UITableView()
        self.ScrollView?.addSubview(TableView2!)

        self.TableView3 = UITableView()
        self.ScrollView?.addSubview(TableView3!)

        self.shieldImage = UIImageView()
        self.addSubview(shieldImage!)

        self.label = UILabel()
        self.shieldImage?.addSubview(label!)

        self.StartLabel = UILabel()
        self.addSubview(StartLabel!)
        
        setUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.mapView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.mapView?.minZoomLevel = 16
        self.mapView?.maxZoomLevel = 21
        self.mapView?.showMapScaleBar = true
        self.mapView?.mapScaleBarPosition = CGPoint(x: ScreenSize.width-130, y: ScreenSize.height-35)
        self.mapView?.compassPosition = CGPoint(x: ScreenSize.width, y: 0)
        
        self.button1?.frame = CGRect(x: ScreenSize.width-90, y: 10, width: 40, height: 20)
        self.button1?.setTitle("地图", for: .normal)
        self.button1?.setTitleColor(UIColor.white, for: .normal)
        self.button1?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
        self.button1?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.button1?.layer.borderColor = UIColor.white.cgColor
        self.button1?.layer.borderWidth = 1
        self.button1?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.button1?.isSelected = true
        self.selector = self.button1

        self.button2?.frame = CGRect(x: ScreenSize.width-50, y: 10, width: 40, height: 20)
        self.button2?.setTitle("卫星", for: .normal)
        self.button2?.setTitleColor(UIColor.white, for: .normal)
        self.button2?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
        self.button2?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.button2?.layer.borderColor = UIColor.white.cgColor
        self.button2?.layer.borderWidth = 1
        self.button2?.titleLabel?.font = UIFont.systemFont(ofSize: 10)

        self.BloodView?.frame = CGRect(x: ScreenSize.width/2-140, y: ScreenSize.height-30, width: 280, height: 10)
        self.BloodView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        self.Blood?.frame = CGRect(x: 0, y: 0, width: 280, height: 10)
        self.Blood?.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)

        self.DyingBlood?.frame = CGRect(x: 0, y: 0, width: 280, height: 10)
        self.DyingBlood?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
        self.DyingBlood?.isHidden = true

        self.ArmorView?.frame = CGRect(x: ScreenSize.width/2-140, y: ScreenSize.height-33, width: 280, height: 2)
        self.ArmorView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

        self.Armor?.frame = CGRect(x: 0, y: 0, width: 280, height: 2)
        self.Armor?.backgroundColor = UIColor(red: 28/255, green: 134/255, blue: 238/255, alpha: 1)

        self.HatView?.frame = CGRect(x: ScreenSize.width/2-140, y: ScreenSize.height-80, width: 40, height: 40)
        self.HatView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.HatView?.image = UIImage(named: "hat.png")

        self.ClothesView?.frame = CGRect(x: ScreenSize.width/2-90, y: ScreenSize.height-80, width: 40, height: 40)
        self.ClothesView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.ClothesView?.image = UIImage(named: "clothes.png")

        self.WeaponView?.frame = CGRect(x: ScreenSize.width/2-40, y: ScreenSize.height-80, width: 40, height: 40)
        self.WeaponView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.WeaponView?.image = UIImage(named: "weapon.png")

        self.HandGunView?.frame = CGRect(x: ScreenSize.width/2+10, y: ScreenSize.height-80, width: 40, height: 40)
        self.HandGunView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.HandGunView?.image = UIImage(named: "handgun.png")

        self.GunView?.frame = CGRect(x: ScreenSize.width/2+60, y: ScreenSize.height-80, width: 80, height: 40)
        self.GunView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.GunView?.image = UIImage(named: "gun.png")

        self.BagView?.frame = CGRect(x: ScreenSize.width/2-140, y: ScreenSize.height-80, width: 280, height: 40)
        self.BagView?.text = "腰包未连接"
        self.BagView?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 2))
        self.BagView?.textColor = UIColor.red
        self.BagView?.textAlignment = .center
        self.BagView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)

        self.GameStatus?.frame = CGRect(x: ScreenSize.width/2+5, y: 10, width: 70, height: 20)
        self.GameStatus?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.GameStatus?.textColor = UIColor.white
        self.GameStatus?.textAlignment = .center
        self.GameStatus?.font = UIFont.systemFont(ofSize: 10)

        self.TotalNum?.frame = CGRect(x: ScreenSize.width/2-75, y: 10, width: 70, height: 20)
        self.TotalNum?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.TotalNum?.textColor = UIColor.white
        self.TotalNum?.textAlignment = .center
        self.TotalNum?.font = UIFont.systemFont(ofSize: 10)

        self.Speech?.frame = CGRect(x: ScreenSize.width-70, y: ScreenSize.height-70, width: 55, height: 55)

        self.Button1?.frame = CGRect(x: 0, y: ScreenSize.height-120, width: 25, height: 40)
        self.Button1?.setTitle("队伍", for: .normal)
        self.Button1?.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(2))
        self.Button1?.titleLabel?.numberOfLines = 2
        self.Button1?.setTitleColor(UIColor.lightGray, for: .normal)
        self.Button1?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
        self.Button1?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.Button1?.tag = 0
        self.Button1?.isSelected = true
        self.SelectBtn = self.Button1

        self.Button2?.frame = CGRect(x: 0, y: ScreenSize.height-80, width: 25, height: 40)
        self.Button2?.setTitle("世界", for: .normal)
        self.Button2?.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(2))
        self.Button2?.titleLabel?.numberOfLines = 2
        self.Button2?.setTitleColor(UIColor.lightGray, for: .normal)
        self.Button2?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
        self.Button2?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.Button2?.tag = 1

        self.Button3?.frame = CGRect(x: 0, y: ScreenSize.height-40, width: 25, height: 40)
        self.Button3?.setTitle("系统", for: .normal)
        self.Button3?.titleLabel!.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(2))
        self.Button3?.titleLabel?.numberOfLines = 2
        self.Button3?.setTitleColor(UIColor.lightGray, for: .normal)
        self.Button3?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
        self.Button3?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.Button3?.tag = 2

        self.LocationBtn?.frame = CGRect(x: ScreenSize.width-70, y: ScreenSize.height-140, width: 50, height: 50)
        self.LocationBtn?.layer.cornerRadius = (LocationBtn?.frame.width)!/2
        self.LocationBtn?.layer.masksToBounds = true
        self.LocationBtn?.setImage(UIImage(named: "dingwei.png"), for: .normal)

//        self.TeamCollection?.frame = CGRect(x: 10, y: 10, width: 170, height: 130)
        self.TeamCollection?.backgroundColor = UIColor.clear

        self.ScrollView?.frame = CGRect(x: 25, y: ScreenSize.height-120, width: 150, height: 120)
        self.ScrollView?.contentSize = CGSize(width: 0, height: 120)
        self.ScrollView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.ScrollView?.showsHorizontalScrollIndicator = false
        self.ScrollView?.showsVerticalScrollIndicator = false
        self.ScrollView?.scrollsToTop = false

        self.TableView1?.frame = CGRect(x: 0, y: 5, width: 150, height: 110)
        self.TableView1?.backgroundColor = UIColor.clear
        self.TableView1?.separatorStyle = .none

        self.TableView2?.frame = CGRect(x: 150, y: 5, width: 150, height: 110)
        self.TableView2?.backgroundColor = UIColor.clear
        self.TableView2?.separatorStyle = .none

        self.TableView3?.frame = CGRect(x: 300, y: 5, width: 150, height: 110)
        self.TableView3?.backgroundColor = UIColor.clear
        self.TableView3?.separatorStyle = .none

        self.shieldImage?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.shieldImage?.isHidden = true

        guard let imgPath = Bundle.main.path(forResource: "timg.gif", ofType: nil) else { return }
        guard let imgData = NSData(contentsOfFile: imgPath) else { return }

        // 2、从data中读取数据：将data转成CGImageSource对象
        guard let imgSource = CGImageSourceCreateWithData(imgData, nil) else {
            return
        }

        // 3、获取在CGImageSource中图片的个数
        let imgCount = CGImageSourceGetCount(imgSource)

        // 4、遍历所有图片
        var imgs = [UIImage]()
        var totalDuration: TimeInterval = 0
        for i in 0..<imgCount {
            // 4.1、取出图片
            guard let cgimg = CGImageSourceCreateImageAtIndex(imgSource, i, nil) else { continue }
            let img = UIImage(cgImage: cgimg)
            if i == 0 { // 保证执行完一次gif后不消失
                self.shieldImage?.image = img
            }
            imgs.append(img)

            // 4.2、取出持续的时间
            guard let properties = CGImageSourceCopyPropertiesAtIndex(imgSource, i, nil) as? NSDictionary else { continue }
            guard let dict = properties[kCGImagePropertyGIFDictionary] as? NSDictionary else { continue }
            guard let duration = dict[kCGImagePropertyGIFDelayTime] as? NSNumber else { continue }
            totalDuration += duration.doubleValue
        }

        // 5、设置imageView的属性
        self.shieldImage?.animationImages = imgs
        self.shieldImage?.animationDuration = totalDuration
        self.shieldImage?.animationRepeatCount = 0  // 执行一次，设置为0时无限执行

        // 6、开始播放
        //        shieldImage?.startAnimating()
        self.shieldImage?.stopAnimating()

        self.label?.frame = CGRect(x: ScreenSize.width/2-150, y: ScreenSize.height/2-50, width: 300, height: 100)
        self.label?.text = "信号干扰中……"
        self.label?.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 2))
        self.label?.textColor = UIColor.red
        self.label?.textAlignment = .center

        self.StartLabel?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.StartLabel?.textAlignment = .center
        self.StartLabel?.textColor = UIColor.white
        self.StartLabel?.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight(rawValue: 2))
        self.StartLabel?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.StartLabel?.isHidden = true
    }
}
