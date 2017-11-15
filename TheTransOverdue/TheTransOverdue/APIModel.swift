//
//  APIModel.swift
//  TheTransOverdue
//
//  Created by Bevis Chen on 2017/11/13.
//  Copyright © 2017年 Bevis Chen. All rights reserved.
//

import Foundation

struct RailLiveBoard: Codable {
    var stationID: String // !
    var stationName: NameType
    var trainNo: String
    var direction: Direction
    var trainClassificationID: TrainClassificationID
    var tripLine: TripLine?
    var endingStationID: String // !
    var endingStationName: NameType
    var scheduledArrivalTime: Date
    var scheduledDepartureTime: String
    var delayTime: Int
    var srcUpdateTime: Date
    var updateTime: Date
    
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
    
    enum TrainClassificationID: String, Codable {
        case tzeChiangType1 = "1100" // (DMU2800、2900、3000型柴聯及 EMU型電車自強號)
        case tzeChiangType2 = "1101" // 自強(推拉式自強號)
        case tzeChiangTypeTarko = "1102" // 自強(太魯閣)
        case tzeChiangType3 = "1103" // 自強(DMU3100型柴聯自強號)
        case tzeChiangTypePuyuma = "1107"// 自強(普悠瑪)
        case tzeChiangType4 = "1108" // 自強(推拉式自強號且無自行車車廂)
        
        case chuKuangType1 = "1110" // 莒光(無身障座位)
        case chuKuangType2 = "1111" // 莒光(有身障座位)
        case chuKuangType3 = "1114" // 莒光(無身障座位 ,有自行車車廂)
        case chuKuangType4 = "1115" // 莒光(有身障座位 ,有自行車車廂)
        
        case fuHsing =  "1120" // 復興

        case local = "1131" // 區間車
        case localFast = "1132" // 區間快

        case ordinary = "1140" // 普快車
        
        var description: String {
            switch self {
            case .tzeChiangType1,
                 .tzeChiangType2,
                 .tzeChiangType3,
                 .tzeChiangType4:
                return "自強"
            case .tzeChiangTypeTarko:
                return "太魯閣"
            case .tzeChiangTypePuyuma:
                return "普悠瑪"
            case .chuKuangType1,
                 .chuKuangType2,
                 .chuKuangType3,
                 .chuKuangType4:
                return "莒光"
            case .fuHsing:
                return "復興"
            case .local:
                return "區間"
            case .localFast:
                return "區間快"
            case .ordinary:
                return "普快車"
            }
        }
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
