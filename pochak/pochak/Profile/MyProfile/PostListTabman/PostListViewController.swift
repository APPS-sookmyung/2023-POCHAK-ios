//
//  PostListViewController.swift
//  pochak
//
//  Created by Seo Cindy on 12/27/23.
//

import UIKit
import Tabman
import Pageboy

class PostListViewController: TabmanViewController {

    // Tabbar로 넘길 VC 배열 선언
    private var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tabman 사용
        /* 1. tab에 보여질 VC 추가 */
        if let firstVC = storyboard?.instantiateViewController(withIdentifier: "FirstPostTabmanVC") as? FirstPostTabmanViewController {
            viewControllers.append(firstVC)
        }
        if let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondPostTabmanVC") as? SecondPostTabmanViewController {
            viewControllers.append(secondVC)
        }
        self.dataSource = self

        /* 2. 바 생성 + tabbar 에 관한 디자인처리 */
        let bar = TMBar.TabBar()
        // 배경색
        bar.backgroundView.style = .clear
        bar.backgroundColor = UIColor(named: "navy00")
        bar.layout.alignment = .centerDistributed
        /* Baritem 등록 */
        addBar(bar, dataSource: self, at:.top)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
// DataSource Extension
extension PostListViewController: PageboyViewControllerDataSource, TMBarDataSource {

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
            let item = TMBarItem(title: "")
            item.image = UIImage(named: "pochaked_selected")
            return item
           case 1:
            let item = TMBarItem(title: "")
            item.image = UIImage(named: "pochak_selected")
            return item
           default:
               let title = "Page \(index)"
              return TMBarItem(title: title)
           }
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
