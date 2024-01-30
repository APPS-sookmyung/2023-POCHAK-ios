//
//  SecondTabmanViewController.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import UIKit

class SecondTabmanViewController: UIViewController {

    @IBOutlet weak var followingCollectionView: UICollectionView!
    var imageArray : [MemberListDataModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        // API
        loadFollowingListData()
    }

    

    private func setupCollectionView() {
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
            
        // collection view에 셀 등록
        followingCollectionView.register(
            UINib(nibName: "FollowingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FollowingCollectionViewCell")
        }
    
    private func loadFollowingListData() {
        let handle = "dxxynni" // !!임시 핸들!!
        FollowListDataManager.shared.followingDataManager(handle,{resultData in
            self.imageArray = resultData
            self.followingCollectionView.reloadData() // collectionView를 새로고침하여 이미지 업데이트
        })
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SecondTabmanViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(0,(imageArray.count))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell 생성
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FollowingCollectionViewCell.identifier,
            for: indexPath) as? FollowingCollectionViewCell else {
            return UICollectionViewCell()
        }
        let memberListData = imageArray[indexPath.item]
        // indexPath 안에는 섹션에 대한 정보, 섹션에 들어가는 데이터 정보 등이 있다
        cell.configure(memberListData)
        return cell
    }
    
    
}

// CollectionView Cell 크기(높이, 너비 지정)
extension SecondTabmanViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: followingCollectionView.bounds.width,
                      height: 80)
    }
}
