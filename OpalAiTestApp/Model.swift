//
//  Model.swift
//  OpalAiTestApp
//
//  Created by Milad on 7/5/24.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let walls: [Wall]
    let doors: [DoorElement]
    let windows: [Window]
    let version, story: Int
    let openings: [Opening]
    let sections: [Section]
    let coreModel: String
    let objects: [Object]
    let floors: [Floor]
}

// MARK: - DoorElement
struct DoorElement: Codable {
    let polygonCorners: [JSONAny]
    let dimensions: [Double]
    let category: DoorCategory
    let parentIdentifier: String
    let story: Int
    let confidence: DoorConfidence
    let completedEdges: [JSONAny]
    let curve: JSONNull?
    let transform: [Double]
    let identifier: String
}

// MARK: - DoorCategory
struct DoorCategory: Codable {
    let door: CategoryDoor
}

// MARK: - CategoryDoor
struct CategoryDoor: Codable {
    let isOpen: Bool
}

// MARK: - DoorConfidence
struct DoorConfidence: Codable {
    let high, medium: High?
}

// MARK: - High
struct High: Codable {
}

// MARK: - Floor
struct Floor: Codable {
    let category: FloorCategory
    let confidence: FloorConfidence
    let story: Int
    let dimensions: [Double]
    let parentIdentifier, curve: JSONNull?
    let transform: [Double]
    let completedEdges: [JSONAny]
    let polygonCorners: [[Double]]
    let identifier: String
}

// MARK: - FloorCategory
struct FloorCategory: Codable {
    let floor: High
}

// MARK: - FloorConfidence
struct FloorConfidence: Codable {
    let high: High
}

// MARK: - Object
struct Object: Codable {
    let category: ObjectCategory
    let attributes: Attributes
    let story: Int
    let identifier: String
    let confidence: ObjectConfidence
    let transform: [Double]
    let parentIdentifier: String?
    let dimensions: [Double]
}

// MARK: - Attributes
struct Attributes: Codable {
    let storageType: StorageType?
    let tableType, tableShapeType, sofaType, chairBackType: String?
    let chairLegType, chairArmType, chairType: String?

    enum CodingKeys: String, CodingKey {
        case storageType = "StorageType"
        case tableType = "TableType"
        case tableShapeType = "TableShapeType"
        case sofaType = "SofaType"
        case chairBackType = "ChairBackType"
        case chairLegType = "ChairLegType"
        case chairArmType = "ChairArmType"
        case chairType = "ChairType"
    }
}

enum StorageType: String, Codable {
    case cabinet = "cabinet"
    case shelf = "shelf"
}

// MARK: - ObjectCategory
struct ObjectCategory: Codable {
    let storage, table, sofa, stove: High?
    let chair, television, sink, stairs: High?
    let oven, refrigerator, fireplace: High?
}

// MARK: - ObjectConfidence
struct ObjectConfidence: Codable {
    let high, low, medium: High?
}

// MARK: - Opening
struct Opening: Codable {
    let category: OpeningCategory
    let polygonCorners: [JSONAny]
    let story: Int
    let dimensions: [Double]
    let completedEdges: [JSONAny]
    let identifier: String
    let curve: JSONNull?
    let confidence: FloorConfidence
    let transform: [Double]
    let parentIdentifier: String
}

// MARK: - OpeningCategory
struct OpeningCategory: Codable {
    let opening: High
}

// MARK: - Section
struct Section: Codable {
    let label: String
    let story: Int
    let center: [Double]
}

// MARK: - Wall
struct Wall: Codable {
    let polygonCorners: [[Double]]
    let dimensions: [Double]
    let parentIdentifier: JSONNull?
    let category: WallCategory
    let confidence: FloorConfidence
    let identifier: String
    let completedEdges: [JSONAny]
    let transform: [Double]
    let story: Int
    let curve: JSONNull?
}

// MARK: - WallCategory
struct WallCategory: Codable {
    let wall: High
}

// MARK: - Window
struct Window: Codable {
    let dimensions: [Double]
    let curve: JSONNull?
    let category: WindowCategory
    let story: Int
    let completedEdges: [JSONAny]
    let confidence: WindowConfidence
    let parentIdentifier: String
    let polygonCorners: [JSONAny]
    let transform: [Double]
    let identifier: String
}

// MARK: - WindowCategory
struct WindowCategory: Codable {
    let window: High
}

// MARK: - WindowConfidence
struct WindowConfidence: Codable {
    let medium: High
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}

