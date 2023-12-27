//
//  JoinDataModel.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

struct JoinAPIResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: JoinDataModel
}

struct JoinDataModel : Codable {
    var id : String?
    var name : String?
    var email : String?
    var socialType : String?
    var accessToken : String?
    var refreshToken : String?
    var isNewMember : Bool?
}
