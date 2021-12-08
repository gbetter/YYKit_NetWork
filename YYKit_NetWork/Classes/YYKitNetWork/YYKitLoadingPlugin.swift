//
//  YYKitLoadingPlugin.swift
//  YYKit_NetWork
//
//  Created by 张振岳 on 2021/12/2.
//

import Foundation
import Moya
import iProgressHUD


struct YYKitLoadingPlugin: PluginType {
    
    /// Called to modify a request before sending.
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var mRequest = request
        if let target = target as? YYKitTargetType {
            mRequest.timeoutInterval = target.timeOut
        }
        
        return mRequest
    }

    /// Called immediately before a request is sent over the network (or stubbed).
    func willSend(_ request: RequestType, target: TargetType) {
        
        if let target = target as? YYKitTargetType {
            if target.isShowHUD {
                //显示 HUD
                DispatchQueue.main.async {
                    let keyViewController = UIApplication.shared.keyWindow
                    if (keyViewController != nil) {
                        
                        let progressHud = iProgressHUD.sharedInstance()
                        progressHud.isTouchDismiss = true
                        progressHud.attachProgress(toView: keyViewController!)
                        
                        keyViewController!.showProgress()
                    }
                }
            }
        }
    }

    /// Called after a response has been received, but before the MoyaProvider has invoked its completion handler.
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
        iProgressHUD.sharedInstance().dismiss()
        DispatchQueue.main.async {
            
            let keyViewController = UIApplication.shared.keyWindow
            if (keyViewController != nil) {
                keyViewController!.dismissProgress()
            }
        }
    }

    
}

