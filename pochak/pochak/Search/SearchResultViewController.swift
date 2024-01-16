
//
//  SearchResultViewController.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

import Foundation
import UIKit

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchData : [idSearchResponse] = []

    var isFiltering: Bool = false

    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        setupTableView()
        setUpSearchController()
        
        searchData = CoreDataManager.shared.loadFromCoreData(request: )
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
        tableView.isHidden = true

        tableView.register(UINib(nibName: "SearchResultTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchResultTableViewCell")

        
    }

}

//MARK: - 서치바 tableView
extension SearchResultViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell

        let urls = self.searchData.map { $0.profileUrl }
        let handles = self.searchData.map { $0.userHandle }
        
        cell.userHandle.text = handles[indexPath.item]
        cell.configure(with: urls[indexPath.item])
        cell.deleteBtn.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀을 선택했을 때 수행할 동작을 여기에 추가합니다.
        // 예를 들어, 선택한 셀의 정보를 가져와서 처리하거나 화면 전환 등을 수행할 수 있습니다.

        let selectedUserData = searchData[indexPath.row] // 선택한 셀의 데이터 가져오기
        let handles = self.searchData.map { $0.userHandle }
        
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
        self.filterredArr = self.arr.filter { $0.localizedCaseInsensitiveContains(text) }
       
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
