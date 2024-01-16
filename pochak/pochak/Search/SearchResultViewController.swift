
//
//  SearchResultViewController.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

import Foundation
import UIKit
import RealmSwift

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchData : [idSearchResponse] = []

    var isFiltering: Bool = false

    let searchBar = UISearchBar()
    
    let realm = try! Realm()
    
    @IBOutlet weak var deleteAllButton: UILabel!
    
    var realmManager = RecentSearchRealmManager()
    var recentSearchTerms: Results<RecentSearchModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        setupTableView()
        setUpSearchController()
        
        loadRealm()
        
        labelClickGesture()
        
    }
    
    private func setUpSearchController() {
        self.searchBar.placeholder = "Search User"
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.navigationItem.titleView = searchBar
    }
    
    private func setupTableView(){
        print(tableView)
        //delegate 연결
        tableView.delegate = self
        tableView.dataSource = self

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
    
    private func labelClickGesture(){
        // UITapGestureRecognizer 생성
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))

        // 이미지뷰에 UITapGestureRecognizer 추가
        deleteAllButton.addGestureRecognizer(tapGesture)

        // 사용자 상호 작용을 가능하게 하려면 반드시 다음을 설정해야 합니다.
        deleteAllButton.isUserInteractionEnabled = true
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
}

//MARK: - 서치바 tableView
extension SearchResultViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("==count==")
        print(recentSearchTerms.count)
        return recentSearchTerms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell

        let recentSearchTerm = recentSearchTerms[indexPath.row]
        print(recentSearchTerm)
        print(recentSearchTerm.term)
        cell.userHandle.text = recentSearchTerm.term
        cell.configure(with: "https://pochak-image-upload-bucket.s3.ap-northeast-2.amazonaws.com/post/1ef9957a-ce37-4fe9-acce-13521add89d9sy1_35031014_02.jpg")
        // handle은 recentSearchTerm에 저장되어있음
        // handle을 검색해서 프로필을 가져오던지, 아니면 이미지 Url을 같이 저장하던지...
        
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
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀을 선택했을 때 수행할 동작을 여기에 추가합니다.
        // 예를 들어, 선택한 셀의 정보를 가져와서 처리하거나 화면 전환 등을 수행할 수 있습니다.

        let selectedUserData = recentSearchTerms[indexPath.row] // 선택한 셀의 데이터 가져오기
        let handles = self.recentSearchTerms.map { $0.term }
        
        // 화면전환
        
    }
}

//MARK: - 서치바 검색 액션
extension SearchResultViewController: UISearchBarDelegate {
    // 서치바에서 검색을 시작할 때 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
        self.searchBar.showsCancelButton = true
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = self.searchBar.text?.lowercased() else { return }
       
        self.tableView.reloadData()
    }
    
    // 서치바에서 검색버튼을 눌렀을 때 호출
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        guard let text = self.searchBar.text?.lowercased() else { return }
//        self.filterredArr = self.arr.filter { $0.localizedCaseInsensitiveContains(text) }
//       
        self.tableView.reloadData()
    }
    
    // 서치바에서 취소 버튼을 눌렀을 때 호출
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.isFiltering = false
        self.tableView.reloadData()
    }
    
    // 서치바 검색이 끝났을 때 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.reloadData()
    }
    
    // 서치바 키보드 내리기
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}
