//
//  ExploreTabViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/04.
//

import UIKit

class PostTabViewController: UIViewController, UISearchResultsUpdating{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchController = UISearchController()
    var resultVC = UITableViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegate
        
        searchController = UISearchController(searchResultsController: resultVC)
        searchController.searchBar.tintColor = .black
        // Change Cancel button value
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")

        //usally good to set the presentation context
        self.definesPresentationContext = true
        
        
        navigationItem.searchController = searchController
        setupCollectionView()

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
            return 24
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else{
                fatalError("셀 타입 캐스팅 실패")
            }
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as? PostCollectionViewCell else{
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("view post btn tapped")
        guard let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as? PostViewController
            else { return }
        print(postVC)
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
        
        let section = indexPath.section
        switch section {
        case 0:
            return CGSize(width: 168, height: 230)
        default:
            return CGSize(width: 111, height: 128)
        }
    }
}

