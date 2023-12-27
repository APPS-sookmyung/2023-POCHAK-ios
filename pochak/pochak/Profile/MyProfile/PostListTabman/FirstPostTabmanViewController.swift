//
//  FirstPostTabmanViewController.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import UIKit

class FirstPostTabmanViewController: UIViewController {
    @IBOutlet weak var postCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Collection View 구현
        setupCollectionView()
    }
    

    // MARK: - Helper
    private func setupCollectionView() {
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
            
        // collection view에 셀 등록
        postCollectionView.register(
            UINib(nibName: "ProfilePostCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfilePostCollectionViewCell")
        }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FirstPostTabmanViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell 생성
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfilePostCollectionViewCell.identifier,
            for: indexPath) as? ProfilePostCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    // cell의 위 아래 간격을 정함
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 5
    }
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // cell 양 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = CGFloat((collectionView.frame.width - 10) / 3)
        return CGSize(width: width, height: width * 4 / 3)
    }
    
}
