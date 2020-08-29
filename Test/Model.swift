//
//  Model.swift
//  Test
//
//  Created by Andrea Finollo on 28/08/2020.
//  Copyright © 2020 Andrea Finollo. All rights reserved.
//

import Foundation
import LittleBlueTooth

struct HeartRateMeasurementResponse: Readable {
    var value: UInt8

    init(from data: Data) throws {
        value = try data.extract(start: 1, length: 1)
    }

}

enum HRMSensorPosition: UInt8, CustomStringConvertible {
    
    case other      = 0
    case chest      = 1
    case wrist      = 2
    case fingher    = 3
    case hand       = 4
    case earLobe    = 5
    case foot       = 6
    
    var description: String {
        switch self {
        case .other:
            return "Other"
        case .chest:
            return "Chest"
        case .wrist:
            return "Wrist"
        case .fingher:
            return "Fingher"
        case .hand:
            return "Hand"
        case .earLobe:
            return "Ear Lobe"
        case .foot:
            return "Foot"
        }
    }

}

struct HeartRateSensorPositionResponse: Readable {
    var position: HRMSensorPosition

    init(from data: Data) throws {
        let pos: UInt8 = try data.extract(start: 0, length: 1)
        self.position = HRMSensorPosition(rawValue: pos)!
    }
    
}

struct HeartRateSensorPositionRequest: Writable {
    var position: HRMSensorPosition

    var data: Data {
        return LittleBlueTooth.assemble([position.rawValue])
    }
    
}
