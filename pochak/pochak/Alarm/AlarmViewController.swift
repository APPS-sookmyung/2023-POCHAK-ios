//
//  AlarmViewController.swift
//  pochak
//
//  Created by 장나리 on 2023/07/11.
//

import UIKit

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Pretendard-bold", size: 20)!]
        self.navigationItem.title = "알림"
        
        // Do any additional setup after loading the view.
        setupCollectionView()

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

    
    private func setupData(){
//        UserFeedDataManager().getUserFeed(self)
    }

}
extension AlarmViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 //아이템 개수
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlarmCollectionViewCell.identifier, for: indexPath) as? AlarmCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패")
            }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OtherCollectionViewCell.identifier, for: indexPath) as? OtherCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패2")
            }
            //                let itemIndex = indexPath.item
            //                if let cellData = self.userPosts{
            //                    // 데이터가 있는 경우, cell 데이터를 전달
            //                    cell.setupData(cellData[itemIndex].postImgUrl)
            //                }
            // <- 데이터 전달
            return cell
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

