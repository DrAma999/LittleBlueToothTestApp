//
//  ViewController.swift
//  Test
//
//  Created by Andrea Finollo on 11/06/2020.
//  Copyright © 2020 Andrea Finollo. All rights reserved.
//

import UIKit
import LittleBlueTooth
import CoreBluetooth
import Combine
import os.log

enum HRMCostants {
    static let HRMService = "180D"
    static let HRMRate = "2A37" // Notify
    static let HRMSensorLocation = "2A38" // Read
    static let HRMControlPoint = "2A39" // Write
}


class ViewController: UIViewController {
    
    @IBOutlet weak var startListenButton: UIButton!
    @IBOutlet weak var connectListenButton: UIButton!

    @IBOutlet weak var hrmRateLabel: UILabel!
    @IBOutlet weak var hrmSensorPositionLabel: UILabel!
    @IBOutlet weak var hrmConnectionState: UILabel!

    
    var littleBT: LittleBlueTooth {
        (UIApplication.shared.delegate! as! AppDelegate).littleBT
    }

    
    let hrmRateChar = LittleBlueToothCharacteristic(characteristic: HRMCostants.HRMRate, for: HRMCostants.HRMService, properties: .notify)
     let hrmSensorChar = LittleBlueToothCharacteristic(characteristic: HRMCostants.HRMSensorLocation, for: HRMCostants.HRMService, properties: .read)
     let hrmControlPointChar = LittleBlueToothCharacteristic(characteristic: HRMCostants.HRMControlPoint, for: HRMCostants.HRMService, properties: .write)
    
    var disposeBag = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.littleBT.peripheralStatePublisher
            .sink { (state) in
                print("Peripheral State: \(state)")
                self.hrmConnectionState.text = "Peripheral State: \(state)"
        }
        .store(in: &disposeBag)
        
    }
    
    func connect() {
        
        StartLittleBlueTooth
            .startDiscovery(for: self.littleBT, withServices: [CBUUID(string: HRMCostants.HRMService)])
            .prefix(1)
            .connect(for: self.littleBT)
            .sink(receiveCompletion: { result in
                print("Result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error trying to connect: \(error)")
                }
            }) { (periph) in
                print("Periph \(periph)")
                self.connectListenButton.isEnabled = true
                self.connectListenButton.isSelected = true
                self.connectListenButton.setTitle("DISCONNECT", for: .normal)
        }
        .store(in: &disposeBag)
    }
    
    func disconnect() {
        
        StartLittleBlueTooth
            .disconnect(for: self.littleBT)
            .sink(receiveCompletion: { (result) in
                print("Result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error trying to disconnect: \(error)")
                }
            }) { (_) in
                self.connectListenButton.isEnabled = true
                self.connectListenButton.isSelected = false
                self.connectListenButton.setTitle("CONNECT", for: .normal)
        }
        .store(in: &disposeBag)
    }
    
    // Before reading the position a value must be set into the sensor
    func readPosition() {
        StartLittleBlueTooth
            .read(for: self.littleBT, from: hrmSensorChar)
            .sink(receiveCompletion: { (result) in
                print("Result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error while changing sensor position: \(error)")
                    break
                }
                
            }) { (value: HeartRateSensorPositionResponse) in
                print("Value: \(value)")
                self.hrmSensorPositionLabel.text = value.position.description
        }
        .store(in: &disposeBag)
    }
    
    func changePosition(_ position: HRMSensorPosition) {
    
        // Write on Control point and read
        StartLittleBlueTooth
            .write(for: self.littleBT, to: hrmControlPointChar, value: position.rawValue)
            .read(for: self.littleBT, from: hrmSensorChar)
            .sink(receiveCompletion: { (result) in
                print("Result: \(result)")
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print("Error while changing sensor position: \(error)")
                    break
                }
                
            }) { (value: HeartRateSensorPositionResponse) in
                print("Value: \(value)")
                self.hrmSensorPositionLabel.text = value.position.description
        }
        .store(in: &disposeBag)
    }

    @IBAction func pressedStartListen(_ sender: Any) {
        if startListenButton.isSelected {
            StartLittleBlueTooth
                .disableListen(for: self.littleBT, from: hrmRateChar)
                .sink(receiveCompletion: { (result) in
                    print("Result: \(result)")
                    switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error while trying to stop listen: \(error)")
                    }
                }) { (_) in
                    print("Listen disabled")
                    self.startListenButton.isSelected = false
                    self.startListenButton.isEnabled = true
            }
        .store(in: &disposeBag)
        } else {

            StartLittleBlueTooth
            .startListen(for: self.littleBT, from: hrmRateChar)
            .sink(receiveCompletion: { (result) in
                    print("Result: \(result)")
                    switch result {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error while trying to listen: \(error)")
                    }
            }) { (value: HeartRateMeasurementResponse) in
                self.hrmRateLabel.text = String(value.value)
                self.startListenButton.isSelected = true
                self.startListenButton.isEnabled = true
            }
            .store(in: &disposeBag)
        }
        self.startListenButton.isEnabled = false
    }
    @IBAction func pressedConnect(_ sender: Any) {
        if connectListenButton.isSelected {
            disconnect()
        } else {
            connect()
        }
        self.connectListenButton.isEnabled = false
    }
       
    @IBAction func pressedReadPosition(_ sender: Any) {
        readPosition()
    }
}

