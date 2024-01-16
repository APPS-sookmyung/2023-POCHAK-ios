//
//  GetAccessToken.swift
//  pochak
//
//  Created by Seo Cindy on 1/16/24.
//

import Foundation
class GetToken {
    
    func getAccessToken() -> String {
        guard let keyChainAccessToken = (try? KeychainManager.load(account: "acessToken")) else {return ""}
        return "Bearer " + keyChainAccessToken
    }
    
    func getRefreshToken() -> String {
        guard let keyChainRefreshToken = (try? KeychainManager.load(account: "refreshToken")) else {return ""}
        return "Bearer " + keyChainRefreshToken
    }
}
