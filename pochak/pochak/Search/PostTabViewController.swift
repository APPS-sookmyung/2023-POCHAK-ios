//
//  ExploreTabViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/04.
//

import UIKit
import Kingfisher

class PostTabViewController: UIViewController, UISearchBarDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    
    let searchBar = UISearchBar()

    var imageArray : [PostTabDataModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        
        setupCollectionView()
        setUpSearchController()
        
        setupData()
   // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clear search bar text and resign first responder when returning to this page
        self.searchBar.resignFirstResponder()
    }


    private func setupCollectionView(){
        //delegate 연결
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //cell 등록
        collectionView.register(UINib(
            nibName: "PostCollectionViewCell",
            bundle: nil),forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
    }

    private func setupData(){ // 서버 연결 시
        PostTabDataService.shared.recommandGet(){
            response in
                switch response {
                case .success(let data):
                    print("success")
                    print(data)
                    self.imageArray = data as! [PostTabDataModel]
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
    
    private func setUpSearchController() {
        self.searchBar.placeholder = "Search User"
        self.searchBar.delegate = self
        self.navigationItem.titleView = searchBar

   }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // 최근 검색어 화면으로 전환
        let storyboard = UIStoryboard(name:"PostTab", bundle: nil)
        let recentSearchVC = storyboard.instantiateViewController(withIdentifier: "RecentSearchVC") as! RecentSearchViewController
        self.navigationController?.pushViewController(recentSearchVC, animated: false)
        // 편집 모드를 시작하려면 true를 반환해야 합니다.
        return true
    }
    
}


//MARK: - 포스트 collectionView
extension PostTabViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return max(0,(imageArray.count)-2)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패")
            }
            // 이미지 설정
            if(!imageArray.isEmpty){
                cell.configure(with: imageArray[indexPath.item])
            }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패2")
            }
            // 이미지 설정            
            if(!imageArray.isEmpty){
                cell.configure(with: imageArray[indexPath.item+2])
            }
            
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        switch section {
        case 0:
            print("view post btn tapped")
            var selectedData = imageArray[indexPath.item].postId
            let modifiedString = selectedData.replacingOccurrences(of: "#", with: "%23")

            guard let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as? PostViewController
                else { return }
            print(postVC)
            postVC.receivedData = modifiedString
            self.navigationController?.pushViewController(postVC, animated: true)
        default:
            print("view post btn tapped")
            var selectedData = imageArray[indexPath.item+2].postId
            let modifiedString = selectedData.replacingOccurrences(of: "#", with: "%23")

            guard let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as? PostViewController
                else { return }
            print(postVC)
            postVC.receivedData = modifiedString
            self.navigationController?.pushViewController(postVC, animated: true)
        }
        
        //        let sb = UIStoryboard(name: "PostTab", bundle: nil)
        //        let postVC = sb.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        //        postVC.modalPresentationStyle = .fullScreen
        //        self.present(postVC, animated: true, completion: nil)
    }
}

        
extension PostTabViewController: UICollectionViewDelegateFlowLayout {
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
            
        case 0:
            return CGFloat(0)
        default:
            return CGFloat(4)
        }
    }

        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        }
    // 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
            case 0:
                return CGFloat(0)
            default:
                return CGFloat(1)
            }
        }

            
    // cell 사이즈( 옆 라인을 고려하여 설정 )
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 6) / 2 // 첫 번째 섹션의 셀 너비
        let height = width * 4 / 3 // 셀의 가로:세로 비율
        
        if indexPath.section == 0 {
            return CGSize(width: width, height: height) // 첫 번째 섹션의 셀 크기
        } else {
            let secWidth = (collectionView.frame.width - 10) / 3 // 두 번째 섹션의 셀 너비
            let secHeight = secWidth * 4 / 3 // 셀의 가로:세로 비율
            return CGSize(width: secWidth, height: secHeight) // 두 번째 섹션의 셀 크기
        }
    }
}

//extension PostTabViewController: UISearchControllerDelegate {
//    func willPresentSearchController(_ searchController: UISearchController) {
//        // 검색창이 표시될 때 실행되는 메서드
//        if searchController.searchBar.text?.isEmpty ?? true {
//            // 검색창에 아무런 텍스트가 없으면 최근 검색어 뷰를 보여줍니다.
//            self.resultVC.isHidden = false
//        }
//    }
//}
//
//extension PostTabViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            // 검색창에 아무런 텍스트가 없으면 최근 검색어 뷰를 보여줍니다.
//            self.resultVC.isHidden = false
//        } else {
//            // 검색창에 텍스트가 입력되었으면 최근 검색어 뷰를 숨깁니다.
//            self.resultVC.isHidden = true
//        }
//    }
//}
