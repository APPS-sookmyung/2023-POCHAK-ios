//
//  GetAccessToken.swift
//  pochak
//
//  Created by Seo Cindy on 1/16/24.
//

import Foundation
class GetAccessToken {
    
    func getAccessToken() -> String {
        let socialId = UserDefaultsManager.getData(type: String.self, forKey: .socialId) ?? "socialId not found"
        guard let keyChainAccessToken = (try? KeychainManager.load(account: socialId)) else {return ""}
        return "Bearer " + keyChainAccessToken
    }
}
