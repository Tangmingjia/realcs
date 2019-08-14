import UIKit
import HandyJSON

class SocketModel: HandyJSON {
    var ACTION: String!
    var DATA: SocketData?
    var REQUEST_ID: String!
    required init(){}
}
struct SocketData: HandyJSON {
    var PERSON_NAME: String!
    var MSG_TYPE: String!
    var MSG_VOICE: String!
    var GAME_ID: Int = 0
    var PACKAGE_ID: String!
    var TEAM_ID: Int = 0
    var MSG_CHANNEL: String!
    var MSG_TXT: String!
}
