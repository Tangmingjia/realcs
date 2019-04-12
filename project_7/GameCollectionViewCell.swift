import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    var IconImageView : UIImageView?
    var NameLabel : UILabel?
    var TeamBloodView : UIView?
    var TeamBlood : UIView?
    var TeamDyingBlood : UIView?
    var TeamArmorView : UIView?
    var TeamArmor : UIView?
    var DeadView : UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.IconImageView = UIImageView()
        self.addSubview(IconImageView!)
        
        self.NameLabel = UILabel()
        self.addSubview(NameLabel!)
        
        self.TeamBloodView = UIView()
        self.addSubview(TeamBloodView!)
        
        self.TeamBlood = UIView()
        self.TeamBloodView?.addSubview(TeamBlood!)
        
        self.TeamDyingBlood = UIView()
        self.TeamBloodView?.addSubview(TeamDyingBlood!)
        
        self.TeamArmorView = UIView()
        self.addSubview(TeamArmorView!)
        
        self.TeamArmor = UIView()
        self.TeamArmorView?.addSubview(TeamArmor!)
        
        self.DeadView = UILabel()
        self.addSubview(DeadView!)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUI(){
        
        self.IconImageView?.frame = CGRect(x: 10, y: 5, width: 30, height: 30)
        self.IconImageView?.layer.cornerRadius = self.IconImageView!.frame.width/2
        self.IconImageView?.layer.masksToBounds = true
        
        self.NameLabel?.frame = CGRect(x: 0, y: 40, width: 50, height: 10)
        self.NameLabel?.font = UIFont.systemFont(ofSize: 7)
        self.NameLabel?.textAlignment = .center
        
        self.TeamBloodView?.frame = CGRect(x: 0, y: 55, width: 50, height: 5)
        self.TeamBloodView?.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5)
        
        self.TeamBlood?.frame = CGRect(x: 0, y: 0, width: 50, height: 5)
        self.TeamBlood?.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        
        self.TeamDyingBlood?.frame = CGRect(x: 0, y: 0, width: 50, height: 5)
        self.TeamDyingBlood?.backgroundColor = UIColor(red: 230/255, green: 172/255, blue: 59/255, alpha: 1)
        self.TeamDyingBlood?.isHidden = true
        
        self.TeamArmorView?.frame = CGRect(x: 0, y: 53, width: 50, height: 2)
        self.TeamArmorView?.backgroundColor = UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: 0.5)
        
        self.TeamArmor?.frame = CGRect(x: 0, y: 0, width: 50, height: 5)
        self.TeamArmor?.backgroundColor = UIColor(red: 28/255, green: 134/255, blue: 238/255, alpha: 1)
        
        self.DeadView?.frame = CGRect(x: 0, y: 0, width: 50, height: 60)
        self.DeadView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.DeadView?.text = "淘汰"
        self.DeadView?.textColor = UIColor.red
        self.DeadView?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 2))
        self.DeadView?.textAlignment = .center
    }
}
