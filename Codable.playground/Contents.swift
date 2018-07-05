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
