//
//  YYKitNetWorkManager.swift
//  YYKit_NetWork
//
//  Created by 张振岳 on 2021/12/1.
//

import Foundation
import HandyJSON
import RxSwift
import Moya



public struct YYKitNetWorkManager {
    

    static let provider = MoyaProvider<YYKitMultiTarget>(plugins:[YYKitLoadingPlugin()])
    
    @discardableResult
    public static func request<T:HandyJSON>(_ target:YYKitMultiTarget) -> Observable<T> {
        
        if target.timeCache > 0 {
            //判定有无缓存数据
            
            let cacheName = YYKitCacheMananger.md5Hex(input: target.path)
            if let contentString = YYKitCacheMananger.fetchCacheData(fileName: cacheName) {

                if let data = contentString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                    return Observable.of(Response(statusCode: 200, data: data)).mapResponseToObject(type: T.self)
                }
            }
    
        }
        
        
        return provider.rx.request(target).asObservable().filter { response in
            
            //保存缓存
            if target.timeCache > 0 {
                let cacheName = YYKitCacheMananger.md5Hex(input: target.path)
                if let contentString = String(data: response.data, encoding: String.Encoding.utf8)  {
                    
                    guard let contentDic = YYKitCacheMananger.jsonToDictionary(jsonString: contentString)  else {
                        return true
                    }
                    
                    guard let code = contentDic["errorCode"] as? Int else {
                        return true
                    }
                    
                    if code == YYKitRequestStatus.requestSuccess.rawValue {
                        //请求成功：保存缓存
                        YYKitCacheMananger.fetchSaveCacheData(fileName: cacheName, cacheData: contentString)
                    }
                }
            }
            
            return true
        }.mapResponseToObject(type: T.self)
        
    }

    
}

