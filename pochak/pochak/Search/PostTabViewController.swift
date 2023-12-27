//
//  ExploreTabViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/04.
//

import UIKit
import Kingfisher

class PostTabViewController: UIViewController, UISearchResultsUpdating{

    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchController = UISearchController(searchResultsController: SearchResultViewController())
    var resultVC = SearchResultViewController()
    var imageArray : [PostTabDataModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        
        setupCollectionView()
        setUpSearchController()
        
        setupData()
   // Do any additional setup after loading the view.
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
        //        UserFeedDataManager().getUserFeed(self)
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
        
        // This view controller is interested in table view row selections.
        
        searchController = UISearchController(searchResultsController: resultVC)
        searchController.searchBar.tintColor = .black
        searchController.searchResultsUpdater  = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        // Change Cancel button value
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")

        //usally good to set the presentation context
        self.definesPresentationContext = true
        
        
        navigationItem.searchController = searchController
        
        searchController.searchBar.sizeToFit()
   }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else  {
            return
        }
        print(text)
        sendTextToServer(text)
    }
    
    func sendTextToServer(_ searchText: String) {
        // searchText를 사용하여 서버에 요청을 보내는 로직을 작성
        // 예: Alamofire 등의 네트워킹 라이브러리를 사용하여 서버에 요청을 보낼 수 있음
        // Alamofire.request(...
        // 서버 요청을 보내는 코드 작성
    }
    
}
    
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
        print("view post btn tapped")
        var selectedData = imageArray[indexPath.item].postId
        let modifiedString = selectedData.replacingOccurrences(of: "#", with: "%23")

        guard let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as? PostViewController
            else { return }
        print(postVC)
        postVC.receivedData = modifiedString
        self.navigationController?.pushViewController(postVC, animated: true)
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
