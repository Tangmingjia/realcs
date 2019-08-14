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
        NameLabel?.frame = CGRect(x: 10, y: 0, width: 40, height: 30)
        NameLabel?.font = UIFont.systemFont(ofSize: 10)
        NameLabel?.textColor = UIColor.white
        NameLabel?.textAlignment = .left

        SpeechView?.frame = CGRect(x: 40, y: 5, width: 100, height: 20)
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
        
        ReportLabel?.frame = CGRect(x: 10, y: 0, width: 140, height: 30)
        ReportLabel?.font = UIFont.systemFont(ofSize: 10)
        ReportLabel?.textColor = UIColor.orange
        ReportLabel?.numberOfLines = 2
        ReportLabel?.lineBreakMode = .byCharWrapping
        
    }
}

class TeamTableViewCell : UITableViewCell,TeamModelDelegate{
    static let identifier = "TeamTableViewCell"
    var model: TeamModel? {
        didSet{
            TeamName?.text = model!.TeamName
            TeamIcon?.kf.setImage(with: URL(string: (model!.TeamIcon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!), placeholder: UIImage(named: "logo.png"))
            TeamBlood?.frame.size.width = CGFloat(model!.TeamBlood*160/100)
            TeamDyingBlood?.frame.size.width = CGFloat(model!.TeamDyingBlood*160/100)
            TeamArmor?.frame.size.width = CGFloat(model!.TeamArmor*135/100)
            TeamBlood_2?.frame.size.width = CGFloat(model!.TeamBlood*160/100)
            TeamDyingBlood_2?.frame.size.width = CGFloat(model!.TeamDyingBlood*160/100)
            TeamArmor_2?.frame.size.width = CGFloat(model!.TeamArmor*135/100)
            TeamStatus = model!.TeamStatus
            TeamKillView?.text = "击杀：\(model!.TeamKill)"
            TeamDamageView?.text = "伤害：\(model!.TeamDamage)"
            myStatus = model!.myStatus
            model?.delegate = self
        }
    }
    var TeamIconView : UIImageView?
    var TeamIcon : UIImageView?
    var TeamView : UIImageView?
    var TeamName : UILabel?
    var TeamDead : UILabel?
    var TeamBloodView : UIView?
    var TeamBlood_2 : UIImageView?
    var TeamBlood : UIImageView?
    var TeamDyingBlood_2 : UIImageView?
    var TeamDyingBlood : UIImageView?
    var TeamArmorView : UIView?
    var TeamArmor_2 : UIImageView?
    var TeamArmor : UIImageView?
    var TeamKillView : UILabel?
    var TeamDamageView : UILabel?
    var saveButton : UIButton?
    var TeamStatus : Int?
    var myStatus : Int?
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.TeamIconView = UIImageView()
        self.addSubview(TeamIconView!)
        
        self.TeamIcon = UIImageView()
        self.TeamIconView?.addSubview(TeamIcon!)
        
        self.TeamView = UIImageView()
        self.addSubview(TeamView!)
        
        self.TeamName = UILabel()
        self.TeamView?.addSubview(TeamName!)

        self.TeamDead = UILabel()
        self.TeamView?.addSubview(TeamDead!)
        
        self.TeamBloodView = UIView()
        self.TeamView?.addSubview(TeamBloodView!)
        
        self.TeamBlood_2 = UIImageView()
        self.TeamBloodView?.addSubview(TeamBlood_2!)
        
        self.TeamBlood = UIImageView()
        self.TeamBloodView?.addSubview(TeamBlood!)
        
        self.TeamDyingBlood_2 = UIImageView()
        self.TeamBloodView?.addSubview(TeamDyingBlood_2!)
        
        self.TeamDyingBlood = UIImageView()
        self.TeamBloodView?.addSubview(TeamDyingBlood!)
        
        self.TeamArmorView = UIView()
        self.TeamView?.addSubview(TeamArmorView!)
        
        self.TeamArmor_2 = UIImageView()
        self.TeamArmorView?.addSubview(TeamArmor_2!)
        
        self.TeamArmor = UIImageView()
        self.TeamArmorView?.addSubview(TeamArmor!)
        
        self.TeamKillView = UILabel()
        self.addSubview(TeamKillView!)
        
        self.TeamDamageView = UILabel()
        self.addSubview(TeamDamageView!)
        
        self.saveButton = UIButton()
        self.addSubview(saveButton!)
        
        setUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model?.delegate = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        TeamIconView?.frame = CGRect(x: 0, y: 5, width: 34, height: 34)
        TeamIconView?.image = UIImage(named: "headbg.png")
        TeamIconView?.isHidden = true
        
        TeamIcon?.frame = CGRect(x: 3, y: 2.5, width: 28, height: 28)
        TeamIcon?.layer.cornerRadius = (TeamIcon?.frame.width)!/2
        TeamIcon?.layer.masksToBounds = true
        TeamIcon?.contentMode = .scaleAspectFill
        
        TeamView?.frame = CGRect(x: 0, y: 5, width: 170, height: 34)
        TeamView?.image = UIImage(named: "teamview.png")
        
        TeamName?.frame = CGRect(x: 50, y: 0, width: 80, height: 10)
        TeamName?.font = UIFont.systemFont(ofSize: 9)
        TeamName?.textColor = UIColor.orange
        TeamName?.textAlignment = .left
        
        TeamDead?.frame = CGRect(x: 120, y: 0, width: 50, height: 10)
        TeamDead?.font = UIFont.systemFont(ofSize: 9)
        TeamDead?.textColor = UIColor.red
        TeamDead?.textAlignment = .left
        TeamDead?.text = "(淘汰)"
        TeamDead?.isHidden = true
        
        TeamBloodView?.frame = CGRect(x: 7, y: 13, width: 160, height: 6)
        TeamBloodView?.backgroundColor = UIColor.clear
        
        TeamBlood_2?.frame = CGRect(x: 0, y: 0, width: 160, height: 6)
        TeamBlood_2?.image = UIImage(named: "teamblood_2.png")
        TeamBlood_2?.contentMode = .left
        TeamBlood_2?.clipsToBounds = true
        
        TeamBlood?.frame = CGRect(x: 0, y: 0, width: 160, height: 6)
        animation(ImageName: "teamblood", ImageView: TeamBlood!)
        TeamBlood?.contentMode = .left
        TeamBlood?.clipsToBounds = true
        
        TeamDyingBlood_2?.frame = CGRect(x: 0, y: 0, width: 160, height: 6)
        TeamDyingBlood_2?.image = UIImage(named: "teamdyingblood_2.png")
        TeamDyingBlood_2?.contentMode = .left
        TeamDyingBlood_2?.clipsToBounds = true
        TeamDyingBlood_2?.isHidden = true
        
        TeamDyingBlood?.frame = CGRect(x: 0, y: 0, width: 160, height: 6)
        animation(ImageName: "teamdyingblood", ImageView: TeamDyingBlood!)
        TeamDyingBlood?.contentMode = .left
        TeamDyingBlood?.clipsToBounds = true
        TeamDyingBlood?.isHidden = true
        
        TeamArmorView?.frame = CGRect(x: 31, y: 22, width: 135, height: 6)
        TeamArmorView?.backgroundColor = UIColor.clear
        
        TeamArmor_2?.frame = CGRect(x: 0, y: 0, width: 135, height: 6)
        TeamArmor_2?.image = UIImage(named: "teamarmor_2.png")
        TeamArmor_2?.contentMode = .left
        TeamArmor_2?.clipsToBounds = true
        
        TeamArmor?.frame = CGRect(x: 0, y: 0, width: 135, height: 6)
        animation(ImageName: "teamarmor", ImageView: TeamArmor!)
        TeamArmor?.contentMode = .left
        TeamArmor?.clipsToBounds = true
        
        TeamKillView?.frame = CGRect(x: 40, y: 40, width: 70, height: 10)
        TeamKillView?.font = UIFont.systemFont(ofSize: 9)
        TeamKillView?.textColor = UIColor.orange
        TeamKillView?.textAlignment = .left
        TeamKillView?.isHidden = true
        
        TeamDamageView?.frame = CGRect(x: 110, y: 40, width: 70, height: 10)
        TeamDamageView?.font = UIFont.systemFont(ofSize: 9)
        TeamDamageView?.textColor = UIColor.orange
        TeamDamageView?.textAlignment = .left
        TeamDamageView?.isHidden = true
        
        saveButton?.frame = CGRect(x: 175, y: 15, width: 40, height: 20)
        saveButton?.setBackgroundImage(UIImage(named: "savebtn.png"), for: .normal)
        saveButton?.isHidden = true
        
    }
    
    func didUpdate(Model: TeamModel) {
        TeamStatus = Model.TeamStatus
        myStatus = Model.myStatus
        if TeamStatus == 1{   //正常
            TeamBlood?.isHidden = false
            TeamBlood_2?.isHidden = false
            TeamDyingBlood?.isHidden = true
            TeamDyingBlood_2?.isHidden = true
            TeamDead?.isHidden = true
            saveButton?.isHidden = true
        }
        else if TeamStatus == 3{   //濒死
            TeamBlood?.isHidden = true
            TeamBlood_2?.isHidden = true
            TeamDyingBlood?.isHidden = false
            TeamDyingBlood_2?.isHidden = false
            TeamDead?.isHidden = true
            if myStatus == 1 {
                saveButton?.isHidden = false
            }else{
                saveButton?.isHidden = true
            }
        }
        else if TeamStatus == 2{   //死亡
            TeamDead?.isHidden = false
            saveButton?.isHidden = true
        }
        TeamName?.text = Model.TeamName
        TeamIcon?.kf.setImage(with: URL(string: (Model.TeamIcon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)), placeholder: UIImage(named: "logo.png"))
        TeamBlood?.frame.size.width = CGFloat(Model.TeamBlood*160/100)
        TeamDyingBlood?.frame.size.width = CGFloat(Model.TeamDyingBlood*160/100)
        TeamArmor?.frame.size.width = CGFloat(Model.TeamArmor*135/100)
        UIView.animate(withDuration: 0.3, animations: {
            self.TeamBlood_2?.frame.size.width = CGFloat(Model.TeamBlood*160/100)
            self.TeamDyingBlood_2?.frame.size.width = CGFloat(Model.TeamDyingBlood*160/100)
            self.TeamArmor_2?.frame.size.width = CGFloat(Model.TeamArmor*135/100)
        })
        TeamKillView?.text = "击杀：\(Model.TeamKill)"
        TeamDamageView?.text = "伤害：\(Model.TeamDamage)"
    }
    
}

class BagTableViewCell : UITableViewCell{
    static let identifier = "BagTableViewCell"

    var itemView : UIView?
    
    var itemImage : UIImageView?
    
    var itemName : UILabel?
    
    var itemNum : UILabel?
    
//    var useButton : UIButton?
//    
//    var dropButton : UIButton?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.itemView = UIView()
        self.addSubview(itemView!)
        
        self.itemImage = UIImageView()
        self.itemView?.addSubview(itemImage!)
        
        self.itemName = UILabel()
        self.itemView?.addSubview(itemName!)
        
        self.itemNum = UILabel()
        self.itemView?.addSubview(itemNum!)
        
//        self.useButton = UIButton()
//        self.itemView?.addSubview(useButton!)
//
//        self.dropButton = UIButton()
//        self.itemView?.addSubview(dropButton!)
        
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.itemView?.frame = CGRect(x: 0, y: 0, width: 130, height: 60)
        self.itemView?.backgroundColor = UIColor(patternImage: UIImage(named: "itembg.png")!)
        
        self.itemImage?.frame = CGRect(x: 5, y: 5, width: 60, height: 40)
        self.itemImage?.contentMode = .scaleAspectFill
        
        self.itemName?.frame = CGRect(x: 70, y: 5, width: 60, height: 20)
        self.itemName?.textColor = UIColor.white
        self.itemName?.textAlignment = .left
        self.itemName?.font = UIFont.systemFont(ofSize: 9)
        
        self.itemNum?.frame = CGRect(x: 70, y: 25, width: 60, height: 20)
        self.itemNum?.textColor = UIColor.white
        self.itemNum?.textAlignment = .left
        self.itemNum?.font = UIFont.systemFont(ofSize: 9)
        
//        self.useButton?.frame = CGRect(x: 50, y: 20, width: 70, height: 20)
//        self.useButton?.setTitle("使用", for: .normal)
//        self.useButton?.setTitleColor(UIColor.white, for: .normal)
//        self.useButton?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        self.useButton?.backgroundColor = UIColor.black
//        self.useButton?.layer.borderColor = UIColor.white.cgColor
//        self.useButton?.layer.borderWidth = 1
//        self.useButton?.isHidden = true
//        
//        self.dropButton?.frame = CGRect(x: 50, y: 40, width: 70, height: 20)
//        self.dropButton?.setTitle("丢弃", for: .normal)
//        self.dropButton?.setTitleColor(UIColor.white, for: .normal)
//        self.dropButton?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
//        self.dropButton?.backgroundColor = UIColor.black
//        self.dropButton?.layer.borderColor = UIColor.white.cgColor
//        self.dropButton?.layer.borderWidth = 1
//        self.dropButton?.isHidden = true
    }
}

class NearTableViewCell : UITableViewCell{
    static let identifier = "NearTableViewCell"
    
    var itemView : UIView?
    
    var itemImage : UIImageView?
    
    var itemName : UILabel?
    
    var itemNum : UILabel?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.itemView = UIView()
        self.addSubview(itemView!)
        
        self.itemImage = UIImageView()
        self.itemView?.addSubview(itemImage!)
        
        self.itemName = UILabel()
        self.itemView?.addSubview(itemName!)
        
        self.itemNum = UILabel()
        self.itemView?.addSubview(itemNum!)
        
        setUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        self.itemView?.frame = CGRect(x: 0, y: 0, width: 130, height: 60)
        self.itemView?.backgroundColor = UIColor(patternImage: UIImage(named: "itembg.png")!)
        
        self.itemImage?.frame = CGRect(x: 5, y: 5, width: 60, height: 40)
//        self.itemImage?.contentMode = .scaleAspectFill
        
        self.itemName?.frame = CGRect(x: 70, y: 5, width: 60, height: 20)
        self.itemName?.textColor = UIColor.white
        self.itemName?.textAlignment = .left
        self.itemName?.font = UIFont.systemFont(ofSize: 9)
        
        self.itemNum?.frame = CGRect(x: 70, y: 25, width: 60, height: 20)
        self.itemNum?.textColor = UIColor.white
        self.itemNum?.textAlignment = .left
        self.itemNum?.font = UIFont.systemFont(ofSize: 9)
    }
}

class battleResultsTableViewCell : UITableViewCell{
    
    var IconView : UIImageView?
    
    var Icon : UIImageView?
    
    var Name : UILabel?
    
    var Damage : UILabel?
    
    var Kill : UILabel?
    
    var Survival : UILabel?
    
    var dead : UILabel?
    
    override init(style: UITableViewCell.CellStyle,reuseIdentifier: String?){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        self.IconView = UIImageView()
        self.addSubview(IconView!)
        
        self.Icon = UIImageView()
        self.IconView?.addSubview(Icon!)
        
        self.Name = UILabel()
        self.addSubview(Name!)
        
        self.Damage = UILabel()
        self.addSubview(Damage!)
        
        self.Kill = UILabel()
        self.addSubview(Kill!)
        
        self.Survival = UILabel()
        self.addSubview(Survival!)
        
        self.dead = UILabel()
        self.addSubview(dead!)
        
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(){
        
        self.IconView?.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        self.IconView?.image = UIImage(named: "zhanbao_head.png")
        self.IconView?.contentMode = .scaleAspectFill
        
        self.Icon?.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        self.Icon?.layer.cornerRadius = (self.Icon?.frame.width)!/2
        self.Icon?.layer.masksToBounds = true
        self.Icon?.contentMode = .scaleAspectFill
        
        self.Name?.frame = CGRect(x: 45, y: 13, width: 80, height: 20)
        self.Name?.textColor = UIColor.white
        self.Name?.font = UIFont.systemFont(ofSize: 14)
        self.Name?.textAlignment = .center
        
        self.Damage?.frame = CGRect(x: 155, y: 13, width: 80, height: 20)
        self.Damage?.textColor = UIColor.white
        self.Damage?.font = UIFont.systemFont(ofSize: 14)
        self.Damage?.textAlignment = .center
        
        self.Kill?.frame = CGRect(x: 280, y: 13, width: 80, height: 20)
        self.Kill?.textColor = UIColor.white
        self.Kill?.font = UIFont.systemFont(ofSize: 14)
        self.Kill?.textAlignment = .center
        
        self.Survival?.frame = CGRect(x: 415, y: 13, width: 80, height: 20)
        self.Survival?.textColor = UIColor.white
        self.Survival?.font = UIFont.systemFont(ofSize: 14)
        self.Survival?.textAlignment = .center
        
        self.dead?.frame = CGRect(x: 415, y: 13, width: 80, height: 20)
        self.dead?.textColor = UIColor.white
        self.dead?.font = UIFont.systemFont(ofSize: 14)
        self.dead?.textAlignment = .center
    }
}
