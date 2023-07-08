//
//  ExploreTabViewController.swift
//  pochak
//
//  Created by Suyeon Hwang on 2023/07/04.
//

import UIKit

class PostTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func viewPostBtnTapped(_ sender: Any) {
        print("view post btn tapped")
        guard let postVC = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as? PostViewController else { return }
        print(postVC)
        self.navigationController?.pushViewController(postVC, animated: true)
//        let sb = UIStoryboard(name: "PostTab", bundle: nil)
//        let postVC = sb.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
//        postVC.modalPresentationStyle = .fullScreen
//        self.present(postVC, animated: true, completion: nil)
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
