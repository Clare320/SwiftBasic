import UIKit

//let json = "{\"manufacturer\":\"Cessna\",\"model\":\"172 Skyhawk\",\"seats\":\"4\"}"

let json = """
{
"manufacturer": "Cessna",
"model":"172 Skyhawk",
"seats": 4
}
""".data(using: .utf8)!

struct Plane: Codable {
    var manufacturer: String
    var model: String
    var seats: Int
}

//extension Plane: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case manufacturer
//        case model
//        case seats
//    }
    
    /// Decodable
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.manufacturer = try container.decode(String.self, forKey: .manufacturer)
//        self.model = try container.decode(String.self, forKey: .model)
//        self.seats = try container.decode(Int.self, forKey: .seats)
//    }
    
    /// Encodable
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.manufacturer, forKey: .manufacturer)
//        try container.encode(self.model, forKey: .model)
//        try container.encode(self.seats, forKey: .seats)
//    }
//}

let decoder = JSONDecoder()
let plane = try! decoder.decode(Plane.self, from: json)
print("plane: \(plane.manufacturer),\(plane.model),\(plane.seats)")

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let reencodedJSON = try! encoder.encode(plane)
print(String(data: reencodedJSON, encoding: .utf8)!)

let planesData = """
[
{
"manufacturer":"Cessna",
"model":"172 Skyhawk",
"seats":4
},
{
"manufacturer":"Piper",
"model":"PA-28 Cherokee",
"seats": 4
}
]
""".data(using: .utf8)!
let planes = try! decoder.decode([Plane].self, from: planesData)
print(planes)

struct PlaneList: Codable {
    var planes: [Plane]
}

let data2 = """
{
"planes": [
    {
        "manufacturer":"Cessna",
        "model":"172 Skyhawk",
        "seats":4
    },
    {
        "manufacturer":"Piper",
        "model":"PA-28 Cherokee",
        "seats": 4
    }
        ]
}
""".data(using: .utf8)!

let planesList = try! decoder.decode(PlaneList.self, from: data2)
print(planesList)

/// 各种场景下Codable使用

let flyPlan = """
{
    "aircraft": {
        "identification":"NA12345",
        "color": "Blue/White"
    },
    "flight_rules":"IFR",
    "route":["KTTD", "KHIO"],
    "departure_time": {
        "proposed":"2018-04-20T14:15:00-0700",
        "actual":"2018-04-20T14:20:00-0700"
    },
    "remarks":null
}
""".data(using: .utf8)!

struct Aircraft: Codable {
    var identification: String
    var color: String
}

struct FlightPlan: Decodable {
    enum FlightRules: String, Decodable {
        case visual = "VFR"
        case instrument = "IFR"
    }
    
    var aircraft: Aircraft
    var flightRules: FlightRules
    var route: [String]
    private var departureDates: [String: Date]
    var proposedDepartureDate: Date? {
        return departureDates["proposed"]
    }
    var actualDepartureDate: Date? {
        return departureDates["actual"]
    }
    var remarks: String?
}
extension FlightPlan {
    private enum CodingKeys: String, CodingKey {
        case aircraft
        case flightRules = "flight_rules"
        case route
        case departureDates = "departure_time"
        case remarks
    }
}

decoder.dateDecodingStrategy = .iso8601
let plan = try! decoder.decode(FlightPlan.self, from: flyPlan)
print(plan.aircraft.identification)
print(plan.actualDepartureDate!)


/// --- 重写Decodable或者Encodable

let routeData = """
{
    "points": ["KSQL", "KWVI"],
    "KSQL": {
        "code":"KSQL",
        "name":"San Carlos Airport"
    },
    "KWVI": {
        "code":"KWVI",
        "name":"Watsonville Municipal Airport"
    }
}
""".data(using: .utf8)!

struct Route: Decodable {
    struct Airport: Decodable {
        var code: String
        var name: String
    }
    
    var points: [Airport]
    
    private struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int? {
            return nil
        }
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        init?(intValue: Int) {
            return nil
        }
        static let points = CodingKeys(stringValue: "points")!
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let codes = try container.decode([String].self, forKey: .points)
        let tmpPoints = try codes.map { (code) -> Airport in
            let key = CodingKeys(stringValue: code)!
            let airport = try container.decode(Airport.self, forKey: key)
            return airport
        }
        self.points = tmpPoints
    }
}

let routes = try decoder.decode(Route.self, from: routeData)
print(routes.points)

let reportData = """
{
"title":"111",
"body":"hello world",
"metadata":{
"code":"1000",
"style":"xml"
}
}
""".data(using: .utf8)!
struct Report: Decodable {
    var title: String
    var body: String
    var metadata: [String: String]
}

let report = try decoder.decode(Report.self, from: reportData)
print(report.title)
