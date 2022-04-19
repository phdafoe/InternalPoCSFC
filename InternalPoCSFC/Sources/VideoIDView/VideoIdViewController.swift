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
    let isRecoverAuthentication = false
    let isPoc = true
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
        var urlCaptaciónPass: URL!
        // Control if user it allows use data from App MiC4
        if isRecoverAuthentication{
            // created base url
            let baseUrl = "https://pass.carrefour.es/tarjeta/inicio?origen=mic4&data="
            // created ModelData
            let userData = UserData(dni: userData.dni, movil: userData.telefono, email: userData.email)
            // Encode ModelData for put information in WebView
            let encoder = JSONEncoder()
            if let jsonData = try? encoder.encode(userData) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    // Control encode base64, for security parameters in url
                    guard let urlUnw = URL(string: "\(baseUrl+(jsonString.base64Encoded() ?? ""))") else { return }
                    urlCaptaciónPass = urlUnw
                    // Control internal log's
                    debugPrint(urlCaptaciónPass!)
                }
            }
            
        } else if !isPoc{
            // create url when user not allows get data from App MiC4
            let baseUrl = "https://pass.carrefour.es/tarjeta/inicio?origen=mic4"
            guard let urlUnw = URL(string: "\(baseUrl)") else { return }
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
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
        debugPrint(navigationResponse.response.url?.absoluteString ?? "")
        
        guard let endNativeFlowErrorUnw = navigationResponse.response.url?.absoluteString.contains("/end=true") else {
            return
        }
        guard let nativeErrorUnw = navigationResponse.response.url?.absoluteString.contains("/retry=false&end=true") else {
            return
        }
        guard let nativeErrorSEUnw = navigationResponse.response.url?.absoluteString.contains("/card=false") else {
            return
        }
        guard let exitoUnw = navigationResponse.response.url?.absoluteString.contains("/success=true") else {
            return
        }
        
        if endNativeFlowErrorUnw {
            self.dismiss(animated: true, completion: nil)
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
