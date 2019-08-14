//
//  ZFJVoiceBubble.swift
//  ZFJVoiceDemo
//
//  Created by ZFJ on 2017/5/19.
//  Copyright © 2017年 ZFJ. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

protocol ZFJVoiceBubbleDelegate: NSObjectProtocol {
    func voiceBubbleDidStartPlaying(_ voiceBubble: ZFJVoiceBubble)
    func voiceBubbleStratOrStop(_ voiceBubble: ZFJVoiceBubble, _ isStart: Bool)
}

public let ScreenHeight = UIScreen.main.bounds.size.height
public let ScreenWidth = UIScreen.main.bounds.size.width
let KhornImgViewWID : CGFloat = 10.0  //小喇叭的宽度
let KhornImgViewHEI : CGFloat = 13.0  //小喇叭的高度
let KZFJVoiceSpace : CGFloat = 8.0    //控件之间的距离
let KTimeLabWID : CGFloat = 25.0      //显示时间lab的宽度
let KBarDownView : CGFloat = 36.0     //头部视图的高度
let kDelayTime : CGFloat = 0.5        //动画时间

class ZFJVoiceBubble: UIView,AVAudioPlayerDelegate {
    weak var delegate: ZFJVoiceBubbleDelegate?
    
    var player: AVAudioPlayer!
    var asset: AVURLAsset!
    var animationImages = [Any]()
    private var myTimer: Timer?
    
    //进度条
    lazy var progressBar: UIView = {
        let pesBar = UIView()
        pesBar.backgroundColor = UIColor(red: 0.008, green: 0.976, blue: 0.196, alpha: 1.00)
        pesBar.frame = CGRect(x: 0, y: KBarDownView - 2, width: 0, height: CGFloat(2))
        return pesBar
        
    }()
    
    lazy var barTitleLab: UILabel = {
        let titleLab = UILabel()
        titleLab.font = UIFont(name: "STHeitiSC-Light", size: 14)
        titleLab.textColor = UIColor(red: 0.247, green: 0.773, blue: 0.071, alpha: 1.00)
        return titleLab
        
    }()
    
    lazy var barTitleImg: UIImageView = {
        let titleImg = UIImageView()
        titleImg.image = UIImage.init(named: "fs_icon_wave_2")
        return titleImg
    }()
    
    lazy var hornImgView: UIImageView = {
        let hornImg = UIImageView()
        hornImg.image = UIImage.init(named: "ZFJHornImg")
        return hornImg
    }()
    
    //显示时间lab
    lazy var timeLab: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textAlignment = .right
        timeLabel.font = UIFont(name: "STHeitiSC-Light", size: 14)
        timeLabel.textColor = UIColor.orange
        timeLabel.text = "0\""
        return timeLabel
    }()
    
    lazy var contentButton: UIButton  = {
        var button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "speechbar"), for: .normal)
//        button.backgroundColor = UIColor(red: CGFloat(0.949), green: CGFloat(1.000), blue: CGFloat(0.914), alpha: CGFloat(1.00))
        button.addTarget(self, action: #selector(self.voiceClicked), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(12))
        button.adjustsImageWhenHighlighted = true
        button.imageView?.animationDuration = 2.0
        button.imageView?.animationRepeatCount = 30
        button.imageView?.clipsToBounds = false
        button.imageView?.contentMode = .center
        button.contentHorizontalAlignment = .right
//        button.layer.borderColor = UIColor(red: CGFloat(0.831), green: CGFloat(0.957), blue: CGFloat(0.788), alpha: CGFloat(1.00)).cgColor
//        button.layer.borderWidth = 0.5
//        button.layer.masksToBounds = true
        button.setImage(UIImage.init(named: "fs_icon_wave_2"), for: .normal)
        return button
    }()
    //---------------------set方法---------------------
    // MARK: - 语音播放的地址
    var contentURL: URL!{
        didSet{
            if self.player != nil && self.player.isPlaying {
                stop()
            }
            self.contentButton.isEnabled = false
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                self.asset = AVURLAsset(url: self.contentURL, options: [AVURLAssetPreferPreciseDurationAndTimingKey: true])
                let duration: CMTime = self.asset.duration
                let seconds: Int = Int(CMTimeGetSeconds(duration))
                if seconds > 60 {
                    print("A voice audio should't last longer than 60 seconds")
                    self.contentURL = nil
                    self.asset = nil
                    return
                }
                do {
                    let data = try Data(contentsOf: self.contentURL)
                    self.player = try AVAudioPlayer(data: data)
                    self.player.delegate = self
                }catch {
                    print("出现异常:%@",error)
                    return
                }
                self.player.prepareToPlay()
                DispatchQueue.main.async(execute: {() -> Void in
                    self.timeLab.text = "\(seconds)\""
                    self.contentButton.isEnabled = true
                    self.setNeedsLayout()
                })
            })
        }
    }
    
    // MARK: - 有没有navigationBar
//    var isHaveBar: Bool{
//        didSet{
//            self.setNeedsLayout()
//        }
//    }
    // MARK: - 是有显示左边的图标 小喇叭
    var isShowLeftImg: Bool{
        didSet{
            self.setNeedsLayout()
        }
    }
    
    // MARK: - 是否翻转显示
    var isInvert: Bool{
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override init(frame:CGRect) {
//        userName = ""
        isInvert = false
//        isHaveBar = false
        isShowLeftImg = false
        super.init(frame: frame)
        initialize()
    }
    
    func initialize() {
        clipsToBounds = false
        
        self.hornImgView.isHidden = !isShowLeftImg
        addSubview(self.hornImgView)
        
        self.contentButton.layer.cornerRadius = frame.size.height / 2
        addSubview(self.contentButton)
        
        addSubview(self.timeLab)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //头部视图
//        self.barDownView.frame = isHaveBar ? CGRect(x: CGFloat(0), y: CGFloat(64), width: CGFloat(ScreenWidth), height: CGFloat(KBarDownView)) : CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(ScreenWidth), height: CGFloat(KBarDownView))
        //左边语言图标
        let hornImgViewWID: CGFloat = CGFloat(isShowLeftImg ? KhornImgViewWID : 0.0)
        self.hornImgView.isHidden = !isShowLeftImg
        self.hornImgView.frame = CGRect(x: CGFloat(0), y: CGFloat((frame.size.height - KhornImgViewHEI) / 2.0), width: hornImgViewWID, height: CGFloat(KhornImgViewHEI))
        //时间
        self.timeLab.frame = CGRect(x: CGFloat(frame.size.width - KTimeLabWID), y: CGFloat(0), width: CGFloat(KTimeLabWID), height: CGFloat(frame.size.height))
        //语言按钮
        let voiceBtnWID: CGFloat = frame.size.width - hornImgViewWID - KZFJVoiceSpace - KTimeLabWID
        self.contentButton.frame = CGRect(x: CGFloat(self.hornImgView.frame.maxX + KZFJVoiceSpace), y: CGFloat(0), width: voiceBtnWID, height: CGFloat(frame.size.height))
        self.contentButton.layer.cornerRadius = frame.size.height / 2
        if (self.timeLab.text?.characters.count)! > 0 {
            self.contentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -voiceBtnWID + 50, bottom: 0, right: voiceBtnWID - 50 + 25)
            let textPadding: Int = isInvert ? 2 : 4
            self.contentButton.titleEdgeInsets = UIEdgeInsets(top: frame.size.height, left: CGFloat(textPadding), bottom: frame.size.height, right: -(CGFloat)(textPadding))
            layer.transform = isInvert ? CATransform3DMakeRotation(.pi, 0, 1.0, 0) : CATransform3DIdentity
            self.contentButton.titleLabel?.layer.transform = isInvert ? CATransform3DMakeRotation(.pi, 0.0, 1.0, 0.0) : CATransform3DIdentity
            self.timeLab.layer.transform = isInvert ? CATransform3DMakeRotation(.pi, 0.0, 1.0, 0.0) : CATransform3DIdentity
            self.timeLab.textAlignment = isInvert ? .left : .right
        }
    }
    
    // MARK: - Target Action
    @objc func voiceClicked(_ sender: Any) {
        if player!.isPlaying && (self.contentButton.imageView!.isAnimating) {
            stop()
        }else {
            play()
            delegate?.voiceBubbleDidStartPlaying(self)
        }
    }
    
    // MARK: - 开始定时器
    func startTimer() {
        if myTimer != nil && (myTimer?.isValid)! {
            myTimer?.invalidate()
            myTimer = nil
        }
        myTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.playProgress), userInfo: nil, repeats: true)
    }
    // MARK: - 结束定时器
    func setopTimer() {
        myTimer?.invalidate()
        myTimer = nil
    }
    
    // MARK: - 播放进度条
    @objc func playProgress() {
        let progress: CGFloat = CGFloat(player!.currentTime / player!.duration)
        var frame: CGRect = self.progressBar.frame
        frame.size.width = progress * ScreenWidth
        self.progressBar.frame = frame
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("播放出现异常:%@",error as Any)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopAnimating()
    }
    
    // MARK: - Public
    func startAnimating(){
        let session:AVAudioSession = AVAudioSession.sharedInstance()
//        try! session.setCategory(AVAudioSession.Category.playback)
        try! session.setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
        delegate?.voiceBubbleStratOrStop(self,true)
        //添加头部视图
//        UIApplication.shared.keyWindow?.addSubview(self.barDownView)
        //启动定时器
        startTimer()
        justStartAnimating()
    }
    // MARK: - 开始动画
    func justStartAnimating(){
        let image0: UIImage! = UIImage.init(named: "fs_icon_wave_0")
        let image1: UIImage! = UIImage.init(named: "fs_icon_wave_1")
        let image2: UIImage! = UIImage.init(named: "fs_icon_wave_2")
        let animationImages: [UIImage] = [image0, image1, image2]
        if !(self.contentButton.imageView?.isAnimating)! {
            self.contentButton.imageView?.animationImages = animationImages
            self.contentButton.imageView?.animationDuration = 3.0 * 0.7
            self.contentButton.imageView?.startAnimating()
        }
        if !self.barTitleImg.isAnimating {
            self.barTitleImg.animationImages = animationImages
            self.barTitleImg.animationDuration = 3.0 * 0.7
            self.barTitleImg.startAnimating()
        }
    }
    // MARK: - 停止动画
    func stopAnimating(){
        delegate?.voiceBubbleStratOrStop(self,false)
        //移除头部视图
//        self.barDownView.removeFromSuperview()
        //停止定时器
        startTimer()
        if (contentButton.imageView?.isAnimating)! {
            contentButton.imageView?.stopAnimating()
        }
        if (self.barTitleImg.isAnimating) {
            self.barTitleImg.stopAnimating()
        }
    }
    
    func play() {
        if !(self.contentURL != nil) {
            print("没有设置URL")
            return
        }
        
        if !player.isPlaying{
            player.play()
            startAnimating()
        }
        
        //        if !(player?.isPlaying)! {
        //            player?.play()
        //            startAnimating()
        //        }
    }
    
    func pause() {
        if player != nil &&  player.isPlaying {
            player.pause()
            stopAnimating()
        }
    }
    
    func stop() {
        if player != nil && player.isPlaying {
            player.stop()
            player.currentTime = 0
            stopAnimating()
        }
    }
    
    // MARK: - 动态计算宽高
    //NSLineBreakByCharWrapping
    func dynamicHeight(_ str: String, width: CGFloat, height: CGFloat, font: UIFont) -> CGRect {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.byCharWrapping
        let dict: [AnyHashable: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]
        let opts: NSStringDrawingOptions = [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading]
        let rect: CGRect = str.boundingRect(with: CGSize(width: width, height: height), options: opts, attributes: dict as? [NSAttributedString.Key : Any], context: nil)
        return rect
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
