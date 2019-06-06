//
//  UserInfoViewController.swift
//  KittenFeeding
//
//  Created by 顾大明 on 2019/6/2.
//  Copyright © 2019 Thirteen23. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    var urlString:String?
    
    lazy var webView: UIWebView = {
        let view = UIWebView()
        view.delegate = self
        return view
    }()
    
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrl()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    private func configureUI() {
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension UserInfoViewController: UIWebViewDelegate {
    private func loadUrl() {
        let url = URL(string: urlString!)!
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }
}
