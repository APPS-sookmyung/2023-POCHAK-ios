//
//  TagDataModel.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

import Foundation

struct IdSearchResponse: Codable {
    let profileimgURL: String
    let userHandle: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case profileimgURL = "profileimg_url"
        case userHandle = "userHandle"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        profileimgURL = try container.decodeIfPresent(String.self, forKey: .profileimgURL) ?? ""
        userHandle = try container.decodeIfPresent(String.self, forKey: .userHandle) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
