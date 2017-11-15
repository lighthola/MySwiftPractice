//
//  API.swift
//  TheTransOverdue
//
//  Created by Bevis Chen on 2017/11/13.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire

struct PTXSetting {
    let liveBoardUrl = "http://ptx.transportdata.tw/MOTC/v2/Rail/TRA/LiveBoard"
    
    let appIDL1 = "fbd386ca309f46e492b4cfb25cfab7d4"
    let appKeyL1 = "j3LJgSuD5P0lOkv7nIj22syPe6w"
    let appIDL2 = "a61b2763fa8c4237aaafe3d8c49a6316"
    let appKeyL2 = "VTITttQG-0Q-LD2E9ysbXaf8JGQ"
    
    var xDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: Date())
    }
    
    var signature: String? {
        let input = "x-date: \(xDate)" // Thu, 09 Nov 2017 06:32:43 GMT
        do {
            let result: [UInt8] = try HMAC(key: Array(appKeyL1.utf8), variant: .sha1).authenticate(Array(input.utf8))
            return Data(bytes: result).base64EncodedString(options: .lineLength64Characters) // okbCw72u+/O5rByzyM1akikSSy0=
        } catch {
            print(error)
            return nil
        }
    }
    
    var dateDecodingStrategy: (Decoder) throws -> Date = { (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        let f = DateFormatter()
        f.dateFormat = str.count == 8 ? "HH:mm:ss" : "yyyy-MM-dd'T'HH:mm:ssZ"
        f.timeZone = TimeZone(abbreviation: "GMT+8")
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = .current
        return f.date(from: str)!
    }
}

class API {
    static let setting = PTXSetting()
    
    func getRailLiveBoard(id: String, direction: String, complection: @escaping ([RailLiveBoard])->(), errorHandler: @escaping (String)->()) {
        let url = URL(string: API.setting.liveBoardUrl)!
        let parameters: [String : Any] = [
            "$top": 30,
            "$format": "JSON",
            "$filter": "StationID eq '\(id)' and Direction eq '\(direction)'"]
        guard let signature = API.setting.signature else {
            fatalError("creating signature failed.")
        }
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "hmac username=\"\(API.setting.appIDL1)\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\"\(signature)\"",
            "x-date": "\(API.setting.xDate)",
            "Accept-Encoding": "gzip, deflate"
        ]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default , headers: headers).responseData { (response) in
            print("""
                Request:
                \(String(describing: response.request))
                """) // original url request
            
            print("""
                Response:
                \(String(describing: response.response))
                """) // http url response
            
            print("""
                Result:
                \(response.result)
                """) // response serialization result
            
            if let json = response.result.value {
                print("""
                    JSON:
                    \(json)
                    """) // serialized json response
            }
            
            guard response.response?.statusCode == 200 else {
                errorHandler("Status Code: \(response.response?.statusCode ?? -1))")
                return
            }
            
            if let data = response.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .custom(API.setting.dateDecodingStrategy)
                    let railLiveBoards = try decoder.decode([RailLiveBoard].self, from: data)
                    //print(railLiveBoards)
                    complection(railLiveBoards)
                } catch {
                    //print(error.localizedDescription)
                    errorHandler(error.localizedDescription)
                }
            } else {
                errorHandler("資料是空的")
            }
        }
    }
}
