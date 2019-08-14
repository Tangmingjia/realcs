import AVFoundation
func playAudio(audioName: String, isAlert: Bool = false, completion: (() -> ())? = nil){
    
    var SoundID: SystemSoundID = 0
    //根据某个音频文件给SoundID进行赋值
    guard let fileURL = Bundle.main.url(forResource: audioName, withExtension: nil) else { return }
    AudioServicesCreateSystemSoundID(fileURL as CFURL, &SoundID)
    // 二. 开始播放
    if isAlert {
        // 3. 带振动播放, 可以监听播放完成(模拟器不行)
        AudioServicesPlayAlertSoundWithCompletion(SoundID, completion)
    }else {
        // 3. 不带振动播放, 可以监听播放完成
        AudioServicesPlaySystemSoundWithCompletion(SoundID, completion)
    }
}
