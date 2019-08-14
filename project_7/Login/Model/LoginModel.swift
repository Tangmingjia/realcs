import HandyJSON
struct LoginData : HandyJSON {
    var damage: Int = 0
    var connect_status: Int = 0
    var thorns: Int = 0
    var defence: Int = 0
    var invincible: Int = 0
    var max_blood: Int = 0
    var package_id: Int = 0
    var team_id: Int = 0
    var oid: Int = 0
    var map_type: Int = 0
    var kill_num: Int = 0
    var dying_blood: Int = 0
    var person_id: Int = 0
    var game_id: Int = 0
    var IS_NPC: Int = 0
    var create_time: Int = 0
    var shield_flag: Int = 0
    var person_name: String!
    var avatar: Int = 0
    var expose_flag: Int = 0
    var blood: Int = 0
    var ban_gun: Int = 0
    var grade: Int = 0
    var position_state: Int = 0
    var create_user: String!
    var survival_time: Int = 0
    var status: Int = 0
}

class LoginModel : HandyJSON {
    var respCode: String!
    var msg: String!
    var data: LoginData?
    required init(){}
}
