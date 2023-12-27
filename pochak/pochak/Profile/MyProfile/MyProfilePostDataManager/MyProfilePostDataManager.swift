//
//  MyProfilePostDataManager.swift
//  pochak
//
//  Created by Seo Cindy on 12/28/23.
//

import Alamofire

class MyProfilePostDataManager {
    
    static let shared = MyProfilePostDataManager()
    
    func myProfilePostDataManager(_ handle : String, _ completion: @escaping ([PostDataModel]) -> Void) {
        let url = APIConstants.baseURL + "/api/v1/user/profile/" + handle + "/pochak"
        
        let header : HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkeHh5bm5pIiwicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTcwMzY5MDExNywiZXhwIjoxNzgxNDUwMTE3fQ.2kaatfaOOZeor-RrK09ZCBaxizKI8KGs14Pt-j_uuoU", "Content-type": "application/json"]

        AF.request(url, 
                   method: .get,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate()
        .responseDecodable(of: MyProfilePostResponse.self) { response in
               switch response.result {
               case .success(let result):
                   let resultData = result.result.uploadPosts
                   completion(resultData)
               case .failure(let error):
                   print(error)
               }
           }
    }
}
