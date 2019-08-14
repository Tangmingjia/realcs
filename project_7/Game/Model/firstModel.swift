import UIKit
import HandyJSON

class firstModel: HandyJSON {
    var data : firstData?
    var flag: String!
    required init(){}
}

class firstData: HandyJSON {
//    var oid: Int = 0
//    var gameId: Int = 0
//    var gameName: String!
    var status: Int = 0
    var total : Int = 0
    var totalNum : Int = 0
//    var startTime: String!
//    var bulletinList: Array = [String]()
    var realcsGameTeams: [RealcsGameTeamsItem]!
    var realcsGameMap : RealcsGameMap?
    var realcsGameCircleBomb : RealcsGameCircleBomb?
    var realcsGameCirclePoison : RealcsGameCirclePoison?
    var exposePersonList: [ExposePersonListItem]!
    required init(){}
}

class RealcsGameTeamsItem : HandyJSON {
    var teamId: Int = 0
    var teamName: String!
    var realcsGamePersonList: [RealcsGamePersonListItem]!
    required init(){}
}

class RealcsGamePersonListItem : HandyJSON {
    var personId: Int = 0
    var personName: String!
    var status: Int = 0      //1正常 2已死  3濒死
    var blood: Int = 0
    var defence: Int = 0
    var damage: Int = 0
    var grade: Int = 0
    var survivalTime: Int = 0
    var phoneStatus: Int = 0
    var connectStatus: Int = 0
    var killNum: Int = 0
    var gameId: Int = 0
//    var thorns: Int = 0
    var exposeFlag: Int = 0
    var shieldFlag: Int = 0
//    var radiationFlag: Int = 0
    var invincible: Int = 0
    var poisoningState: Int = 0
    var lon: CLLocationDegrees = 0.0
    var lat: CLLocationDegrees = 0.0
    var positionState: Int = 0
    var direction: Int = 0  //旋转角度
//    var gpsType: String!
    var delay: Int = 0
    var banGun: Int = 0
    var dyingBlood: Int = 0
    var maxBlood: Int = 0
    var npc: Bool = false
    var realcsUpload : RealcsUpload?
    var realcsGamePackage : RealcsGamePackage?
    var realcsGamePersonEquipList: [RealcsGamePersonEquipListItem]!
    required init(){}
}

struct RealcsUpload : HandyJSON {
    var uploadId: Int = 0
    var fileName: String!
    var accesslocation: String!
}

struct RealcsGamePackage : HandyJSON {
    var id: Int = 0
    var packageNo: String!
}

class RealcsGamePersonEquipListItem : HandyJSON {
    var catagoryId: Int = 0
    var createTime: Int = 0
    var defence: Int = 0
    var equipId: Int = 0
    var gameId: Int = 0
    var personId: Int = 0
    var realcsEquip : RealcsEquip?
    required init(){}
}

class RealcsEquip : HandyJSON {
    var equipNo: String!
    var id: Int = 0
    var inUse: Int = 0
    var oid: Int = 0
    var used: Int = 0
    var realcsEquipCategory : RealcsEquipCategory?
    required init(){}
}

class RealcsEquipCategory : HandyJSON {
    var beHurtRate: Int = 0
    var categoryId: Int = 0
    var categoryName: String!
    var defenceBlood: Int = 0
    var equipType: Int = 0
    var hurtBlood: Int = 0
    var multipleUse: Int = 0
    var persistenceTreat: Int = 0
    var treatBlood: Int = 0
    var usePart: Int = 0
    var useTarget: Int = 0
    var useType: Int = 0
    var realcsEquipType : RealcsEquipType?
    var realcsUpload : RealcsUpload?
    required init(){}
}
struct RealcsEquipType : HandyJSON {
    var equipTypeId: Int = 0
    var name: String!
}
struct RealcsGameMap : HandyJSON {
    var centerLat: CLLocationDegrees = 0.0
    var centerLon: CLLocationDegrees = 0.0
    var mapId: Int = 0
    var mapName: String!
    var maxZoom: Int = 0
    var minZoom: Int = 0
    var mapPath: String!
}

struct RealcsGameCircleBomb : HandyJSON {
    var center: String!
    var countDown: Int = 0
    var createTime: Int = 0
    var durationTime: Int = 0
    var gameId: Int = 0
    var hurtNum: Int = 0
    var hurtTime: Int = 0
    var radius: Int = 0
    var startTime: Int = 0
    var status: Int = 0
}

struct RealcsGameCirclePoison : HandyJSON {
    var center: String!
    var countDown: Int = 0
    var createTime: Int = 0
    var gameId: Int = 0
    var hurtIntervalTime: Int = 0
    var hurtNum: Int = 0
    var poisonType: Int = 0
    var radius: Int = 0
    var safetyCenter: String!
    var safetyRadius: Int = 0
    var startTime: Int = 0
    var status: Int = 0
    var zoomDuration: Int = 0
    var zoomLevel: Int = 0
    var zoomSpeed: Int = 0
    var zoomTotalLevel: Int = 0
}

class ExposePersonListItem : HandyJSON {
    var banGun: Int = 0
    var blood: Int = 0
    var connectStatus: Int = 0
    var damage: Int = 0
    var defence: Int = 0
    var delay: Int = 0
    var direction: Int = 0
    var dyingBlood: Int = 0
    var exposeFlag: Int = 0
    var gameId: Int = 0
    var gpsType: String!
    var grade: Int = 0
    var invincible: Int = 0
    var killNum: Int = 0
    var lastSufferHurtType: Int = 0
    var lat: CLLocationDegrees = 0.0
    var lon: CLLocationDegrees = 0.0
    var maxBlood: Int = 0
    var noWalk: Int = 0
    var npc: Bool = false
    var personId: Int = 0
    var personName: String!
    var phoneStatus: Int = 0
    var poisoningState: Int = 0
    var radiationFlag: Int = 0
    var shieldFlag: Int = 0
    var status: Int = 0 
    var survivalTime: Int = 0
    var thorns: Int = 0
    var realcsUpload : RealcsUpload?
    required init(){}
}
