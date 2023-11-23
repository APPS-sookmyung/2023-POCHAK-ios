//
//  UploadDataService.swift
//  pochak
//
//  Created by 장나리 on 11/23/23.
//

import Alamofire

class UploadDataService{

    let body : Parameters = [
            "postImageUrl":"https://postImageUrl",
            "caption":"example caption",
            "taggedUserHandles":["handle1","handle2"]
                    ]
            
    let dataRequest = AF.request(APIConstants.baseURL+"/api/v1/post",
                                method: .post,
                                parameters: body,
                                encoding: URLEncoding.default,
                                headers: header)
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        //        let decoder = JSONDecoder()
        //
        //        guard let decodedData = try? decoder.decode(PostDataReponse.self, from: data)
        //        else { return .pathErr }
        //
        //        print(decodedData.result?.numOfHeart)
        
        switch statusCode{
        case 200: return isValidData(data: data)  // 성공 -> 데이터 가공해서 전달해야하므로 isValidData라는 함수로 데이터 넘겨주기
        case 400: return .pathErr  // 잘못된 요청
        case 500: return .serverErr  // 서버 에러
        default: return .networkFail  // 네트워크 에러
        }
    }
    
}

