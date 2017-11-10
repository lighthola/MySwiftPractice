//
//  ViewController.swift
//  TheTransOverdue
//
//  Created by Bevis Chen on 2017/11/9.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import UIKit
import Alamofire
import CryptoSwift
import Gzip

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

struct RailLiveBoard: Codable {
    var stationID: String // !
    var stationName: NameType
    var trainNo: String
    var direction: Direction
    var trainClassificationID: String
    var tripLine: TripLine?
    var endingStationID: String // !
    var endingStationName: NameType
    var scheduledArrivalTime: Date // (string): 表訂到站時間(格式: HH:mm:ss) ,
    var scheduledDepartureTime: Date // (string): 表訂離站時間(格式: HH:mm:ss) ,
    var delayTime: Int
    var srcUpdateTime: Date // (DateTime): 來源端平台資料更新時間(ISO8601格式:yyyy-MM-ddTHH:mm:sszzz) ,
    var updateTime: Date // (DateTime): 本平台資料更新時間(ISO8601格式:yyyy-MM-ddTHH:mm:sszzz)

    struct NameType: Codable {
        var tw: String
        var en: String
        
        enum CodingKeys: String, CodingKey {
            case tw = "Zh_tw" // (string, optional): 中文繁體名稱 ,
            case en = "En" //(string, optional): 英文名稱
        }
    }
    
    enum Direction: Int, Codable {
        case clockWise = 0
        case counterClockWise = 1
    }
    
    enum TripLine: Int, Codable {
        case none = 0
        case mountains = 1
        case coast = 2
    }

    enum CodingKeys: String, CodingKey {
        case stationID = "StationID" // (string): 車站代碼 ,
        case stationName = "StationName" // (NameType): 車站名稱 ,
        case trainNo = "TrainNo" // (string): 車次代碼 ,
        case direction = "Direction" // (Int): 順逆行 = ['0: 順行', '1: 逆行'],
        case trainClassificationID = "TrainClassificationID" // (string): 列車車種代碼 ,
        case tripLine = "TripLine" // (Int, optional): 山海線類型 = ['0: 不經山海線', '1: 山線', '2: 海線'],
        case endingStationID = "EndingStationID" // (string): 車次終點車站代號 ,
        case endingStationName = "EndingStationName" // (NameType): 車次終點車站名稱 ,
        case scheduledArrivalTime = "ScheduledArrivalTime" // (string): 表訂到站時間(格式: HH:mm:ss) ,
        case scheduledDepartureTime = "ScheduledDepartureTime" // (string): 表訂離站時間(格式: HH:mm:ss) ,
        case delayTime = "DelayTime" // (integer): 誤點時間(0:準點;>=1誤點) ,
        case srcUpdateTime = "SrcUpdateTime" // (DateTime): 來源端平台資料更新時間(ISO8601格式:yyyy-MM-ddTHH:mm:sszzz) ,
        case updateTime = "UpdateTime" // (DateTime): 本平台資料更新時間(ISO8601格式:yyyy-MM-ddTHH:mm:sszzz)
    }
}


class ViewController: UIViewController {
    
    let ptxStting = PTXSetting()
    var nGLiveBoard = [RailLiveBoard]() {
        didSet {
            
        }
    }
    var zLLiveBoard = [RailLiveBoard]() {
        didSet {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRailLiveBoard()
    }

    func getRailLiveBoard() {
        let url = URL(string: ptxStting.liveBoardUrl)!
        let parameters: [String : Any] = [
            "$top": 30,
            "$format": "JSON",
            "$filter": "StationID eq '1006' and Direction eq '1' or StationID eq '1017' and Direction eq '0'"]
        guard let signature = ptxStting.signature else {
            fatalError("creating signature failed.")
        }
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "hmac username=\"\(ptxStting.appIDL1)\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\"\(signature)\"",
            "x-date": "\(ptxStting.xDate)",
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
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //                print("""
                //                    Data:
                //                    \(utf8Text)
                //                    """) // original server data as UTF8 string
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .custom(self.ptxStting.dateDecodingStrategy)
                    let railLiveBoards = try decoder.decode([RailLiveBoard].self, from: data)
                    //print(railLiveBoards)
                    var nGLiveBoard = [RailLiveBoard]()
                    var zLLiveBoard = [RailLiveBoard]()
                    for liveBoard in railLiveBoards {
                        if liveBoard.trainNo == "1006" {
                            nGLiveBoard.append(liveBoard)
                        } else if liveBoard.trainNo == "1017" {
                            zLLiveBoard.append(liveBoard)
                        }
                    }
                    self.nGLiveBoard = nGLiveBoard
                    self.zLLiveBoard = zLLiveBoard
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

