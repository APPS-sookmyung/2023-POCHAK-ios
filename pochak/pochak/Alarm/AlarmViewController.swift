//
//  AlarmViewController.swift
//  pochak
//
//  Created by 장나리 on 2023/07/11.
//

import UIKit

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var responseData : AlarmResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-bold", size: 20)!]
        self.navigationItem.title = "알림"
        
        // Do any additional setup after loading the view.
        setupCollectionView()
        loadAlarmData()
        

    }
    private func setupCollectionView(){
        //delegate 연결
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //cell 등록
        collectionView.register(UINib(
            nibName: "AlarmCollectionViewCell",
            bundle: nil),
            forCellWithReuseIdentifier: AlarmCollectionViewCell.identifier)
        
        collectionView.register(UINib(
            nibName: "OtherCollectionViewCell",
            bundle: nil),
            forCellWithReuseIdentifier: OtherCollectionViewCell.identifier)
    }

    func loadAlarmData(){
        AlarmDataService.shared.getAlarm{ [self]
            response in
            switch response {
            case .success(let data):
                print("success")
                if let alarmResponse = data as? AlarmResponse {
                    // 다운캐스팅 성공 시 데이터를 AlarmResponse로 변환하여 사용 가능
                    // alarmResponse를 사용하여 원하는 작업을 수행할 수 있습니다.
                    self.responseData = alarmResponse
                } else {
                    // 다운캐스팅 실패 시, 잘못된 데이터 형식이라고 가정하고 에러를 처리하거나 다른 작업을 수행합니다.
                    print("Failed to cast to AlarmResponse")
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData() // collectionView를 새로고침하여 이미지 업데이트
                }
            case .requestErr(let err):
                print(err)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
        
    }

}
extension AlarmViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(self.responseData?.result.alarmList.count)
        return self.responseData?.result.alarmList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(self.responseData?.result.alarmList[indexPath.item].alarmType == "COMMENT"){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherCollectionViewCell.identifier, for: indexPath) as? OtherCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패")
            }
            if let userSentAlarmHandle = self.responseData?.result.alarmList[indexPath.item].userSentAlarmHandle {
                // 옵셔널이 아닌 문자열 값을 추출하여 사용합니다.
                cell.comment.text = "\(userSentAlarmHandle) 님이 댓글을 달았습니다."
            }
            if let image = self.responseData?.result.alarmList[indexPath.item].userSentAlarmProfileImage{
                cell.configure(with: image)

            }
            return cell
        }
        else if(self.responseData?.result.alarmList[indexPath.item].alarmType == "FOLLOW"){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherCollectionViewCell.identifier, for: indexPath) as? OtherCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패")
            }
            if let userSentAlarmHandle = self.responseData?.result.alarmList[indexPath.item].userSentAlarmHandle {
                // 옵셔널이 아닌 문자열 값을 추출하여 사용합니다.
                cell.comment.text = "\(userSentAlarmHandle) 님이 회원님을 팔로우했습니다."
            }
            if let image = self.responseData?.result.alarmList[indexPath.item].userSentAlarmProfileImage{
                cell.configure(with: image)

            }
            return cell
        }
        else if(self.responseData?.result.alarmList[indexPath.item].alarmType == "LIKE"){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherCollectionViewCell.identifier, for: indexPath) as? OtherCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패")
            }
            if let userSentAlarmHandle = self.responseData?.result.alarmList[indexPath.item].userSentAlarmHandle {
                // 옵셔널이 아닌 문자열 값을 추출하여 사용합니다.
                cell.comment.text = "\(userSentAlarmHandle) 님이 좋아요를 눌렀습니다."
            }
            if let image = self.responseData?.result.alarmList[indexPath.item].userSentAlarmProfileImage{
                cell.configure(with: image)

            }
            return cell
        }
        else if(self.responseData?.result.alarmList[indexPath.item].alarmType == "POST_REQUEST"){
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlarmCollectionViewCell.identifier, for: indexPath) as? AlarmCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패")
            }
            if let userSentAlarmHandle = self.responseData?.result.alarmList[indexPath.item].userSentAlarmHandle {
                // 옵셔널이 아닌 문자열 값을 추출하여 사용합니다.
                cell.comment.text = "\(userSentAlarmHandle) 님이 회원님을 포착했습니다."
            }
            if let image = self.responseData?.result.alarmList[indexPath.item].userSentAlarmProfileImage{
                cell.configure(with: image)

            }
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlarmCollectionViewCell.identifier, for: indexPath) as? AlarmCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패")
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.responseData?.result.alarmList[indexPath.item].alarmType == "COMMENT"){
            // 게시물로 이동
//            var selectedData = self.responseData?.result.alarmList[indexPath.item]
//            let modifiedString = selectedData.replacingOccurrences(of: "#", with: "%23")

            guard let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as? PostViewController
                else { return }
            print(postVC)
//            postVC.receivedData = modifiedString
            self.navigationController?.pushViewController(postVC, animated: true)
        }
        else if(self.responseData?.result.alarmList[indexPath.item].alarmType == "FOLLOW"){
            // 화면전환 -> handle 전달
            // TODO: handle 전달
            let storyboard = UIStoryboard(name: "ProfileTab", bundle: nil)
            let profileTabVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileViewController

            self.navigationController?.pushViewController(profileTabVC, animated: true)
            
        }
        else if(self.responseData?.result.alarmList[indexPath.item].alarmType == "LIKE"){
            // 게시물로 이동
//            var selectedData = self.responseData?.result.alarmList[indexPath.item]
//            let modifiedString = selectedData.replacingOccurrences(of: "#", with: "%23")

            guard let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as? PostViewController
                else { return }
            print(postVC)
//            postVC.receivedData = modifiedString
            self.navigationController?.pushViewController(postVC, animated: true)
            
        }
        else if(self.responseData?.result.alarmList[indexPath.item].alarmType == "POST_REQUEST"){
            // 게시물 미리보기
            
        }
        else{
            
        }
        
    }
}
    
    extension AlarmViewController: UICollectionViewDelegateFlowLayout {
        
        // 위 아래 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        // 옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
        
        // cell 사이즈( 옆 라인을 고려하여 설정 )
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = collectionView.frame.width
            
            let size = CGSize(width: width, height: width)
            return size
        }
    }

