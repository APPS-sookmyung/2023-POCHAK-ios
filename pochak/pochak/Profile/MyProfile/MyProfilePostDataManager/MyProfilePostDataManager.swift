//
//  MyProfilePostDataManager.swift
//  pochak
//
//  Created by Seo Cindy on 12/28/23.
//

import Alamofire

class MyProfilePostDataManager {
    
    static let shared = MyProfilePostDataManager()
    
    func myProfilePochakedPostDataManager(_ handle : String, _ accessToken : String, _ completion: @escaping ([PostDataModel]) -> Void) {
        let url = APIConstants.baseURL + "/api/v1/user/profile/" + handle + "/pochak"
        let header : HTTPHeaders = ["Authorization": "Bearer " + accessToken, "Content-type": "application/json"]

        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate()
        .responseDecodable(of: MyProfilePochakedPostResponse.self) { response in
               switch response.result {
               case .success(let result):
                   let resultData = result.result.uploadPosts
                   completion(resultData)
               case .failure(let error):
                   print(error)
               }
           }
    }
    
    func myProfilePochakPostDataManager(_ handle : String, _ accessToken : String, _ completion: @escaping (MyProfilePochakPostModel) -> Void) {
        let url = APIConstants.baseURL + "/api/v1/user/profile/" + handle
        let header : HTTPHeaders = ["Authorization": "Bearer " + accessToken, "Content-type": "application/json"]

        AF.request(url,
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate()
        .responseDecodable(of: MyProfilePochakPostResponse.self) { response in
               switch response.result {
               case .success(let result):
                   let resultData = result.result
                   print("myProfilePochakPostDataManager")
                   completion(resultData)
               case .failure(let error):
                   print("myProfilePochakPostDataManager")
                   print(error)
               }
           }
    }
    
    
}

