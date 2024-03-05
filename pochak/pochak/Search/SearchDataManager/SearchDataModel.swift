//
//  TagDataModel.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

import Foundation

struct IdSearchData: Codable {
    let profileimgUrl: String
    let userHandle: String
    let id: String
}


struct idSearchResponse:Codable{
    let profileUrl: String
    let id: String
    let userHandle: String
}
