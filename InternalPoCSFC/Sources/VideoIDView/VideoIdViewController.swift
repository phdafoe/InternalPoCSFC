//
//  VideoIdViewController.swift
//  InternalPoCSFC
//
//  Created by TECDATA ENGINEERING on 23/3/22.
//

import UIKit
import WebKit

protocol VideoIdViewControllerDelegate: AnyObject {
    func dismissVideoId(_ viewController: UIViewController, isDismiss: Bool)
}

class VideoIdViewController: UIViewController {
    
    // MARK: - Variables
    var model: UserDataModel?
    let isRecoverAuthentication = true
    weak var delegate: VideoIdViewControllerDelegate?
    
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
        self.loadWebView(userData: modelUnw)
    }
    
    private func loadWebView(userData: UserDataModel){
        // Control ENVIRONMENT
    #if PRO
        // load WebView
        if isRecoverAuthentication{
            guard let url = self.urlForLoadWebView(isRecoverAuthentication: isRecoverAuthentication,
                                                   userData: userData,
                                                   baseURLParameters: Utils.Constants.urlProWithData) else { return }
            self.myWebView.load(URLRequest(url: url))
        } else {
            guard let url = self.urlForLoadWebView(isRecoverAuthentication: isRecoverAuthentication,
                                                   userData: userData,
                                                   baseURLParameters: Utils.Constants.urlProWithoutData) else { return }
            self.myWebView.load(URLRequest(url: url))
        }
    #else
        if isRecoverAuthentication{
            guard let url = self.urlForLoadWebView(isRecoverAuthentication: isRecoverAuthentication,
                                                   userData: userData,
                                                   baseURLParameters: Utils.Constants.urlCuaWithData) else { return }
            self.myWebView.load(URLRequest(url: url))
        } else {
            guard let url = self.urlForLoadWebView(isRecoverAuthentication: isRecoverAuthentication,
                                                   userData: userData,
                                                   baseURLParameters: Utils.Constants.urlCuaWithoutData) else { return }
            self.myWebView.load(URLRequest(url: url))
        }
    #endif

    }
    
    private func urlForLoadWebView(isRecoverAuthentication: Bool, userData: UserDataModel, baseURLParameters: String) -> URL?{
        var urlCaptaciónPass: URL?
        if isRecoverAuthentication{
            let userData = UserData(dni: userData.dni, movil: userData.telefono, email: userData.email)
            // Encode ModelData for put information in WebView
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(userData) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    // Control encode base64, for security parameters in url
                    guard let urlUnw = URL(string: "\(baseURLParameters+(jsonString.base64Encoded() ?? ""))") else { return nil }
                    urlCaptaciónPass = urlUnw
                    // Control internal log's
                    debugPrint(urlCaptaciónPass!)
                }
            }
        }else {
            guard let urlUnw = URL(string: "\(baseURLParameters)") else { return nil }
            urlCaptaciónPass = urlUnw
        }
        return urlCaptaciónPass
    }

}

// MARK: - VideoIdViewController: WKNavigationDelegate
extension VideoIdViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        debugPrint(navigationAction.request.url?.absoluteString ?? "")
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
        debugPrint(navigationResponse.response.url?.absoluteString ?? "")
        
        guard let endNativeFlowErrorUnw = navigationResponse.response.url?.absoluteString.contains("?end=true") else { return }
        guard let nativeErrorUnw = navigationResponse.response.url?.absoluteString.contains("?retry=false&end=true") else { return }
        guard let nativeErrorSEUnw = navigationResponse.response.url?.absoluteString.contains("?card=false") else { return }
        guard let successUnw = navigationResponse.response.url?.absoluteString.contains("?success=true") else { return }
        
        if endNativeFlowErrorUnw {
            self.dismiss(animated: false, completion: {
                self.delegate?.dismissVideoId(self, isDismiss: true)
            })
        } else if nativeErrorUnw {
            debugPrint("\(nativeErrorUnw)")
            // View native retry error
            let errorVC = ErrorCoordinator.view(delegate: self, dto: MessageDTO(title: "Lo Sentimos",
                                                                                message: "Hemos llegado al máximo de reintentos en una sesión, por favor inténtalo más tarde.",
                                                                                messageTwo: ""))
            errorVC.modalPresentationStyle = .fullScreen
            self.present(errorVC, animated: true, completion: nil)
            
        } else if nativeErrorSEUnw{
            debugPrint("\(nativeErrorSEUnw)")
            // View native SE error
            let errorVC = ErrorCoordinator.view(delegate: self, dto: MessageDTO(title: "Lo sentimos, después de estudiar tu información, te informamos de que tu solicitud de Tarjeta PASS no ha sido aprobada.",
                                                                                message: "Gracias por confiar en Servicios Financieros Carrefour E.F.C. S.A.",
                                                                                messageTwo: "Un cordial saludo."))
            errorVC.modalPresentationStyle = .fullScreen
            self.present(errorVC, animated: true, completion: nil)
            
        } else if successUnw {
            debugPrint("\(successUnw)")
            // View final Success
            let exitoVC = ExitoCoordinator.view(delegate: self)
            exitoVC.modalPresentationStyle = .fullScreen
            self.present(exitoVC, animated: true, completion: nil)
        }
    }
    
    // Handling links containing untrusted certificates only CUA
    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let exceptions = SecTrustCopyExceptions(serverTrust)
        SecTrustSetExceptions(serverTrust, exceptions)
        completionHandler(.useCredential, URLCredential(trust: serverTrust));
    }
}


extension VideoIdViewController: ExitoViewControllerDelegate, ErrorViewControllerDelegate {
    func dismissSuccessVC(_ viewController: UIViewController, isDismiss: Bool) {
        if isDismiss{
            self.dismiss(animated: false, completion: {
                self.delegate?.dismissVideoId(self, isDismiss: true)
            })
            
        }
    }
    
    func dismissErrorVC(_ viewController: UIViewController, isDismiss: Bool) {
        if isDismiss{
            self.dismiss(animated: false, completion: {
                self.delegate?.dismissVideoId(self, isDismiss: true)
            })
            
        }
    }
}
