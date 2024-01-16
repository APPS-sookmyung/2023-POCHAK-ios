
//
//  SearchResultViewController.swift
//  pochak
//
//  Created by 장나리 on 12/27/23.
//

//import AVFoundation
//import UIKit
//import SwiftUI
//

//class SearchResultViewController: UIViewController,UISearchResultsUpdating {
//    
//    var tableView: UITableView = {
//            let tableView = UITableView()
//            tableView.translatesAutoresizingMaskIntoConstraints = false
//            return tableView
//        }()
    
//    var leftLabel: UILabel = {
//            let label = UILabel()
//            label.translatesAutoresizingMaskIntoConstraints = false
//            label.text = "Left Label"
//            return label
//        }()
//
//    var rightLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "Right Label"
//        label.textAlignment = .right
//        return label
//    }()
//    
//    var searchController = UISearchController(searchResultsController: SearchResultViewController())
//    
//    let resultVC = SearchResultViewController()
//    
//    var searchResultData: String?
//    var isInputText: Bool = false // Boolean 값
//
//    var searchResults: [String] = [] // 검색 결과를 저장할 배열
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setUpSearchController()
//        
//        setupTableView()
//        
//        if let result = searchResultData {
//            print(result)
//        }
//        
//    }
//    
//    private func setupTableView(){
//        
//        view.addSubview(leftLabel)
//        view.addSubview(rightLabel)
//        view.addSubview(tableView)
//               
//        // Constraints 설정 (예시)
//        
//        leftLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
//        leftLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
//
//        rightLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
//        rightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
//
//        tableView.topAnchor.constraint(equalTo: leftLabel.bottomAnchor, constant: 20).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
       
//        
//        //delegate 연결
//        
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        // TableView에 사용될 셀 등록
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
//
//    }
//    
//    private func setUpSearchController() {
//        
//        // This view controller is interested in table view row selections.
//        
//        searchController = UISearchController(searchResultsController: resultVC)
//        searchController.searchBar.tintColor = .black
//        searchController.searchResultsUpdater  = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
//        // Change Cancel button value
//        searchController.searchBar.setValue("취소", forKey: "cancelButtonText")
//
//        //usally good to set the presentation context
//        
//        
//        navigationItem.searchController = searchController
//        
//        searchController.searchBar.sizeToFit()
//
//        activateSearchBar()
//
//   }
//    
//    private func activateSearchBar() {
//            DispatchQueue.main.async { [weak self] in
//                self?.searchController.isActive = true
//                self?.searchController.searchBar.becomeFirstResponder()
//            }
//        }
//    
//    // UISearchResultsUpdating 프로토콜 메서드 구현
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let searchText = searchController.searchBar.text else {
//            return
//        }
//        // searchText를 사용하여 검색을 수행하고 결과를 searchResults 배열에 저장
//        // 이후, 테이블 뷰를 업데이트하여 새로운 결과를 표시
//        searchResults = performSearch(with: searchText)
////        tableView.reloadData()
//    }
//    
//    // 검색을 수행하는 로직을 처리하는 메서드
//    func performSearch(with searchText: String) -> [String] {
//        // 검색 로직을 수행하고 검색 결과를 반환
//        // 예를 들어, 데이터 소스에서 검색어와 일치하는 항목을 찾는 등의 작업을 수행
//        
//        // 여기에 실제 검색 로직을 구현하고 검색 결과를 반환
//        // 검색 결과는 해당하는 항목의 배열로 표현되어야 함
//        return []
//    }
//    
//}
//
//extension SearchResultViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        0
//    }
//}
//
//extension SearchResultViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
//        cell.userHandle.text = "jisoo"
//        return cell
//    }
//}

import Foundation
import UIKit

class SearchResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! SearchResultTableViewCell
        cell.userHandle.text = "jisoo"
        return cell
    }
}

//extension SearchResultViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//}
//
//extension SearchResultViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! SearchResultTableViewCell
//
//        cell.nickname.text = "jisoo"
//        return cell
//    }
//}
