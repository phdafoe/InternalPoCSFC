//
//  LandingViewController.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 19/4/22.
//

import UIKit

class LandingViewController: UIViewController {
    
    
    
    @IBAction func dismissLandingView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goCDWebView(_ sender: Any) {
        let vc = VideoIdCoordinator.view(delegate: self)
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

extension LandingViewController: VideoIdViewControllerDelegate {
    func dismissVideoId(_ viewController: UIViewController, isDismiss: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
}

