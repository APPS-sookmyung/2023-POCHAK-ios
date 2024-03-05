//
//  FollowListViewController.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import Tabman
import Pageboy
import UIKit

class FollowListViewController: TabmanViewController {
    
    // Tabbar로 넘길 VC 배열 선언
    var viewControllers: [UIViewController] = []
    var index: Int = 0
    var handle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Add Navigation Item
        
        // Title : 데이터 받아와서 넣기
        self.navigationItem.title = handle ?? ""
        
        // Tabman 사용
        // tab에 보여질 VC 추가
        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "FirstTabmanVC") as? FirstTabmanViewController {
            viewControllers.append(firstVC)
            firstVC.recievedHandle = handle ?? ""
        }
        if let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondTabmanVC") as? SecondTabmanViewController {
            viewControllers.append(secondVC)
            secondVC.recievedHandle = handle ?? ""
        }
        
        self.dataSource = self
        
        // 바 생성 + tabbar 에 관한 디자인처리를 여기서 하면 된다.
        let bar = TMBar.ButtonBar()
        //        bar.layout.transitionStyle = .none
        
        // 배경색
        bar.backgroundView.style = .clear
        
        // tab 밑 bar 색깔 & 크기
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = UIColor(named: "yellow00")
        
        // padding 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)

        // tap center
        bar.layout.alignment = .centerDistributed
        
        // tap 사이 간격
        bar.layout.contentMode = .fit //  버튼 화면에 딱 맞도록 구현
        //        bar.layout.interButtonSpacing = 20
        
        // tap 선택 / 미선택
        bar.buttons.customize { (button) in
            button.tintColor = .gray
            button.selectedTintColor = .black
            button.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            button.selectedFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        
        addBar(bar, dataSource: self, at:.top)
    }
    
}
// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
// DataSource Extension
extension FollowListViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        // index를 통해 처음에 보이는 탭을 설정할 수 있다.
         return .at(index: index)
    }
    
    // 추가 구현해야 하는 기능
    // 팔로워 / 팔로잉에 따라 defualtPage 다르게 하기
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
           case 0:
               return TMBarItem(title: "팔로워")
           case 1:
               return TMBarItem(title: "팔로잉")
           default:
               let title = "Page \(index)"
              return TMBarItem(title: title)
           }
    }
}
