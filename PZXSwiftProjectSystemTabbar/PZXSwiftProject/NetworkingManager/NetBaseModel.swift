//
//  NetBaseModel.swift
//  PZXSwiftProject
//
//  Created by 彭祖鑫 on 2021/5/27.
//

import Foundation


class NetBaseModel<T: Codable>: Codable {
    
    var statusCode: Int?

    var code: String?
    var msg: String?
    var success: Bool?
    var data: DataType?
//    var ext: [String: Any]?
    var ext: [String: CodableValue]?

//    var datad: Any?
//    var data: Any?

//    var data: T?

      // Define the associated type
      typealias DataType = T
    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case code, msg, success, data, statusCode,ext
    }
    



    
    // 初始化方法，处理解析错误并返回默认值
     static func defaultModelOnDecodingError(_ decodingError: DecodingError) -> NetBaseModel {
         let defaultModel = NetBaseModel<T>()
         // 设置默认值，可以根据需要进行调整
         defaultModel.statusCode = 0
         defaultModel.code = "0"
         defaultModel.msg = nil
         defaultModel.success = false
         defaultModel.data = nil
         return defaultModel
     }
    
    
}

// 定义一个不透明的 Decodable 和 Encodable 类型，表示 Any 类型的值
struct CodableValue: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.value = NSNull()
        } else if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else {
            // Handle other types as needed
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        // Encoding logic for each type
        if value is NSNull {
            try container.encodeNil()
        } else if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else {
            // Handle other types as needed
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Unsupported type"))
        }
    }
}


///Model解析
///// 使用示例
/// if let pcPhoneCodeModel = ModelParser.parseModel(baseModel!.data, modelType: PCPhoneCodeModel.self) {
///     print("Message ID: \(pcPhoneCodeModel.messageID ?? "N/A")")
/// }
class ModelParser {
    static func parseModel<T: Decodable>(_ data: Any?, modelType: T.Type) -> T? {
        do {
            if let dataDictionary = data as? [String: Any] {
                let jsonData = try JSONSerialization.data(withJSONObject: dataDictionary)
                let model = try JSONDecoder().decode(modelType, from: jsonData)
                return model
            } else if let dataArray = data as? [[String: Any]] {
                let jsonData = try JSONSerialization.data(withJSONObject: dataArray)
                let models = try JSONDecoder().decode(T.self, from: jsonData)
                return models
            } else {
                print("Unsupported data type")
                return nil
            }
        } catch {
            print("Error decoding model: \(error)")
            return nil
        }
    }
}
