//
//  YYKitTargetType.swift
//  YYKit_NetWork
//
//  Created by 张振岳 on 2021/11/29.
//

import UIKit
import Moya
import HandyJSON

fileprivate let YYKIT_TOKEN = "token"

public protocol YYKitTargetType:TargetType {
    
    // 是否显示 HUD
    var isShowHUD:Bool { get }
    
    //转换的 Model 类型
    var handyJSONType:HandyJSON.Type { get }
    
    //超时时间
    var timeOut:TimeInterval { get }
    
    //缓存时长 s
    var timeCache:TimeInterval { get }
    
}

extension YYKitTargetType {
    /// The target's base `URL`.
    public var baseURL: URL {
        return URL(string: "https://wxmini.baixingliangfan.cn/baixing/")!
    }

    /// The HTTP method used in the request.
    public var method: Moya.Method {
        return .post
    }

    /// Provides stub data for use in testing. Default is `Data()`.
    public var sampleData: Data {
        return Data()
    }

    /// The type of HTTP task to be performed.
    public var task: Task {
        return .requestPlain
    }

    /// The type of validation to perform on the request. Default is `.none`.
    public var validationType: ValidationType {
        return .none
    }

    /// The headers to be used in the request.
    public var headers: [String: String]? {
        return [YYKIT_TOKEN:""]
    }
    
    // 是否显示 HUD
    public var isShowHUD:Bool {
        return false
    }
    
    //转换的 Model 类型
    public var handyJSONType:HandyJSON.Type {
        return YYKitBaseModel.self
    }
    
    //超时时间
    public var timeOut:TimeInterval {
        return 15
    }
    
    //缓存时长 s
    public var timeCache:TimeInterval {
        return 0
    }
}


public enum YYKitMultiTarget : YYKitTargetType {
    
    
    /// The embedded `TargetType`.
    case target(YYKitTargetType)

    /// Initializes a `MultiTarget`.
    public init(_ target: YYKitTargetType) {
        self = YYKitMultiTarget.target(target)
    }
    
    /// The embedded `TargetType`.
    public var target: YYKitTargetType {
        switch self {
        case .target(let target): return target
        }
    }
    
    /// The target's base `URL`.
    public var baseURL: URL {
        return target.baseURL
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    public var path: String {
        return target.path
    }
    
    /// The HTTP method used in the request.
    public var method: Moya.Method {
        return target.method
    }

    /// Provides stub data for use in testing. Default is `Data()`.
    public var sampleData: Data {
        return target.sampleData
    }

    /// The type of HTTP task to be performed.
    public var task: Task {
        return target.task
    }

    /// The type of validation to perform on the request. Default is `.none`.
    public var validationType: ValidationType {
        return target.validationType
    }

    /// The headers to be used in the request.
    public var headers: [String: String]? {
        return target.headers
    }
    
    // 是否显示 HUD
    public var isShowHUD:Bool {
        return target.isShowHUD
    }
    
    //转换的 Model 类型
    public var handyJSONType:HandyJSON.Type {
        return target.handyJSONType
    }
    
    //超时时间
    public var timeOut:TimeInterval {
        return target.timeOut
    }
    
    //缓存时长 s
    public var timeCache:TimeInterval {
        return target.timeCache
    }
    
}
