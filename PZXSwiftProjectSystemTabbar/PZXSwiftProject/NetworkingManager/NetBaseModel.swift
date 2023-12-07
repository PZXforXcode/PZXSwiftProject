//
//  NetBaseModel.swift
//  PZXSwiftProject
//
//  Created by 彭祖鑫 on 2021/5/27.
//

import Foundation


class NetBaseModel<T: Codable>: Codable {
    var code: String?
    var msg: String?
    var success: Bool?
    var data: T?

    // MARK: - CodingKeys
    private enum CodingKeys: String, CodingKey {
        case code, msg, success, data
    }
}
