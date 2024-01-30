//
//  UploadDataService.swift
//  pochak
//
//  Created by 장나리 on 11/23/23.
//

import Alamofire

class UploadDataService{
    static let shared = UploadDataService()
    let accessToken = GetToken().getAccessToken()

    func upload(postImage:Data?, caption:String, taggedUserHandles:Array<String>,completion: @escaping(NetworkResult<Any>) -> Void){
        let body : Parameters = [
            "caption":caption,
            "taggedUserHandles":taggedUserHandles
        ]
        
        let header : HTTPHeaders = ["Authorization": accessToken, "Content-type": "application/json"]
        
        let dataRequest = AF.upload(multipartFormData: { multipartFormData in
            // 이미지 데이터를 multipart form data에 추가
            multipartFormData.append(postImage!, withName: "postImage", fileName: "image.jpg", mimeType: "image/jpeg")
            
            if let captionData = caption.data(using: .utf8) {
                multipartFormData.append(captionData, withName: "caption")
            }

            // Add taggedUserHandles data
            for tag in taggedUserHandles {
                if let tagData = tag.data(using: .utf8) {
                            multipartFormData.append(tagData, withName: "taggedUserHandles")
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

