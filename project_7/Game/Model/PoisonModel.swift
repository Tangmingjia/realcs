import UIKit
import HandyJSON

struct PoisonData : HandyJSON {
    var center: String!
    var countDown: Int = 0
    var hurtIntervalTime: Int = 0
    var radius: Int = 0
    var safetyCenter: String!
    var safetyRadius: Int = 0
    var status: Int = 0
}

class PoisonModel : HandyJSON {
    var gameId: Int = 0
    var flag: String!
    var data: PoisonData?
    var type: Int = 0
    required init(){}
}
