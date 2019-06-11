//
//  AboutUsViewController.swift
//  medocpatient
//
//  Created by iAM on 24/01/19.
//  Copyright © 2019 kspl. All rights reserved.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController , WKNavigationDelegate {

    let urlstr = "http://ksoftpl.com/about-us"
    @IBOutlet var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // let webView = WKWebView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height - 64))
        let urlRequest = URLRequest(url: URL(string: urlstr)!)
        webView.load(urlRequest)
        webView.navigationDelegate = self
        //webView.evaluateJavaScript("document.getElementsByClassName(\"mylinkclass\").removeAttribute(\"href\");")

        //view.addSubview(webView)
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utilities.shared.ShowLoaderView(view: self.view, Message: "")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utilities.shared.RemoveLoaderView()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utilities.shared.RemoveLoaderView()
    }
//    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
//        guard navigationAction.navigationType == .other || navigationAction.navigationType == .reload  else {
//            decisionHandler(.cancel)
//            return
//        }
//        decisionHandler(.allow)
//    }
}
