import UIKit
import HandyJSON

class ResultsModel : HandyJSON {
    var data: recordListItem?
    required init(){}
}
class recordListItem : HandyJSON {
    var recordList: [resultsItem]!
    required init(){}
}
struct resultsItem : HandyJSON {
    var personName: String!
    var survivalTime: Int = 0
    var personId: Int = 0
    var teamId: Int = 0
    var killNum: Int = 0
    var damage: Int = 0
    var ranking: Int = 0
    var dieNum: Int = 0
}
