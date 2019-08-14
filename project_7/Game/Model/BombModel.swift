import UIKit
import HandyJSON

struct BombData : HandyJSON {
    var center: String!
    var countDown: Int = 0
    var radius: Int = 0
    var status: Int = 0
}

class BombModel : HandyJSON {
    var gameId: Int = 0
    var flag: String!
    var data: BombData?
    var type: Int = 0
    required init(){}
}
