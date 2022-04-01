//
//  ExitoViewController.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 28/3/22.
//

import UIKit

protocol ExitoViewControllerDelegate: AnyObject {
    func dismissSuccessVC(_ viewController: UIViewController, isDismiss: Bool)
}

class ExitoViewController: UIViewController {
    
    // MARK: - Variables
    weak var delegate: ExitoViewControllerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var finalizarBTN: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func finalizarACTION(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.dismissSuccessVC(self, isDismiss: true)
        }
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
