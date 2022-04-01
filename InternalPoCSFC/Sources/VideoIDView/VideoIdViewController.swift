//
//  VideoIdViewController.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 23/3/22.
//

import UIKit
import WebKit

class VideoIdViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var myWebView: WKWebView!
    var model: UserDataModel?
    let isLogged = false
        
    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = UserDataModel().fetchUserDataModel()
        self.myWebView.navigationDelegate = self
        guard let modelUnw = self.model else { return }
        self.loadWebView(dni: modelUnw.dni ?? "", email: modelUnw.telefono ?? "", telefono: modelUnw.email ?? "")
    }

    // MARK: - Private methods
    private func loadWebView(dni: String, email: String, telefono: String){
        var urlCaptaciónPass: URL!
        if isLogged{
            let baseUrl = "https://pass.carrefour.es/tarjeta/personal?origen="
            let parameters = "mic4&dni=\(dni)&email=\(email)&telefono=\(telefono)".base64Encoded() ?? ""
            guard let urlUnw = URL(string: "\(baseUrl+parameters)") else { return }
            urlCaptaciónPass = urlUnw
        } else {
            let baseUrl = "https://prestamoscua.global.npsa.carrefour.es/documentacion"
            guard let urlUnw = URL(string: "\(baseUrl)") else { return }
            urlCaptaciónPass = urlUnw
        }
        self.myWebView.load(URLRequest(url: urlCaptaciónPass))
    }

}

// MARK: - VideoIdViewController: WKNavigationDelegate
extension VideoIdViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        debugPrint("navigationAction.request + \(navigationAction.request.url?.absoluteString ?? "")")
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
        debugPrint("navigationResponse.response +\(navigationResponse.response.url?.absoluteString ?? "")")
        
        
        /*if ((navigationResponse.response.url?.absoluteString.contains("documentacion")) != nil){
            //debugPrint("\(errorUnw)")
            // Vista Error
            let errorVC = ErrorCoordinator.view(delegate: self)
            errorVC.modalPresentationStyle = .fullScreen
            self.present(errorVC, animated: true, completion: nil)
            
        } else if let exitoUnw = navigationResponse.response.url?.absoluteString.contains("solicitudProcesadaOk"){
            debugPrint("\(exitoUnw)")
            // Vista Exito
            let exitoVC = ExitoCoordinator.view(delegate: self)
            self.present(exitoVC, animated: true, completion: nil)
        }*/
    }
}


extension VideoIdViewController: ExitoViewControllerDelegate, ErrorViewControllerDelegate {
    func dismissSuccessVC(_ viewController: UIViewController, isDismiss: Bool) {
        if isDismiss{
           // Lo llevamos a la Home
        }
    }
    
    func dismissErrorVC(_ viewController: UIViewController, isDismiss: Bool) {
        if isDismiss{
           // Lo llevamos a la Home
        }
    }
}



