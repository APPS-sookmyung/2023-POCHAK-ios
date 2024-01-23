//
//  MyProfilePostDataManager.swift
//  pochak
//
//  Created by Seo Cindy on 12/28/23.
//

import Alamofire

class MyProfilePostDataManager {
    
    static let shared = MyProfilePostDataManager()
    
    // Get token
    let accessToken = GetToken().getAccessToken()
    let refreshToken = GetToken().getRefreshToken()
    
    func myProfilePochakPostDataManager(_ handle : String, _ completion: @escaping (MyProfilePochakPostModel) -> Void) {
        print(accessToken)
        print(handle)
        let url = APIConstants.baseURL + "/api/v1/user/profile/" + handle
        
        let header : HTTPHeaders = ["Authorization": accessToken, "Content-type": "application/json"]
        
        // Load Authenticator
//        let authenticator = MyAuthenticator()
//        let credential = MyAuthenticationCredential(accessToken: accessToken,
//                                                    refreshToken: refreshToken,
//                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 60))
//        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
//                                                                    credential: credential)
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header
                   /*interceptor: myAuthencitationInterceptor*/)
        .validate()
        .responseDecodable(of: MyProfilePochakPostResponse.self) { response in
            print(response)
            switch response.result {
            case .success(let result):
                let resultData = result.result
                completion(resultData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func myProfilePochakedPostDataManager(_ handle : String, _ completion: @escaping ([PostDataModel]) -> Void) {
        let url = APIConstants.baseURL + "/api/v1/user/profile/" + handle + "/pochak"
        
        let header : HTTPHeaders = ["Authorization": accessToken, "Content-type": "application/json"]
        
        // Load Authenticator
//        let authenticator = MyAuthenticator()
//        let credential = MyAuthenticationCredential(accessToken: GetToken().getAccessToken(),
//                                                    refreshToken: GetToken().getRefreshToken(),
//                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 60))
//        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
//                                                                    credential: credential)
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header
                   /*interceptor: myAuthencitationInterceptor*/)
        .validate()
        .responseDecodable(of: MyProfilePochakedPostResponse.self) { response in
            switch response.result {
            case .success(let result):
                print("myProfilePochakedPostDataManager")
                let resultData = result.result.uploadPosts
                completion(resultData)
            case .failure(let error):
                print("myProfilePochakedPostDataManager")
                print(error)
            }
        }
    }
}
