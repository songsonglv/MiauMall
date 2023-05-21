//
//  LoginManager.swift
//  LineLogin
//
//  Created by Tong on 2023/1/28.
//

import UIKit

import LineSDK
/// 登陆结果状态
@objc enum LoginResultStatus: NSInteger {
    case error
    case cancelled
    case success
}

class LineLogin: NSObject {
    private static var manager: LineLogin?
    @objc class func getSharedInstance() -> LineLogin {
        guard let instance = manager else {
            manager = LineLogin()
            return manager!
        }
        return instance
    }
    
    @objc class func registerLine() {
        let urlString:String = "https://app.miau2020.com/unishop/"
        LoginManager.shared.setup(channelID: "1660764018", universalLinkURL: URL(string: urlString))
    }
    
    @objc class func applicationOpenurl(_ app: UIApplication,
                                           open url: URL?) -> Bool {
        return LoginManager.shared.application(app, open: url)
    }
    
    @objc class func application(
        _ application: UIApplication,
        continueWithUserActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
            return LoginManager.shared.application(application, open: continueWithUserActivity.webpageURL)
        }
    
    @objc func loginLine(fromController: UIViewController, completeWithError: @escaping (_ loginStatus: LoginResultStatus, _ token: String?, _ name1: String? , _ pictureURL: URL? , _ email: String? , _ error: Error?) -> Void) {
        var param = LoginManager.Parameters.init()
        param.allowRecreatingLoginProcess = true
        LoginManager.shared.login(permissions: [.openID, .profile], in: fromController, parameters: param) { (result) in
            switch result {
            case .success(let loginResult):
                if let _ = loginResult.accessToken.IDTokenRaw {
                    completeWithError(.success, loginResult.accessToken.value, loginResult.userProfile?.displayName,loginResult.userProfile?.pictureURL,nil, nil)
                    print(loginResult.userProfile?.pictureURL?.scheme as Any)
                } else {
                    completeWithError(.success, "", "", nil,nil, nil)
                }
            case .failure(let error):
                print(error)
                completeWithError(.cancelled, "","", nil,nil, nil)
            }
        }
        
    }
    
    @objc class func destroyLine() {
        LineLogin.manager = nil
    }
}
