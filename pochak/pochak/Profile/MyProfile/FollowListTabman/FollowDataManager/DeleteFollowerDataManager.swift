//
//  DeleteFollowerDataManager.swift
//  pochak
//
//  Created by Seo Cindy on 1/30/24.
//

import Foundation
import Alamofire

class DeleteFollowerDataManager {
    
    static let shared = DeleteFollowerDataManager()
    
    // Get token
    let accessToken = GetToken().getAccessToken()
    let refreshToken = GetToken().getRefreshToken()
    
    
    func deleteFollowerDataManager(_ handle : String, _ completion: @escaping (DeleteFollowerDataResponse) -> Void) {
        //        let url = APIConstants.baseURL + "/api/v1/user/profile/" + handle
        
        let url = "http://15.165.84.249/api/v2/members/" + handle + "/follower"
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: accessToken,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 60))
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
        
        AF.request(url,
                   method: .delete,
                   encoding: URLEncoding.default,
                   interceptor: myAuthencitationInterceptor)
        .validate()
        .responseDecodable(of: DeleteFollowerDataResponse.self) { response in
            switch response.result {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print(error)
            }
        }
    }
}
