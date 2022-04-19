//
//  HomeViewController.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 19/4/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func goLandingView(_ sender: Any) {
        let vc = LandingCoordinator.view()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
