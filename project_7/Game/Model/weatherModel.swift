import HandyJSON

class weatherModel : HandyJSON {
    var weather: [WeatherItem]!
    var base: String!
    var visibility: Int = 0
    var dt: Int = 0
    var timezone: Int = 0
    var id: Int = 0
    var name: String!
    var cod: Int = 0
    required init(){}
}

struct WeatherItem : HandyJSON {
    var id: Int = 0
    var main: String!
    var description: String!
    var icon: String!
}
