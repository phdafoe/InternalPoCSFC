//
//  VideoIdViewController.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 23/3/22.
//

import UIKit
import WebKit

class VideoIdViewController: UIViewController {
    
    // MARK: - Variables
    var model: UserDataModel?
    let isLogged = false
    let isPoc = true
    
    // MARK: - IBOutlets
    @IBOutlet weak var myWebView: WKWebView!
    
        
    // MARK: - Cycle life
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clear cache
        Utils.shared.clearCache()
        // Control model data
        self.model = UserDataModel().fetchUserDataModel()
        guard let modelUnw = self.model else { return }
        // WebView + Delegate
        self.myWebView.navigationDelegate = self
        self.myWebView.configuration.preferences.javaScriptEnabled = true
        self.loadWebView(dni: modelUnw.dni ?? "", email: modelUnw.email ?? "", telefono: modelUnw.telefono ?? "")
    }
    
    private func loadWebView(dni: String, email: String, telefono: String){
        var urlCaptaciónPass: URL!
        // Control user logged or not
        if isLogged{
            // created url with parameters encode base 64
            let baseUrl = "https://pass.carrefour.es/tarjeta/personal?data="
            let parameters = "mic4&cod=WEBFD&dni=\(dni)&email=\(email)&telefono=\(telefono)".base64Encoded() ?? ""
            guard let urlUnw = URL(string: "\(baseUrl+parameters)") else { return }
            urlCaptaciónPass = urlUnw
            debugPrint(urlCaptaciónPass)
        } else if !isPoc{
            // create url for user not logged
            let baseUrl = "https://pass.carrefour.es/tarjeta/inicio?origen="
            let parameters = "mic4&cod=WEBFD".base64Encoded() ?? ""
            guard let urlUnw = URL(string: "\(baseUrl+parameters)") else { return }
            urlCaptaciónPass = urlUnw
        } else {
            let baseUrl = "https://prestamoscua.global.npsa.carrefour.es/documentacion"
            guard let urlUnw = URL(string: "\(baseUrl)") else { return }
            urlCaptaciónPass = urlUnw
        }
        // load WebView
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
        debugPrint("navigationResponse.response +\(navigationResponse.response)")
        
        guard let errorUnw = navigationResponse.response.url?.absoluteString.contains("errorSistema") else {
            return
        }
        
        guard let exitoUnw = navigationResponse.response.url?.absoluteString.contains("solicitudProcesadaOk") else {
            return
        }
        
        if errorUnw {
            debugPrint("\(errorUnw)")
            // Vista Error
            let errorVC = ErrorCoordinator.view(delegate: self)
            errorVC.modalPresentationStyle = .fullScreen
            self.present(errorVC, animated: true, completion: nil)
            
        } else if exitoUnw {
            debugPrint("\(exitoUnw)")
            // Vista Exito
            let exitoVC = ExitoCoordinator.view(delegate: self)
            exitoVC.modalPresentationStyle = .fullScreen
            self.present(exitoVC, animated: true, completion: nil)
        }
        
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
