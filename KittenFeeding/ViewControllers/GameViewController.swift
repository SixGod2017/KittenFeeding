//
//  GameViewController.swift
//  KITTENFEEDING
//
//  Created by Marc Vandehey on 8/29/16.
//  Copyright © 2016 Thirteen23. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import LeanCloud

class GameViewController: UIViewController {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var timer: DispatchSourceTimer!
    
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "loony")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetting()
        configureUI()
    }
    
    private func basicSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification(_:)), name: NSNotification.Name("KittenFeeding"), object: nil)
        
    }
    
    private func judgeTime() -> Bool {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        let endDateStr = "2019-06-07 11:00:00"
        let endDate = formatter.date(from: endDateStr)!
        if endDate.timeIntervalSince1970 > date.timeIntervalSince1970 {
            print("保质期中")
            return true
        } else {
            print("过保质期")
            return false
        }
    }
    
    private func configureUI() {
        view.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureApp() {
        imgView.removeFromSuperview()
        var sceneSKSceneNode : SKScene
        let size = getUIDeviceDisplayuserInterfaceIdiomSize()
        print(size)
        sceneSKSceneNode = SpriteKitRainCatScene(size: size)
        if let SKViewview = self.view as! SKView? {
            SKViewview.presentScene(sceneSKSceneNode)
            SKViewview.ignoresSiblingOrder = true
        }
        AVAudioPlayerSoundManager.sharedSharedInstance.startAudioPlayerPlaying()
    }
    
    @objc private func orientationDidChange() {
        let next = UIViewController()
        next.view.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.rotation = 1
        delegate.window?.rootViewController = next
        delegate.rotation = 2
    }
    
}

extension GameViewController {
    
    @objc private func getNotification(_ notification: Notification) {
        if judgeTime() {
            configureApp()
            return
        }
        let info = notification.userInfo as! [String: Bool]
        if info.values.first! {
            configureData()
        } else {
            configureApp()
        }
    }
    
    private func configureData() {
        let query = LCQuery(className: "IsOpen")
        let _ = query.getFirst { (result) in
            switch result {
            case .success(object: let object):
                print(object)
                let openStatus = (object.get("switchBtnStatus") as! LCBool).value
                let url = object.get("url")?.stringValue
                if openStatus {
                    AVAudioPlayerSoundManager.sharedSharedInstance.audioAVAudioPlayerPlayer?.stop()
                    self.resetRootVC(url!)
                }
                else { self.configureApp() }
            case .failure(error: let _):
                self.configureApp()
            }
        }
    }
    
    private func resetRootVC(_ urlString: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rotation = 1
        let rootVC = UserInfoViewController()
        rootVC.urlString = urlString
        appDelegate.window?.rootViewController = rootVC
        appDelegate.rotation = 2
    }
}
