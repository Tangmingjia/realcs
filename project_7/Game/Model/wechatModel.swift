import HandyJSON

class wechatModel : HandyJSON {
    var access_token: String!
    var expires_in: Int = 0
    var refresh_token: String!
    var openid: String!
    var scope: String!
    var unionid: String!
    var ticket: String!
    required init(){}
}

class userInfoModel : HandyJSON {
    var openid: String!
    var nickname: String!
    var sex: Int = 0
    var language: String!
    var city: String!
    var province: String!
    var country: String!
    var headimgurl: String!
    var unionid: String!
    required init(){}
}
