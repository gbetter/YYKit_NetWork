//
//  YYKitCacheManager.swift
//  YYKit_NetWork
//
//  Created by 张振岳 on 2021/12/2.
//
//  缓存管理类

import Foundation
import CommonCrypto
import RxSwift


let kNetworkResponseCachePath = "kNetworkResponseCachePath"

public struct YYKitCacheMananger {
    
    static var fileManager: FileManager {
        return FileManager.default
    }
    
    //获取缓存数据
    @discardableResult
    internal static func fetchCacheData(fileName:String) -> String? {
        let cachePath = YYKitCacheMananger.fetchCachePath(fileName: fileName)
        
        guard fileManager.fileExists(atPath: cachePath.absoluteString) else {
            return nil
        }
        
        guard let contentData = fileManager.contents(atPath: cachePath.absoluteString) else {
            return nil
        }
        
        return String(data: contentData, encoding: String.Encoding.utf8)
    }
    
    
    //保存缓存数据
    @discardableResult
    internal static func fetchSaveCacheData(fileName:String,cacheData:String) -> Bool {

        let cachePath = YYKitCacheMananger.fetchCachePath(fileName: fileName)
        
        //包含缓存文件：删除
        if fileManager.fileExists(atPath: cachePath.absoluteString) {
            do {
                try fileManager.removeItem(at: cachePath)
            } catch _ {
                
            }
        }
        
        //写入缓存文件
        do {
            try cacheData.write(toFile: cachePath.absoluteString, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
            return false
        }
        
        return true
    }
    

    
    /// 删除全部缓存数据
    /// - Returns: 是否成功
    public static func fetchClearAllCacheData(completion: @escaping (Bool)->()) {
        
        DispatchQueue.global().async {
            let cachePath = YYKitCacheMananger.fetchCachePath()
            if fileManager.fileExists(atPath: cachePath.absoluteString) {
                do {
                    try fileManager.removeItem(at: cachePath)
                } catch _ {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    completion(true)
                }
            }
        }
    }
    
    
    ///缓存目录
    @discardableResult
    internal static func fetchCachePath(fileName:String = "") -> URL {
        
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let docURL = URL(string: documentsDirectory)!
        var cachePath = docURL.appendingPathComponent(kNetworkResponseCachePath)
        if !fileManager.fileExists(atPath: cachePath.absoluteString) {
            do {
                try fileManager.createDirectory(atPath: cachePath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription);
            }
        }
        
        cachePath = cachePath.appendingPathComponent(fileName)
        return cachePath
    }

    
}


extension YYKitCacheMananger {
    
    
    /// MD5
    /// - Parameter input: String
    /// - Returns: MD5 hash
    internal static func md5Hex(input:String) -> String {
        
        let str = input.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(input.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deallocate()
        return hash as String
        
    }
    
    
    // MARK: 字典/JSON字符串相互转化
    /// 字典转换为JSONString
    @discardableResult
    internal static func dictionaryToJSON(dictionary: Dictionary<String, Any>?) -> String? {
        guard let dictionary = dictionary else {
            return nil
        }
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions()) {
            let jsonStr = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            return String(jsonStr ?? "")
        }
        return nil
    }
    
    /// JSONString转换为字典
    @discardableResult
    internal static func jsonToDictionary(jsonString: String) -> Dictionary<String, Any>? {
        if let jsonDict = (try? JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8, allowLossyConversion: true)!, options: JSONSerialization.ReadingOptions.mutableContainers)) as? Dictionary<String, Any> {
            return jsonDict
        }
        return nil
    }
    
}
