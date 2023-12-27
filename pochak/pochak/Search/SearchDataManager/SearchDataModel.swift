//
//  TagDataModel.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

import Foundation

struct IdSearchData: Codable {
    let profileimgUrl: ProfileImageURL
    let userHandle: UserHandleInfo
    let name: NameInfo

    enum CodingKeys: String, CodingKey {
        case profileimgUrl = "profileimg_url"
        case userHandle
        case name
    }
}

struct ProfileImageURL: Codable {
    let S: String
}

struct UserHandleInfo: Codable {
    let S: String
}

struct NameInfo: Codable {
    let S: String
}

struct idSearchResponse:Codable{
    let profileUrl: String
    let name: String
    let userHandle: String
}
