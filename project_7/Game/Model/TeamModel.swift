import UIKit
import HandyJSON

class TeamModel : HandyJSON{
    weak var delegate:TeamModelDelegate?
    
    var TeamBlood: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var TeamDyingBlood: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var TeamArmor: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var TeamName: String = "" {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var TeamIcon: String = "" {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var TeamStatus: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var TeamKill: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var TeamDamage: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    var myStatus: Int = 0 {
        didSet {
            self.delegate?.didUpdate(Model: self)
        }
    }
    required init(){}
}
protocol TeamModelDelegate : AnyObject {
    func didUpdate(Model:TeamModel)
}
