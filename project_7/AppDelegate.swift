//
//  AppDelegate.swift
//  project_7
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
public let ScreenSize = UIScreen.main.bounds.size
public let appid = "wxefa108f8e01af35b"
public let secret = "55b9152ef2315e4ba4485cb9fb1f3188"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,BMKGeneralDelegate, WXApiDelegate{
    var mapManager: BMKMapManager?
    var window: UIWindow?
    
    //当前界面支持的方向（默认情况下只能横屏，不能竖屏显示）
    var interfaceOrientations:UIInterfaceOrientationMask = [.landscapeRight]
    {
        didSet{
//            print(UIDevice.current.orientation.isLandscape)
            //强制设置成竖屏
            if interfaceOrientations.contains(.portrait){
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                          forKey: "orientation")
            }
            //强制设置成横屏
            else {
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue,
                                          forKey: "orientation")
            }
        }
    }
    
    //返回当前界面支持的旋转方向
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor
        window: UIWindow?)-> UIInterfaceOrientationMask {
        return interfaceOrientations
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        if #available(iOS 11.0, *) {
//            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
//        }

        UIApplication.shared.isIdleTimerDisabled = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        self.window?.backgroundColor = UIColor.black
        self.window?.makeKeyAndVisible()
        //记录开关状态
        UserDefaults.standard.set(true, forKey: "switchState")
        mapManager = BMKMapManager()
        mapManager?.start("8vOxkjPGbmRL6TciLGvvL2MGRqZYToYH",generalDelegate: self)
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
//        let ret = mapManager?.start("8vOxkjPGbmRL6TciLGvvL2MGRqZYToYH",generalDelegate: self)
//        if ret == false {
//            print("manager start failed!")
//        }
        //MARK: -注册微信
        WXApi.registerApp("\(appid)")
        return true
    }
    //  微信跳转回调
    // 这个方法是用于从微信返回第三方App 处理微信通过URL启动App时传递的数据
    // @param url 微信启动第三方应用时传递过来的URL
    // @param delegate WXApiDelegate对象，用来接收微信触发的消息。
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if url.scheme == "\(appid)" {
            WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
    func application(application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme == "\(appid)" {
            WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    
    func application(app: UIApplication, openURL url: URL, options: [String : AnyObject]) -> Bool {
//        print("openURL:\(url.absoluteString)")
        if url.scheme == "\(appid)" {
            return WXApi.handleOpen(url, delegate: self)
        }
        return true
    }
    //  微信回调
    func onResp(_ resp: BaseResp){
        //  微信登录回调
        if resp.errCode == 0 && resp.type == 0{//授权成功
            let response = resp as! SendAuthResp
            //  微信登录成功通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
