
//
//  SearchResultViewController.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

import Foundation
import UIKit
import RealmSwift

class RecentSearchViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    var isFiltering: Bool = false

    var searchController = UISearchController()

    var resultVC = UITableViewController()

    let realm = try! Realm()
    
    @IBOutlet weak var deleteAllButton: UILabel!
    
    var realmManager = RecentSearchRealmManager()
    var recentSearchTerms: Results<RecentSearchModel>!
    
    var searchResultData : [idSearchResponse] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("==RecentSearchViewController==")
        self.navigationItem.hidesBackButton = true
        setupTableView()
        setUpSearchController()
        
        loadRealm()
    }
    
    private func setUpSearchController() {
        // Create an instance of the view controller that will display search results
    
        
        searchController = UISearchController(searchResultsController: resultVC)
        searchController.searchBar.tintColor = .black
        searchController.searchResultsUpdater  = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.placeholder = "Search User"
        // Change Cancel button value
        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
        searchController.searchBar.autocapitalizationType = .none
        //usally good to set the presentation context
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = UISearchBar.Style.minimal

        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true
        
        searchController.searchBar.sizeToFit()
        
        // 검색 결과 tableview 세팅
        let horizontalSpacing: CGFloat = 24.0
        resultVC.tableView.contentInset = UIEdgeInsets(top: 0, left: horizontalSpacing, bottom: 0, right: horizontalSpacing)

        resultVC.tableView.delegate = self
        resultVC.tableView.dataSource = self
        resultVC.tableView.separatorStyle = .none
        resultVC.tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
    }
    
    private func setupTableView(){
        //delegate 연결
        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")
    }
    func addRealm(){
        let searchTermValue = "sdf"
        // Check if the term already exists in Realm
        if realm.objects(RecentSearchModel.self).filter("term == %@", searchTermValue).isEmpty {
            // Term does not exist, add it to Realm
            let searchTerm = RecentSearchModel(term: searchTermValue)
            try! realm.write {
                realm.add(searchTerm)
            }
            print("Term added to Realm")
        } else {
            // Term already exists, handle accordingly
            print("Term already exists in Realm")
        }
    }
    func loadRealm(){
        recentSearchTerms = realmManager.getAllRecentSearchTerms()
        print(recentSearchTerms)
        tableView.reloadData()
    }

    @objc func labelTapped() {
        print("deleteAll")
        if realmManager.deleteAllData() {
            // 데이터 삭제에 성공한 경우
            recentSearchTerms = realmManager.getAllRecentSearchTerms()
            tableView.reloadData()
        } else {
            // 데이터 삭제에 실패한 경우
            print("Failed to delete all data")
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else  {
            return
        }
        print(text)
        if(text != ""){
            sendTextToServer(text)
        }
        else{
            print("===text null ===")
            print(text)
            self.searchResultData = []
            self.resultVC.tableView.reloadData()
        }
    }
    
    func sendTextToServer(_ searchText: String) {
        // searchText를 사용하여 서버에 요청을 보내는 로직을 작성
        // 서버 요청을 보내는 코드 작성
        SearchDataService.shared.getIdSearch(keyword: searchText){ response in
            switch response {
            case .success(let data):
                print("success")
                print(data)
                self.searchResultData = data as! [idSearchResponse]
                DispatchQueue.main.async {
                    print("!!!!!!SearchResultData!!!!!! \(self.searchResultData)")
                    self.resultVC.tableView.reloadData() // collectionView를 새로고침하여 이미지 업데이트
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

//MARK: - 서치바 tableView
extension RecentSearchViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return recentSearchTerms.count
        } else if tableView == self.resultVC.tableView {
            return searchResultData.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
        if tableView == self.tableView {
            let recentSearchTerm = recentSearchTerms[indexPath.row]
            print(recentSearchTerm)
            print(recentSearchTerm.term)
            cell.userHandle.text = recentSearchTerm.term
            cell.configure(with: "https://pochak-image-upload-bucket.s3.ap-northeast-2.amazonaws.com/post/1ef9957a-ce37-4fe9-acce-13521add89d9sy1_35031014_02.jpg")
            // handle은 recentSearchTerm에 저장되어있음
            
    //        let urls = self.searchData.map { $0.profileUrl }
    //        let handles = self.searchData.map { $0.userHandle }
    //
    //        cell.userHandle.text = handles[indexPath.item]
    //        cell.configure(with: urls[indexPath.item])
            cell.deleteBtn.isHidden = false
            
            cell.deleteButtonAction = {
               // 버튼이 클릭되었을 때 실행할 코드
               print("Delete button tapped for term: \(recentSearchTerm.term)")
               
               // 해당 코드 실행
                self.realmManager.deleteRecentSearchTerm(term: recentSearchTerm.term)
               
               // 셀을 삭제하고 테이블뷰를 갱신할 경우
               tableView.reloadData()
           }
        } else if tableView == self.resultVC.tableView {
            let urls = self.searchResultData.map { $0.profileUrl }
            let handles = self.searchResultData.map { $0.userHandle }
            
            cell.userHandle.text = handles[indexPath.item]
            cell.configure(with: urls[indexPath.item])
            cell.deleteBtn.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let selectedUserData = recentSearchTerms[indexPath.row] // 선택한 셀의 데이터 가져오기
            let handle = selectedUserData.term
            realmManager.addRecentSearch(term: handle)
            self.tableView.reloadData()
            // 화면전환
            // TODO: handle 전달
            let storyboard = UIStoryboard(name: "ProfileTab", bundle: nil)
            let profileTabVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileViewController

            self.navigationController?.pushViewController(profileTabVC, animated: true)
            
        } else if tableView == self.resultVC.tableView {
            let selectedUserData = searchResultData[indexPath.row] // 선택한 셀의 데이터 가져오기
            let handle = selectedUserData.userHandle
            realmManager.addRecentSearch(term: handle)
            self.tableView.reloadData()

            // 화면전환 -> handle 전달
            // TODO: handle 전달
            let storyboard = UIStoryboard(name: "ProfileTab", bundle: nil)
            let profileTabVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileViewController

            self.navigationController?.pushViewController(profileTabVC, animated: true)
            
        }
    }
}
