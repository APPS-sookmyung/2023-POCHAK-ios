//
//  HomeTabViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/05.
//

import UIKit
import Kingfisher

class HomeTabViewController: UIViewController {
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageArray: [HomeDataBody] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up collection view
        setupCollectionView()

        setupData()
        
        // 내비게이션 바에 로고 이미지
        let logoImage = UIImage(named: "logo_full.png")
        let logoImageView = UIImageView(image: logoImage)

        logoImageView.contentMode = .scaleAspectFit

        self.navigationItem.titleView = logoImageView
        
        // 네비게이션 바 줄 없애기
        //self.navigationController?.navigationBar.shadowImage = UIImage() -> 안됨
        // self.navigationController?.navigationBar.standardAppearance.shadowImage = UIImage() -> 안됨...
        self.navigationController?.navigationBar.standardAppearance.shadowColor = .white  // 스크롤하지 않는 상태
        self.navigationController?.navigationBar.scrollEdgeAppearance?.shadowColor = .white  // 스크롤하고 있는 상태
        
        // info 버튼
        //create a new button
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(UIImage(named: "ic_info"), for: .normal)
        button.addTarget(self, action: #selector(infoBtnTapped), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
        
        // back 버튼 커스텀
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    // MARK: - Action
    @objc func infoBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomeTab", bundle: nil)
        let infoVC = storyboard.instantiateViewController(withIdentifier: "InfoVC") as! InfoViewController
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    // MARK: - Helper
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
            
        // collection view에 셀 등록
        collectionView.register(
            UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
    }
    
    private func setupData(){
        // 임시로 유저 핸들 지수로
        HomeDataService.shared.getHomeData("dxxynni") { response in
            switch response {
            case .success(let data):
                self.imageArray = data as! [HomeDataBody]
                print(self.imageArray)
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

// MARK: - Extensions
extension HomeTabViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // section 당 아이템 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /* 추후 수정 */
        return imageArray.count
    }
    
    
    // cell 등록
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        else{ return UICollectionViewCell()}
        
        /* 추후 수정 필요*/
        // cell.setupData()
//        cell.imageView.kf.setImage(with: imageArray[indexPath.item].imgUrl)
        //url = URL(string: imageArray[indexPath.item].imgUrl)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: (self?.imageArray[indexPath.item].imgUrl!)!)!) {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                        cell.imageView.contentMode = .scaleAspectFill
                    }
                }
            }
        }
        return cell
    }
    
    /* 서버 연결 후 수정 */
    // cell 클릭 시 해당 게시물로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let postTabSb = UIStoryboard(name: "PostTab", bundle: nil)
        guard let postVC = postTabSb.instantiateViewController(withIdentifier: "PostVC") as? PostViewController
            else { return }
        
        postVC.receivedData = imageArray[indexPath.item].partitionKey!.replacingOccurrences(of: "#", with: "%23")
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
    // cell의 위 아래 간격을 정함
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 5
    }
    
    // cell 양 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // cell 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = CGFloat((collectionView.frame.width - 58) / 3)  // 24+24+5+5 = 58
        return CGSize(width: width, height: width * 4 / 3)  // 3:4 비율로
    }
}
