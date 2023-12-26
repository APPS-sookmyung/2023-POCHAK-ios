//
//  GoogleLoginDataManager.swift
//  pochak
//
//  Created by Seo Cindy on 12/26/23.
//

import Alamofire

class GoogleLoginDataManager {
    func googleLoginDataManager(_ viewController : SocialJoinViewController) {
//        APIConstants.baseURL 로 바꾸기
        AF.request("http://pochak.site/api/v1/user/google/login", method: .get).validate().responseDecodable(of: [GoogleLoginModel].self) { response in
            switch response.result{
            case .success(let result):
                print("성공")
                print(result)
                viewController.successAPI(result)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
