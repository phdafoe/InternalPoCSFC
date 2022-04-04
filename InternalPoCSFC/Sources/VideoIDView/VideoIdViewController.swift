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
        self.clearCache()
        self.model = UserDataModel().fetchUserDataModel()
        self.myWebView.navigationDelegate = self
        guard let modelUnw = self.model else { return }
        self.loadWebView(dni: modelUnw.dni ?? "", email: modelUnw.telefono ?? "", telefono: modelUnw.email ?? "")
    }

    // MARK: - Private methods
    private func clearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
    
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
