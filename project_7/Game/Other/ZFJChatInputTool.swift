//
//  ZFJChatInputTool.swift
//  ZFJVoiceDemo
//
//  Created by ZFJ on 2017/5/19.
//  Copyright © 2017年 ZFJ. All rights reserved.
//

import UIKit
import AVFoundation

let KZFJChatInputTool_HEI : CGFloat = 49
let KZFJChatInputTool_Space : CGFloat = 10  //控件距离两边的距离
let KBothSidesBtn_WID : CGFloat = 36        //左右两边按钮的宽高
let KCallViewWID : CGFloat = 166

typealias sendOutBtnClick = (_ voiceUrl: URL) -> Void

class ZFJChatInputTool: UIView {
    var sendURLAction: sendOutBtnClick?

    //录音存放的路径
    var recordUrl: URL!

    //语音界面
    lazy var recordingView: UIView = {
        let redView = UIView()
        redView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(ScreenWidth), height: CGFloat(KZFJChatInputTool_HEI))
        redView.backgroundColor = UIColor.clear
        redView.isUserInteractionEnabled = true
        return redView
    }()

    var recorder: AVAudioRecorder!
    var voiceShowLab: UILabel = {
        let voiceLab = UILabel()
        voiceLab.textAlignment = .center
        voiceLab.font = UIFont(name: "STHeitiSC-Light", size: CGFloat(14))
        voiceLab.text = "手指上滑,取消发送"
        voiceLab.textColor = UIColor.white
        return voiceLab
    }()
    //录音状态背景图
    lazy var callView: UIView = {
        let myCallView = UIView()
        myCallView.frame = CGRect(x: -(UIScreen.main.bounds.width/2+KCallViewWID/2-70), y: -(UIScreen.main.bounds.height/2+KCallViewWID/2-70), width: KCallViewWID, height: KCallViewWID)
        myCallView.backgroundColor = UIColor(red: CGFloat(0.000), green: CGFloat(0.000), blue: CGFloat(0.000), alpha: CGFloat(0.8))
        myCallView.layer.cornerRadius = 10
        myCallView.clipsToBounds = true
        return myCallView
    }()
    //麦克风图标
    var imgView: UIImageView = {
        let myImgView = UIImageView()
        myImgView.image = UIImage(named: "ZFJMicrophoneIcon")
        myImgView.contentMode = .scaleAspectFill
        return myImgView
    }()
    
    lazy var myMaskView: UIView = {
        let myMask = UIView()
        myMask.backgroundColor = UIColor.red
        return myMask
    }()
    
    //音节状态
    lazy var yinjieBtn: UIImageView = {
        let yinBtn = UIImageView()
        yinBtn.image = UIImage(named: "ZFJVolumeIcon")
        return yinBtn
    }()
    
    var timer: Timer?
    var tempPoint = CGPoint.zero
    var endState: Int = 0
    
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        initUI()
    }
    // MARK: - 初始化UI
    func initUI(){
        //录音相关
        setRecordingAbout()
    }
    
    // MARK: - 以下是录音相关
    func setRecordingAbout(){
        endState = 1
        //初始化录音器
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        //设置录音类型
//        try! session.setCategory(AVAudioSession.Category.playback)
        try! session.setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
        //首先要判断是否允许访问麦克风
        var isAllowed = false
        session.requestRecordPermission { (allowed) in
            if !allowed{
                let alertView = UIAlertView(title: "无法访问您的麦克风" , message: "请到设置 -> 隐私 -> 麦克风 ，打开访问权限", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "好的")
                alertView.show()
                isAllowed = false
            }else{
                isAllowed = true
            }
        }
        if isAllowed == false{
            return //如果没有访问权限 返回
        }
        
        let recorderSeetingsDic = [
            AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32), //aac格式
//            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),// acf格式
            AVSampleRateKey : 11025.0, //录音器每秒采集的录音样本数
            //AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 2, //录音的声道数，立体声为双声道
            AVLinearPCMBitDepthKey : 16,
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue
            ] as [String : Any]
        
        //语音地址
//        self.recordUrl = URL(string: NSTemporaryDirectory() + ("\(getTheTimestamp()).acf"))
        self.recordUrl = URL(string: NSTemporaryDirectory() + ("\(getTheTimestamp()).aac"))
        
        recorder = try! AVAudioRecorder(url: self.recordUrl, settings: recorderSeetingsDic)
        if recorder == nil {
            return
        }
        
        //开启仪表计数功能
        recorder?.isMeteringEnabled = true
        //语音相关控件
        addSubview(self.recordingView)
        self.recordingView.isHidden = false
        
        let underPressView = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
//        underPressView.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5)
        underPressView.setImage(UIImage(named: "speech.png"), for: .normal)
//        underPressView.backgroundColor = UIColor.red
        underPressView.layer.cornerRadius = underPressView.frame.width/2
        self.recordingView.addSubview(underPressView)
        
        let presss = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        underPressView.addGestureRecognizer(presss)
        
        //录音状态背景图
        addSubview(self.callView)
        self.callView.isHidden = true
        
        self.voiceShowLab.frame = CGRect(x: CGFloat(0), y: CGFloat(KCallViewWID - 40), width: CGFloat(KCallViewWID), height: CGFloat(40))
        self.callView.addSubview(self.voiceShowLab)
        
        self.imgView.frame = CGRect(x: CGFloat((KCallViewWID - 30) / 2), y: CGFloat((KCallViewWID - 90) / 2), width: CGFloat(30), height: CGFloat(70))
        self.callView.addSubview(self.imgView)
        
        self.yinjieBtn.frame = CGRect(x: CGFloat(self.imgView.frame.maxX + 10), y: CGFloat((KCallViewWID - 40 - 20) / 2 + 15), width: CGFloat(20), height: CGFloat(40))
        self.callView.addSubview(self.yinjieBtn)
        
        self.myMaskView.frame = CGRect(x: CGFloat(self.imgView.frame.maxX + 10), y: CGFloat((KCallViewWID - 40 - 20) / 2 + 15), width: CGFloat(20), height: CGFloat(0))
        self.callView.addSubview(self.myMaskView)
    }
    // MARK: - 长按开始录音 手势判断
    @objc func longPress(_ press: UILongPressGestureRecognizer) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
//        try! session.setCategory(AVAudioSession.Category.playAndRecord)
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: [])
        if(press.state == UIGestureRecognizer.State.began){
            self.callView.isHidden = false
            recorder!.prepareToRecord()//准备录音
            recorder!.record()//开始录音
            //启动定时器，定时更新录音音量
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                              selector: #selector(changeImage),
                                              userInfo: nil, repeats: true)
        }else if(press.state == UIGestureRecognizer.State.changed){
            //录音正在进行
            let point: CGPoint = press.location(in: self)
            if point.y < tempPoint.y - 10 {
                endState = 0
                self.yinjieBtn.isHidden = true
                self.voiceShowLab.text = "松开手指,取消发送"
                self.imgView.image = UIImage(named: "ZFJRevokeIcon")
                if !point.equalTo(tempPoint) && point.y < tempPoint.y - 8 {
                    tempPoint = point
                }
            }
            else if point.y > tempPoint.y + 10 {
                endState = 1
                self.yinjieBtn.isHidden = false
                self.voiceShowLab.text = "手指上滑,取消发送"
                self.imgView.image = UIImage(named: "ZFJMicrophoneIcon")
                if !point.equalTo(tempPoint) && point.y > tempPoint.y + 8 {
                    tempPoint = point
                }
            }
        }else{
            //取消或者结束录音
            self.callView.isHidden = true
            recorder?.stop()
            //recorder = nil
            timer?.invalidate()
            timer = nil
            endPress()
        }
    }
    // MARK: - 结束录音
    func endPress(){
        let session:AVAudioSession = AVAudioSession.sharedInstance()
//        try! session.setCategory(AVAudioSession.Category.playback)
        try! session.setCategory(AVAudioSession.Category.playback, mode: .default, options: [])

        if(endState == 0){
            //取消发送
            endState = 1
            self.yinjieBtn.isHidden = false
            self.voiceShowLab.text = "手指上滑,取消发送"
            self.imgView.image = UIImage(named: "ZFJMicrophoneIcon")
        }else if(endState == 1){
            self.sendURLAction!(self.recordUrl)
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "noti"), object: "\(getTheTimestamp()).caf", userInfo: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 改变现实的图片
    @objc func changeImage() {
        recorder!.updateMeters() // 刷新音量数据
        var avg: Float = recorder!.averagePower(forChannel: 0) //获取音量的平均值
        let minValue: Float = -30
        let range: Float = 30
        let outRange: Float = 100
        if avg < minValue {
            avg = minValue
        }
        let decibels: CGFloat = CGFloat((avg + range) / range * outRange)
        let maskViewY = CGFloat(self.yinjieBtn.frame.size.height - decibels * self.yinjieBtn.frame.size.height / 100.0)
        
        self.myMaskView.layer.frame = CGRect(x: CGFloat(0), y: maskViewY, width: CGFloat(yinjieBtn.frame.size.width), height: CGFloat(yinjieBtn.frame.size.height))
        self.yinjieBtn.layer.mask = self.myMaskView.layer
    }
    
    // MARK: - 获取时间戳
    func getTheTimestamp() -> String {
        let dat = Date(timeIntervalSinceNow: 0)
        let a: TimeInterval = dat.timeIntervalSince1970
        //  *1000 是精确到毫秒，不乘就是精确到秒
        let timeString = String(format: "%.0f", a)
        //转为字符型
        return timeString
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
