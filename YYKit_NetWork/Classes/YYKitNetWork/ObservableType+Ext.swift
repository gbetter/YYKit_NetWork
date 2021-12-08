//
//  ObservableType+Ext.swift
//  YYKit_NetWork
//
//  Created by 张振岳 on 2021/12/1.
//

import Foundation
import RxSwift
import Moya
import HandyJSON


enum YYKitRequestError : Swift.Error {
    case ParseJSONError
    case RequestFailed
    case NoResponse
    case UnexpectedResult(resultCode: Int?,resultMsg:String?)
}

enum YYKitRequestStatus: Int {
    case requestSuccess = 0
    case requestTokenError = 401
    case requestError
}

fileprivate let RESULT_CODE     = "errorCode"
fileprivate let RESULT_MSG      = "errorMsg"
fileprivate let RESULT_DATA     = "data"

public extension ObservableType {
    
    func mapResponseToObject<T: HandyJSON>(type: HandyJSON.Type) -> Observable<T> {
            return map { response in
                guard let response = response as? Moya.Response
                    else {
                        throw YYKitRequestError.NoResponse
                }
    //            guard ((200...209) ~= response.statusCode) else {
    //                throw YYKitRequestError.RequestFailed
    //            }

                ////////////////////////////////////////////////////////////
                guard var json = try?JSONSerialization.jsonObject(with: response.data, options: .mutableContainers) as? [String:Any] else {
                    throw YYKitRequestError.NoResponse
                }
                
                if let code = json[RESULT_CODE] as? Int {
                    if code == YYKitRequestStatus.requestSuccess.rawValue {
                        let data = json[RESULT_DATA]
                        
                        let objects = JSONDeserializer<T>.deserializeFrom(dict: data as? Dictionary)
                        
                        if objects != nil {
                            return objects!
                        }
                        
                        if let data = data as? Data {
                            let jsonString = String(data: data,encoding: .utf8)
                            let object = JSONDeserializer<T>.deserializeFrom(json: jsonString)
                            
                            
                            if object != nil {
                                return object!
                            }else {
                                return T()
                            }
                        }else {
                            return T()
                        }
                    }else if code == YYKitRequestStatus.requestTokenError.rawValue {
                        
                        // Tocken失效
                        
                        throw YYKitRequestError.UnexpectedResult(resultCode:json[RESULT_CODE] as? Int, resultMsg: nil)
                    }else {
                        throw YYKitRequestError.UnexpectedResult(resultCode:json[RESULT_CODE] as? Int, resultMsg: json[RESULT_MSG] as? String)
                    }
                }else {
                    throw YYKitRequestError.ParseJSONError
                }
                
            }
        }
        
        func mapResponseToObjectArray<T: HandyJSON>(type: T.Type) -> Observable<[T]> {
            return map { response in
                
                // 得到response
                guard let response = response as? Moya.Response else {
                    throw YYKitRequestError.NoResponse
                }
                
                // 检查状态码
    //            guard ((200...209) ~= response.statusCode) else {
    //                throw YYKitRequestError.RequestFailed
    //            }
                
                guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: Any]  else {
                    throw YYKitRequestError.NoResponse
                }
                
                // 服务器返回code
                if let code = json[RESULT_CODE] as? Int {
                    if code == YYKitRequestStatus.requestSuccess.rawValue {
                        guard let objectsArrays = json[RESULT_DATA] as? NSArray else {
                            throw YYKitRequestError.ParseJSONError
                        }
                        // 使用HandyJSON解析成对象数组
                        if let objArray = JSONDeserializer<T>.deserializeModelArrayFrom(array: objectsArrays) {
                            if let objectArray: [T] = objArray as? [T] {
                                return objectArray
                            }else {
                                return [T]()
                            }
                        }else {
                            return [T]()
                        }
                        
                    }else if code == YYKitRequestStatus.requestTokenError.rawValue {
                        
                        // Tocken失效 跳转登录
                        
                        return [T]()
                    } else {
                        throw YYKitRequestError.UnexpectedResult(resultCode: json[RESULT_CODE] as? Int , resultMsg: json[RESULT_MSG] as? String)
                        
                    }
                } else {
                    throw YYKitRequestError.ParseJSONError
                }
            }
        }

}
