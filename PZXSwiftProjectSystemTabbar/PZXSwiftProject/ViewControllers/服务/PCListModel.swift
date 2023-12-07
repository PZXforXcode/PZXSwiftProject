//
//  PCListModel.swift
//  PZXSwiftProject
//
//  Created by 彭祖鑫 on 2023/12/7.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pCListModel = try? JSONDecoder().decode(PCListModel.self, from: jsonData)

import Foundation

// MARK: - PCListModel
class PCListModel: Codable {
    var list: [PCList]?

    init(list: [PCList]?) {
        self.list = list
    }

}

// MARK: - PCList
class PCList: Codable {
    var id: Int?
    var names: PCNames?
    var code, type: String?
    var images: [PCImage]?
    var connectModes: [PCConnectMode]?

    init(id: Int?, names: PCNames?, code: String?, type: String?, images: [PCImage]?, connectModes: [PCConnectMode]?) {
        self.id = id
        self.names = names
        self.code = code
        self.type = type
        self.images = images
        self.connectModes = connectModes
    }
}

// MARK: - PCConnectMode
class PCConnectMode: Codable {
    var mode, protocolCode, bleServiceUUID: String?

    enum CodingKeys: String, CodingKey {
        case mode, protocolCode
        case bleServiceUUID = "bleServiceUuid"
    }

    init(mode: String?, protocolCode: String?, bleServiceUUID: String?) {
        self.mode = mode
        self.protocolCode = protocolCode
        self.bleServiceUUID = bleServiceUUID
    }
}

// MARK: - PCImage
class PCImage: Codable {
    var tags: [String]?
    var url: String?

    init(tags: [String]?, url: String?) {
        self.tags = tags
        self.url = url
    }
}

// MARK: - PCNames
class PCNames: Codable {
    var en, zh: String?

    init(en: String?, zh: String?) {
        self.en = en
        self.zh = zh
    }
}
