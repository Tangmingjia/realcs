import UIKit
import HandyJSON

class Model_4: HandyJSON {
    var ACTION: String!
    var DATA: DATA?
    var REQUEST_ID: String!
    required init(){}
}
struct DATA: HandyJSON {
    var PERSON_NAME: String!
    var MSG_TYPE: String!
    var MSG_VOICE: String!
    var GAME_ID: Int = 0
    var PACKAGE_ID: String!
    var TEAM_ID: Int = 0
    var MSG_CHANNEL: String!
}
