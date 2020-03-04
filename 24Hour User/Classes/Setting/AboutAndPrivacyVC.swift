//
//  AboutAndPrivacyVC.swift
//  24Hour User
//
//  Created by mac on 16/07/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class AboutAndPrivacyVC: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let url = NSURL(fileURLWithPath: "http://24hdr.com/aboutus.html")
//        let request = NSURLRequest(url: url as URL)
//        webView.loadRequest(request as URLRequest)
//
        UIWebView.loadRequest(webView)(NSURLRequest(url: NSURL(string: "http://24hdr.com/aboutus.html")! as URL) as URLRequest)

//        webView.loadRequest(URL(""))
        // Do any additional setup after loading the view.
    }

    @IBAction func goback(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
