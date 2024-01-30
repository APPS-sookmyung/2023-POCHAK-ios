//
//  FirstTabmanViewController.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import UIKit

class FirstTabmanViewController: UIViewController{
    @IBOutlet weak var followerCollectionView: UICollectionView!
        
    
    var imageArray : [MemberListDataModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Collection View 구현
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        // API
        loadFollowerListData()
    }


    // MARK: - Helper
    private func setupCollectionView() {
        followerCollectionView.delegate = self
        followerCollectionView.dataSource = self
            
        // collection view에 셀 등록
        followerCollectionView.register(
            UINib(nibName: "FollowerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FollowerCollectionViewCell")
        }

    private func loadFollowerListData() {
        let handle = "dxxynni" // !!임시 핸들!!
        FollowListDataManager.shared.followerDataManager(handle,{resultData in
            self.imageArray = resultData
            self.followerCollectionView.reloadData() // collectionView를 새로고침하여 이미지 업데이트
        })
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FirstTabmanViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(0,(imageArray.count))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell 생성
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FollowerCollectionViewCell.identifier,
            for: indexPath) as? FollowerCollectionViewCell else {
            return UICollectionViewCell()
        }
        let memberListData = imageArray[indexPath.item]
        // indexPath 안에는 섹션에 대한 정보, 섹션에 들어가는 데이터 정보 등이 있다
        cell.configure(memberListData)
        return cell
    }
    
    
}

// CollectionView Cell 크기(높이, 너비 지정)
extension FirstTabmanViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: followerCollectionView.bounds.width,
                      height: 80)
    }
}
