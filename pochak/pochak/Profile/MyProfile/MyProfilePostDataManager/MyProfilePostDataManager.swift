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
    
    func myProfileUserAndPochakedPostDataManager(_ handle : String, _ completion: @escaping (MyProfileUserAndPochakedPostModel) -> Void) {
        let url = APIConstants.baseURL + "/api/v1/user/profile/" + handle
        
//        let header : HTTPHeaders = ["Authorization": accessToken, "Content-type": "application/json"]
        
        let authenticator = MyAuthenticator()
        let credential = MyAuthenticationCredential(accessToken: accessToken,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSinceNow: 60 * 60))
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                                    credential: credential)
    
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   interceptor: myAuthencitationInterceptor)
        .validate()
        .responseDecodable(of: MyProfileUserAndPochakedPostResponse.self) { response in
            switch response.result {
            case .success(let result):
                let resultData = result.result
                completion(resultData)
            case .failure(let error):
                print("nnnnnnn 실패함")
                print(error)
            }
        }
    }
    
    func myProfilePochakPostDataManager(_ handle : String, _ completion: @escaping ([PostDataModel]) -> Void) {
        let url = APIConstants.baseURL + "/api/v1/user/profile/" + handle + "/pochak"
        
        let header : HTTPHeaders = ["Authorization": accessToken, "Content-type": "application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate()
        .responseDecodable(of: MyProfilePochakPostResponse.self) { response in
            print(response)
            switch response.result {
            case .success(let result):
                print("inside PochakDM!!!!!!")
                let resultData = result.result.uploadPosts
                completion(resultData)
            case .failure(let error):
                print("inside PochakDM~~~~")
                print(error)
            }
        }
    }
}
