import UIKit

class Map : UIView {
    
    var mapView : BMKMapView?       //地图
    var label : UILabel?
    var typeSwitch : UISwitch?
//    var button1 : UIButton?
//    var button2 : UIButton?
//    var selector : UIButton?
    
    override init(frame : CGRect)
        
    {
        super.init(frame: frame)
        
        self.mapView = BMKMapView()
        self.addSubview(mapView!)
        
        self.label = UILabel()
        self.addSubview(label!)
        
        self.typeSwitch = UISwitch()
        self.addSubview(typeSwitch!)
        
//        self.button1 = UIButton()
//        self.addSubview(button1!)
//
//        self.button2 = UIButton()
//        self.addSubview(button2!)
        
        setUI()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        self.mapView?.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
//        self.mapView?.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        self.mapView?.minZoomLevel = 18
        self.mapView?.maxZoomLevel = 21
        //        self.mapView?.showMapScaleBar = true    //比例尺
        self.mapView?.isScrollEnabled = false  //禁止拖拽
        self.mapView?.showsUserLocation = true  //用户定位
//        self.mapView?.isRotateEnabled = false  //禁止旋转
//        self.mapView?.rotation = -90       //逆时针旋转90度
        self.mapView?.userTrackingMode = BMKUserTrackingModeFollowWithHeading   //罗盘模式
//        self.mapView?.mapScaleBarPosition = CGPoint(x: ScreenSize.width-92, y: 50)
        self.mapView?.compassPosition = CGPoint(x: ScreenSize.width, y: 0)
        
        self.label?.frame = CGRect(x: ScreenSize.width-80, y: 57, width: 40, height: 20)
        self.label?.text = "卫星图"
        self.label?.font = UIFont.systemFont(ofSize: 10)
        self.label?.textColor = UIColor.orange
        
        self.typeSwitch?.frame = CGRect(x: ScreenSize.width-50, y: 50, width: 40, height: 20)
        //开关无法设置大小，只能设置缩放
        self.typeSwitch?.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        //设置开启状态显示的颜色
        self.typeSwitch?.onTintColor = UIColor.orange
        //设置关闭状态的颜色
        self.typeSwitch?.tintColor = UIColor.orange
        self.typeSwitch?.addTarget(self, action: #selector(switchDidChange), for: .valueChanged)
//        self.button1?.frame = CGRect(x: ScreenSize.width-92, y: 40, width: 40, height: 20)
//        self.button1?.setTitle("地图", for: .normal)
//        self.button1?.setTitleColor(UIColor.white, for: .normal)
//        self.button1?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
//        self.button1?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        self.button1?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        self.button1?.isSelected = true
//        self.button1?.addTarget(self, action: #selector(mapchange(sender:)), for: .touchUpInside)
//        self.selector = self.button1
//
//        self.button2?.frame = CGRect(x: ScreenSize.width-50, y: 40, width: 40, height: 20)
//        self.button2?.setTitle("卫星", for: .normal)
//        self.button2?.setTitleColor(UIColor.white, for: .normal)
//        self.button2?.setTitleColor(UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1), for: .selected)
//        self.button2?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        self.button2?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        self.button2?.addTarget(self, action: #selector(mapchange(sender:)), for: .touchUpInside)
        
        //隐藏百度logo
        let mView = self.mapView?.subviews.first
        for logoView in mView!.subviews {
            if logoView is UIImageView {
                let b_logo = logoView as? UIImageView
                b_logo?.isHidden = true
            }
        }
        
    }
    @objc func switchDidChange(sender: UISwitch){
        if sender.isOn {
            self.mapView?.mapType = .satellite
        } else {
            self.mapView?.mapType = .standard
        }
    }
//    @objc func mapchange(sender: UIButton){
//        if  self.selector?.isSelected == true{
//            self.selector?.isSelected = false
//        }
//        sender.isSelected = true
//        self.selector = sender
//        if self.button1?.isSelected == true {
//            self.mapView?.mapType = .standard
//        }else{
//            self.mapView?.mapType = .satellite
//        }
//    }
}
