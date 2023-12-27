//
//  UploadDataService.swift
//  pochak
//
//  Created by 장나리 on 11/23/23.
//

import Alamofire

class UploadDataService{
    static let shared = UploadDataService()

    func upload(postImage:Data?, caption:String, taggedUserHandles:Array<String>,completion: @escaping(NetworkResult<Any>) -> Void){
        let body : Parameters = [
            "caption":caption,
            "taggedUserHandles":taggedUserHandles
        ]
        let header : HTTPHeaders = ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJqaXNvbyIsInJvbGUiOiJST0xFX1VTRVIiLCJpYXQiOjE2OTkwOTMzNTIsImV4cCI6MTc3Njg1MzM1Mn0.8Cz-E0OmD8aK9wC8YApk1JenueXM86O9lPH0_pUcnLc",
                                            "Content-type": "application/json"  // multipart/form-data ???
                                            ]
    
        
        let dataRequest = AF.upload(multipartFormData: { multipartFormData in
            // 이미지 데이터를 multipart form data에 추가
            multipartFormData.append(postImage!, withName: "postImage", fileName: "image.jpg", mimeType: "image/jpeg")
            
            // 다른 필드를 추가하려면 아래와 같이 추가합니다.
            for (key, value) in body {
                if let data = String(describing: value).data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
        }, to: APIConstants.baseURL + "/api/v1/post", headers: header)
        
        dataRequest.responseJSON { response in
            switch response.result {
            case .success(let value): // 데이터 통신이 성공한 경우
                if let dict = value as? [String: Any] {
                    if let code = dict["code"] as? Int {
                        switch code {
                        case 1000:
                            completion(.success(dict))
                        default:
                            print("Unknown code: \(code)")
                            completion(.networkFail)
                        }
                    }
                }
            case .failure(let error): // 데이터 통신이 실패한 경우
                if let statusCode = response.response?.statusCode {
                    print("Failure Status Code: \(statusCode)")
                    completion(.networkFail)
                }
                print("Failure Error: \(error.localizedDescription)")
                
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Failure Data: \(errorMessage)")
                    completion(.networkFail)
                }
            }
        }
    }
}

