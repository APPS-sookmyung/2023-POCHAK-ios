//
//  PostLikesViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/20.
//

import UIKit

class PostLikesViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableView의 프로토콜
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none  // cell 간 구분선 스타일

        // 셀 등록
        let nib = UINib(nibName: "LikedPeopleListTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LikedPeopleListTableViewCell")
    }

}

// MARK: - Extension
extension PostLikesViewController: UITableViewDelegate, UITableViewDataSource {
    // 한 섹션의 몇 개의 열
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    // 어떤 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikedPeopleListTableViewCell", for: indexPath) as? LikedPeopleListTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}
