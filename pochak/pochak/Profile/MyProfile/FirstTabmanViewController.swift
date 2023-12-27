//
//  FirstTabmanViewController.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import UIKit

class FirstTabmanViewController: UIViewController{
    @IBOutlet weak var followerCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Collection View 구현
        setupCollectionView()
    }
    

    // MARK: - Helper
    private func setupCollectionView() {
        followerCollectionView.delegate = self
        followerCollectionView.dataSource = self
            
        // collection view에 셀 등록
        followerCollectionView.register(
            UINib(nibName: "FollowerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FollowerCollectionViewCell")
        }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FirstTabmanViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell 생성
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FollowerCollectionViewCell.identifier,
            for: indexPath) as? FollowerCollectionViewCell else {
            return UICollectionViewCell()
        }
        
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
