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

    
    
    // MARK: - Properties
    @IBOutlet weak var tabBarHeaderCollectionView: UICollectionView!
    @IBOutlet weak var tabBarPageCollectionView: UICollectionView!
    
    // Tabbar로 넘길 VC 배열 선언
    private var viewControllers: [UIViewController] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - Add Navigation Item
        
        // Title : 데이터 받아와서 넣기
        self.navigationItem.title = "bbaek"
        
//        // Collection View
//        setupCollectionView()
        
        // Tabman 사용
        // tab에 보여질 VC 추가
        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "FirstTabVC") as? FirstTabViewController {
                    viewControllers.append(firstVC)
                }
        if let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondTabVC") as? SecondTabViewController {
                    viewControllers.append(secondVC)
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
    
    
    // MARK: - 상단 탭바 직접 구현해보기
    /*
     <구현 아이디어>
     1. 페이지 구분 -> UICollectionView : scrollView의 scrollDirection = .horizontal 사용
     2. 현재 페이지 표시 -> UIView(Indicator View)
     3. 콘텐츠 표시 -> UICollectionView
     
     <로직 설계>
     state : targetIndex(목표 페이지) / currentIndex(현재 페이지)
     상단 스크롤, 하단 콘텐츠 모두 클라이언트 코드(FollowListViewController) 쪽 한 곳에서 관리
     */
    
//    // Tab Header View 구현
//    private func setupCollectionView(){
//        tabBarHeaderCollectionView.delegate = self
//        tabBarHeaderCollectionView.dataSource = self
//
//        // Cell 등록
//        tabBarHeaderCollectionView.register(
//            UINib(nibName: "TabbarHeadingCollectionViewCell", bundle: nil),
//            forCellWithReuseIdentifier: TabbarHeadingCollectionViewCell.identifier)
//
//    }
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FollowListViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // cell 생성
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TabbarHeadingCollectionViewCell.identifier,
            for: indexPath) as? TabbarHeadingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    
}

// CollecitonView 사이즈 조절
extension FollowListViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tabBarHeaderCollectionView.frame.width/2,
                      height: tabBarHeaderCollectionView.frame.height)
    }
}

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
        return nil
        
        // return .at(index: 0) -> index를 통해 처음에 보이는 탭을 설정할 수 있다.
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
