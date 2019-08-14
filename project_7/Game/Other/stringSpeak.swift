import AVFoundation
//语音控件
func stringSpeak(voiceString: String) {
    let av = AVSpeechSynthesizer.init()
    let stringSpeak = AVSpeechUtterance.init(string: voiceString)
    let audioSession = AVAudioSession.sharedInstance()
    do {
        try audioSession.setCategory(AVAudioSession.Category.playback)
    }catch let error as NSError{
        print(error.code)
    }
    stringSpeak.postUtteranceDelay = 0.5  //语音合成器在当前语音结束之后处理下一个排队的语音之前需要等待的时间
    stringSpeak.rate = 0.55   //设置语速
    stringSpeak.voice = AVSpeechSynthesisVoice(language: "zh-CN")   //设置语言
    stringSpeak.volume = 1  //设置音量
    stringSpeak.pitchMultiplier = 1  //设置说话的基线音高
    av.speak(stringSpeak)
}
