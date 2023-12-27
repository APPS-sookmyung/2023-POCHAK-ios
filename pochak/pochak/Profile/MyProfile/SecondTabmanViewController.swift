//
//  SecondTabmanViewController.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import UIKit

class SecondTabmanViewController: UIViewController {

    @IBOutlet weak var followingCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
    }
    

    private func setupCollectionView() {
        followingCollectionView.delegate = self
        followingCollectionView.dataSource = self
            
        // collection view에 셀 등록
        followingCollectionView.register(
            UINib(nibName: "FollowingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FollowingCollectionViewCell")
        }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SecondTabmanViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell 생성
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FollowingCollectionViewCell.identifier,
            for: indexPath) as? FollowingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
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
