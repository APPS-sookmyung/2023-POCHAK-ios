//
//  PostDataService.swift
//  pochak
//
//  Created by Suyeon Hwang on 11/18/23.
//

import Alamofire

struct PostDataService{
    // static을 통해 shared 프로퍼티에 싱글턴 인스턴스 저장하여 생성
    // shared를 통해 여러 VC가 같은 인스턴스에 접근 가능
    static let shared = PostDataService()
    
    // 포스트 상세 페이지 가져오기
    // completion 클로저를 @escaping closure로 정의
    // -> getPersonInfo 함수가 종료되든 말든 상관없이 completion은 탈출 클로저이기 때문에, 전달된다면 이후에 외부에서도 사용가능
    // 네트워크 작업이 끝나면 completion 클로저에 네트워크의 결과를 담아서 호출하게 되고, VC에서 꺼내서 처리할 예정
    func getPostDetail(_ postId: String, completion: @escaping (NetworkResult<Any>) -> Void){
        // json 형태로 받아오기 위해
        // header 있는 자리! 토큰 때문에 이 줄은 삭제하고 커밋합니다
        
        
        // 임시로 사용하는 loginUser
        let body : Parameters = [
                    "loginUser": "jisoo"
                ]
        
        // JSONEncoding 인코딩 방식으로 헤더 정보와 함께
        // Request를 보내기 위한 정보
        let dataRequest = AF.request(APIConstants.baseURL+"/api/v1/post/"+postId,
                                    method: .get,
                                    parameters: body,
                                    encoding: URLEncoding.default,
                                    headers: header)
        
        // 통신 성공했는지에 대한 여부
        dataRequest.responseData { dataResponse in
            // dataResponse 안에는 통신에 대한 결과물
            // dataResponse.result는 통신 성공/실패 여부
            switch dataResponse.result{
            case .success:
                // 성공 시 상태코드와 데이터(value) 수신
                guard let statusCode = dataResponse.response?.statusCode else {return}
                guard let value = dataResponse.value else {return}
//                print("statusCode =")
//                print(statusCode)
//                print("description=")
//                print(value.description)
//                print("dataresponse = ")
//                print(dataResponse)
//                print("error")
//                print(dataResponse.error)
//                print("request")
//                print(dataResponse.request)
                let networkResult = self.judgeStatus(by: statusCode, value)
                //print(networkResult)
                completion(networkResult)
            case .failure:
                completion(.networkFail)
//                print("failed")
//                print(dataResponse)
            }
        }
    }
    
    // 요청 후 받은 statusCode를 바탕으로 어떻게 결과값을 처리할 지 정의
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
    
    // 통신 성공 시 데이터를 가공하기 위한 함수
    private func isValidData(data: Data) -> NetworkResult<Any> {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(PostDataResponse.self, from: data)
            return .success(decodedData)
        } catch {
            print("Decoding error:", error)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Received JSON: \(jsonString)")
            } else {
                print("Invalid JSON data received")
            }
            return .pathErr
        }
    }
}
