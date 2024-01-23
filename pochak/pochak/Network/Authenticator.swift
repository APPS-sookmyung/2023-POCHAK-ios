//
//  Authenticator.swift
//  pochak
//
//  Created by Seo Cindy on 1/16/24.
//

import Alamofire

struct TokenRefreshResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: MyAuthenticationCredential
}

class MyAuthenticator : Authenticator {
    let accessToken = GetToken().getAccessToken()
    let refreshToken = GetToken().getRefreshToken()
    typealias Credential = MyAuthenticationCredential

    // token을 refresh하는 부분
    func refresh(_ credential: MyAuthenticationCredential, for session: Alamofire.Session, completion: @escaping (Result<MyAuthenticationCredential, Error>) -> Void) {
        
        let url = APIConstants.baseURL + "/api/v1/user/refresh"
        let header : HTTPHeaders = ["Authorization": accessToken, "RefreshToken" : refreshToken, "Content-type": "application/json"]
        
        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate()
        .responseDecodable(of: TokenRefreshResponse.self) { response in
               switch response.result {
               case .success(let result):
                   let resultData = result.result
                   print("myProfilePochakPostDataManager")
                   print(credential)
                   completion(.success(credential))
               case .failure(let error):
                   print("myProfilePochakPostDataManager")
                   print(error)
               }
           }
        
    }
    
    // 인증이 필요한 urlRequest에 대해서만 refresh가 되도록, 이 경우에만 true를 리턴하여 refresh 요청
    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: MyAuthenticationCredential) -> Bool {
        // bearerToken의 urlRequest대해서만 refresh를 시도 (true)
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
        
    // api요청 시 AuthenticatorIndicator객체가 존재하면, 요청 전에 가로채서 apply에서 Header에 bearerToken 추가
    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        urlRequest.addValue(credential.refreshToken, forHTTPHeaderField: "refresh-token")
    }
    
    // api요청 후 error가 떨어진 경우, 401에러(인증에러)인 경우만 refresh가 되도록 필터링
    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }
}
