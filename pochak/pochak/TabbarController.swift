//
//  TabbarController.swift
//  pochak
//
//  Created by 장나리 on 2023/07/02.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 0
        self.tabBar.tintColor = UIColor(named: "navy00")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
