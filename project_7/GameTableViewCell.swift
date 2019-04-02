import UIKit
class GameTableViewCell1 : UITableViewCell{
    
    var NameLabel : UILabel?
    
    var SpeechView : ZFJVoiceBubble?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.NameLabel = UILabel()
        self.addSubview(NameLabel!)
        
        self.SpeechView = ZFJVoiceBubble.init()
        self.addSubview(SpeechView!)

        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        NameLabel?.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        NameLabel?.font = UIFont.systemFont(ofSize: 10)
        NameLabel?.textColor = UIColor.white
        NameLabel?.textAlignment = .left

        SpeechView?.frame = CGRect(x: 40, y: 5, width: 110, height: 20)
//        SpeechView?.isShowLeftImg = true
        SpeechView?.tag = 99
    }
}


class GameTableViewCell2 : UITableViewCell{
    
    var ReportLabel : UILabel?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.ReportLabel = UILabel()
        self.addSubview(ReportLabel!)
        
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        ReportLabel?.frame = CGRect(x: 0, y: 0, width: 150, height: 10)
        ReportLabel?.font = UIFont.systemFont(ofSize: 10)
        ReportLabel?.textColor = UIColor.orange
        
    }
}
