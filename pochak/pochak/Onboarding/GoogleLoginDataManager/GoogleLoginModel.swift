//
//  GoogleLoginModel.swift
//  pochak
//
//  Created by Seo Cindy on 12/26/23.
//

struct GoogleLoginModel : Decodable {
    var id : String?
    var name : String?
    var email : String?
    var socialType : String?
    var accessToken : String?
    var refreshToken : String?
    var isNewMember : Bool?
}
