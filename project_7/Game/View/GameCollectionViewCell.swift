import UIKit

class GameCollectionViewCell: UICollectionViewCell,TeamModelDelegate {

    var model: TeamModel? {
        didSet{
            TeamBlood?.frame.size.width = CGFloat(model!.TeamBlood*115/100)
            TeamDyingBlood?.frame.size.width = CGFloat(model!.TeamDyingBlood*115/100)
            TeamArmor?.frame.size.width = CGFloat(model!.TeamArmor*100/100)
            TeamBlood_2?.frame.size.width = CGFloat(model!.TeamBlood*115/100)
            TeamDyingBlood_2?.frame.size.width = CGFloat(model!.TeamDyingBlood*115/100)
            TeamArmor_2?.frame.size.width = CGFloat(model!.TeamArmor*100/100)
            TeamStatus = model?.TeamStatus
            myStatus = model?.myStatus
            TeamName?.text = model!.TeamName
            TeamIcon?.kf.setImage(with: URL(string: (model!.TeamIcon.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)), placeholder: UIImage(named: "logo.png"))
            TeamKillView?.text = "击杀：\(model!.TeamKill)"
            TeamDamageView?.text = "伤害：\(model!.TeamDamage)"
            model?.delegate = self
        }
    }
    var TeamView : UIImageView?
    var TeamIconView : UIImageView?
    var TeamIcon : UIImageView?
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.TeamView = UIImageView()
        self.addSubview(TeamView!)
        
        self.TeamIconView = UIImageView()
        self.addSubview(TeamIconView!)
        
        self.TeamIcon = UIImageView()
        self.TeamIconView?.addSubview(TeamIcon!)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        model?.delegate = nil
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUI(){
        
        TeamIconView?.frame = CGRect(x: 0, y: 10, width: 30, height: 30)
        TeamIconView?.image = UIImage(named: "headbg.png")
        TeamIconView?.contentMode = .scaleAspectFill
        
        TeamIcon?.frame = CGRect(x: 2, y: 1.5, width: 26, height: 26)
        TeamIcon?.layer.cornerRadius = (TeamIcon?.frame.width)!/2
        TeamIcon?.layer.masksToBounds = true
        TeamIcon?.contentMode = .scaleAspectFill
        
        TeamView?.frame = CGRect(x: 30, y: 10, width: 130, height: 30)
        TeamView?.image = UIImage(named: "teamview.png")
        
        TeamName?.frame = CGRect(x: 40, y: 0, width: 50, height: 10)
        TeamName?.font = UIFont.systemFont(ofSize: 9)
        TeamName?.textColor = UIColor.orange
        TeamName?.textAlignment = .left
        
        TeamDead?.frame = CGRect(x: 100, y: 0, width: 50, height: 10)
        TeamDead?.font = UIFont.systemFont(ofSize: 9)
        TeamDead?.textColor = UIColor.red
        TeamDead?.textAlignment = .left
        TeamDead?.text = "(淘汰)"
        TeamDead?.isHidden = true
        
        TeamBloodView?.frame = CGRect(x: 7, y: 13, width: 115, height: 5)
        TeamBloodView?.backgroundColor = UIColor.clear
        
        TeamBlood_2?.frame = CGRect(x: 0, y: 0, width: 115, height: 5)
        TeamBlood_2?.image = UIImage(named: "teamblood_2.png")
        TeamBlood_2?.contentMode = .left
        TeamBlood_2?.clipsToBounds = true
        
        TeamBlood?.frame = CGRect(x: 0, y: 0, width: 115, height: 5)
        animation(ImageName: "teamblood", ImageView: TeamBlood!)
        TeamBlood?.contentMode = .left
        TeamBlood?.clipsToBounds = true
        
        TeamDyingBlood_2?.frame = CGRect(x: 0, y: 0, width: 115, height: 5)
        TeamDyingBlood_2?.image = UIImage(named: "teamdyingblood_2.png")
        TeamDyingBlood_2?.contentMode = .left
        TeamDyingBlood_2?.clipsToBounds = true
        TeamDyingBlood_2?.isHidden = true
        
        TeamDyingBlood?.frame = CGRect(x: 0, y: 0, width: 115, height: 5)
        animation(ImageName: "teamdyingblood", ImageView: TeamDyingBlood!)
        TeamDyingBlood?.contentMode = .left
        TeamDyingBlood?.clipsToBounds = true
        TeamDyingBlood?.isHidden = true
        
        TeamArmorView?.frame = CGRect(x: 22, y: 20, width: 100, height: 5)
        TeamArmorView?.backgroundColor = UIColor.clear
        
        TeamArmor_2?.frame = CGRect(x: 0, y: 0, width: 100, height: 5)
        TeamArmor_2?.image = UIImage(named: "teamarmor_2.png")
        TeamArmor_2?.contentMode = .left
        TeamArmor_2?.clipsToBounds = true
        
        TeamArmor?.frame = CGRect(x: 0, y: 0, width: 100, height: 5)
        animation(ImageName: "teamarmor", ImageView: TeamArmor!)
        TeamArmor?.contentMode = .left
        TeamArmor?.clipsToBounds = true
        
        TeamKillView?.frame = CGRect(x: 40, y: 42, width: 60, height: 10)
        TeamKillView?.font = UIFont.systemFont(ofSize: 9)
        TeamKillView?.textColor = UIColor.orange
        TeamKillView?.textAlignment = .left
        
        TeamDamageView?.frame = CGRect(x: 100, y: 42, width: 60, height: 10)
        TeamDamageView?.font = UIFont.systemFont(ofSize: 9)
        TeamDamageView?.textColor = UIColor.orange
        TeamDamageView?.textAlignment = .left
        
        saveButton?.frame = CGRect(x: 165, y: 20, width: 30, height: 15)
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
        TeamBlood?.frame.size.width = CGFloat(Model.TeamBlood*115/100)
        TeamDyingBlood?.frame.size.width = CGFloat(Model.TeamDyingBlood*115/100)
        TeamArmor?.frame.size.width = CGFloat(Model.TeamArmor*100/100)
        UIView.animate(withDuration: 0.3, animations: {
            self.TeamBlood_2?.frame.size.width = CGFloat(Model.TeamBlood*115/100)
            self.TeamDyingBlood_2?.frame.size.width = CGFloat(Model.TeamDyingBlood*115/100)
            self.TeamArmor_2?.frame.size.width = CGFloat(Model.TeamArmor*100/100)
        })
        TeamKillView?.text = "击杀：\(Model.TeamKill)"
        TeamDamageView?.text = "伤害：\(Model.TeamDamage)"
    }
}
