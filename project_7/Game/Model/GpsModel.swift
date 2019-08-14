import UIKit
import HandyJSON

class GpsModel : HandyJSON {
    var flag: String!
    var data: GpsData?
    required init(){}
}

class GpsData : HandyJSON {
    var gpsEntityList: [gpsEntityList]!
    var total: Int = 0
    var totalNum: Int = 0
    var realcsGameCircleBomb : RealcsGameCircleBomb?
    var realcsGameCirclePoison : RealcsGameCirclePoison?
    var exposePersonList: [ExposePersonListItem]!
    var status: Int = 0
    var airdropEntityList: [AirdropEntityListItem]!
    var gameRule: Int = 0
    var duration: Int = 0
    var gameDuration: Int = 0
    var killNum: Int = 0
    var gameKillNum: Int = 0
    required init(){}
}

class gpsEntityList : HandyJSON {
    var connectStatus: Int = 0
    var direction: Int = 0
    var exposeFlag: Int = 0
    var lat: CLLocationDegrees = 0.0
    var lon: CLLocationDegrees = 0.0
    var personId: Int = 0
    var phoneStatus: Int = 0
    var shieldFlag: Int = 0
    var teamId: Int = 0
    var blood: Int = 0
    var dyingBlood: Int = 0
    var status: Int = 0
    var defence: Int = 0
    var randang: Int = 0
    var damage: Int = 0
    var killNum: Int = 0
    var ranking: Int = 0
    var personName: String!
    var realcsUpload: RealcsUpload?
    var gpsEquipTypeList: [gpsEquipTypeListItem]!     //身上装备
    var airdropEntityList: [AirdropEntityListItem]!  //附近空投
    var equipEntityList: [EquipEntityListItem]!   //背包内物品
    required init(){}
}

struct gpsEquipTypeListItem : HandyJSON {
    var equipTypeId: Int = 0
    var accesslocation: String!
    var equipNo: String!
    var defence: Float = 0.0
}

class AirdropEntityListItem : HandyJSON {
    var center: String!
    var status: Int = 0
    var airdropId: Int = 0
    var radius: CGFloat = 0.0
    var airdropEquipList: [AirdropEquipListItem]!
    required init(){}
}
class AirdropEquipListItem : HandyJSON {
    var number: Int = 0
    var equipName: String!
    var equipNo: [String]!
    var realcsUpload: RealcsUpload?
    required init(){}
}
class EquipEntityListItem : HandyJSON {
    var number: Int = 0
    var equipName: String!
    var equipNo: [String]!
    var realcsUpload: RealcsUpload?
    required init(){}
}
