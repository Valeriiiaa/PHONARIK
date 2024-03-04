//
//  HomeKitManager.swift
//  LedLamp
//
//  Created by Kyrylo Chernov on 02.03.2024.
//

import Foundation
import HomeKit


protocol HomeManagerProtocol {
    
    var home: HMHome? { get set }
    var accessories: (([HMAccessory]) -> Void)? { set get }
    var reloadData: (() -> Void)? { set get }
    
    func showCamera(_ callback: @escaping() -> Void)
    func checkHomes()
    func startDeviceDiscovering()
    func stopDeviceDiscovering()
    func addDevice(_ device: HMAccessory, toRoom name: String, _ callback: @escaping(Bool) -> Void)
    
    func createRoom(withName room: String, _ callback: @escaping(HMRoom) -> Void)
    func updateRoom(_ device: HMAccessory, newRoom: String, _ callback: @escaping(Bool) -> Void)
    func updateRoom(_ room: HMRoom?, name: String, _ callback: @escaping(Bool) -> Void)
    func removeRoom(_ room: HMRoom, _ callback: @escaping(Bool) -> Void)
    
    func updateName(_ device: HMAccessory, name: String, _ callback: @escaping(Bool) -> Void)
    func connectDevice(_ device: HMAccessory, _ callback: @escaping(String?) -> Void)
    func removeDevice(_ device: HMAccessory, _ callback: @escaping(Bool) -> Void)
    func loadConnectedDevices() -> [HMAccessory]
    func loadRooms() -> [HMRoom]
 //   func loadAccessories()
}


class HomeManager: NSObject, HomeManagerProtocol {
    
    static let shared = HomeManager()
    
    var home: HMHome?
    private var manager: HMHomeManager!
    private var browser: HMAccessoryBrowser!
    private var room: HMRoom?
    private var discoveredAccessories: [HMAccessory] = [] {
        didSet {
            accessories?(discoveredAccessories)
        }
    }
    
    var accessories: (([HMAccessory]) -> Void)?
    var reloadData: (() -> Void)?
    
    override init() {
        self.manager = HMHomeManager()
    }
    
    
    //MARK: Device Browser (Scanner)
    func startDeviceDiscovering() {
        if browser == nil {
            browser = HMAccessoryBrowser()
            browser.delegate = self
        }
        discoveredAccessories.removeAll()
        browser.startSearchingForNewAccessories()
    }
    
    
    func stopDeviceDiscovering() {
        browser?.stopSearchingForNewAccessories()
        if discoveredAccessories.isEmpty {
            print("is empty")
            return
        }
    }
    
    
    //MARK: Home Management
    func checkHomes() {
        print("homes: \(manager.homes)")
//        manager.
        if manager.homes.isEmpty {
            self.createHome(withName: "My Home5") { status in
                print("home add status: \(status)")
            }
            return
        }
        
        home = manager.homes[0]
        
        if !(home!.rooms.isEmpty) {
            self.room = home?.rooms[0]
        }
    }
    
    
    private func createHome(withName name: String, _ callback: @escaping(Bool) -> Void) {
        self.manager.addHome(withName: name) { home, error in
            if let error = error {
                print(error.localizedDescription)
                callback(false)
                return
            }
            
            guard let home = home else {
                print("no home")
                callback(false)
                return
            }
            
            self.home = home
        }
    }
    
    
    
    //MARK: Room Management
    func createRoom(withName room: String, _ callback: @escaping(HMRoom) -> Void) {
        home?.addRoom(withName: room) { room, error in
            if let _ = room, error == nil {
                self.room = room
                callback(room!)
                return
            }
            print("room not created")
        }
    }
    
    
    func updateRoom(_ room: HMRoom?, name: String, _ callback: @escaping(Bool) -> Void) {
        guard let room = room else {
            callback(false)
            return
        }
        room.updateName(name) { error in
            if let error = error {
                print("Room name not updated: \(error.localizedDescription)")
                callback(false)
                return
            }
            print("Room name updated to \(name)")
            callback(true)
        }
    }
    
    
    private func getRoom(withName room: String, _ callback: @escaping(HMRoom) -> Void) {
        if let room = home?.rooms.first(where: { $0.name == room }) {
            callback(room)
            return
        }
        
        createRoom(withName: room) { newRoom in
            callback(newRoom)
        }
    }
    
    
    func updateRoom(_ device: HMAccessory, newRoom: String, _ callback: @escaping(Bool) -> Void) {
        getRoom(withName: newRoom) { room in
            self.home?.assignAccessory(device, to: room, completionHandler: { error in
                if let error = error {
                    print("device room not updated: \(error.localizedDescription)")
                    callback(false)
                    return
                }
                print("device room updated to \(newRoom)")
                callback(true)
            })
        }
    }
    
    
    func removeRoom(_ room: HMRoom, _ callback: @escaping(Bool) -> Void) {
        home?.removeRoom(room, completionHandler: { error in
            if let error = error {
                print("Room \(room.name) not removed: \(error.localizedDescription)")
                callback(false)
                return
            }
            print("Room \(room.name) removed")
            callback(true)
        })
    }
    
    
    //MARK: Device Management
    func connectDevice(_ device: HMAccessory, _ callback: @escaping(String?) -> Void) {
        home?.addAccessory(device, completionHandler: { error in
            if let error = error {
                print("device not connected: \(error.localizedDescription)")
                callback(error.localizedDescription)
                return
            }
            print("device connected!")
            callback(nil)
        })
    }
    
    
    func removeDevice(_ device: HMAccessory, _ callback: @escaping(Bool) -> Void) {
        home?.removeAccessory(device, completionHandler: { error in
            if let error = error {
                print("device not removed: \(error.localizedDescription)")
                callback(false)
                return
            }
            print("device removed!")
            callback(true)
        })
    }
    
    
    func showCamera(_ callback: @escaping() -> Void) {
        self.home?.delegate = self
//        HMAccessorySetupManager().performAccessorySetup(using: .init(), completionHandler: { result, error in
//            result
//        })
//        self.home?.addAnd
//        self.home?.addAndSetUpAccessories(payload: HMAccessorySetupPayload(url: URL))
//        self.home?.add,AndSetupAccessories(with: HMAccessorySetupPayload, completionHandler: <#T##([HMAccessory]?, Error?) -> Void#>)
        self.home?.addAndSetupAccessories(with: HMAccessorySetupPayload(url: URL(string: "X-HM://00195JERG4W7D"))!, completionHandler: { error, pisum  in
            if let error = error {
//                print("camera error: \(error.localizedDescription)")
                callback()
                return
            }
            
            print("device added")
            callback()
        })
    }
    
    
    
    func addDevice(_ device: HMAccessory, toRoom name: String, _ callback: @escaping(Bool) -> Void) {
        getRoom(withName: name) { room in
            self.home?.assignAccessory(device, to: room, completionHandler: { error in
                if let error = error {
                    print("device not assigned: \(error.localizedDescription)")
                    callback(false)
                    return
                }
                print("device assigned to room \(name)")
                callback(true)
            })
        }
    }
    
    
    func updateName(_ device: HMAccessory, name: String, _ callback: @escaping(Bool) -> Void) {
        device.updateName(name) { error in
            if let error = error {
                print("device name not updated: \(error.localizedDescription)")
                callback(false)
                return
            }
            print("device name updated to \(name)")
            callback(true)
        }
    }
    
    
    func loadRooms() -> [HMRoom] {
        return home?.rooms ?? []
    }
    
    
    func loadConnectedDevices() -> [HMAccessory] {
        guard let homeAccessories = home?.accessories else {
            return []
        }
        
        var deices: [HMAccessory] = []
        
        for accessory in homeAccessories {
            if let characteristic = accessory.getCharacteristic(forType: .power) {
                deices.append(accessory)
                accessory.delegate = self
                characteristic.enableNotification(true) { error in
                    if error != nil {
                        print("Something went wrong when enabling notification for a characteristic.")
                    }
                }
            }
        }
        
        return deices
    }
    
}


//MARK: Extensions
extension HomeManager: HMAccessoryBrowserDelegate {
    
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        print(accessory)
        discoveredAccessories.append(accessory)
    }
}



extension HomeManager: HMAccessoryDelegate, HMHomeDelegate {
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        reloadData?()
    }
    
    func home(_ home: HMHome, didAdd accessory: HMAccessory) {
        print("new device added!")
    //    connectedAccessory?(accessory)
    }
}


extension HMAccessory {
    
    func getCharacteristic(forType type: CharacteristicType) -> HMCharacteristic? {
        switch type {
        case .hue:
            return services.lazy
                .filter { $0.serviceType == HMServiceTypeLightbulb }
                .flatMap { $0.characteristics }
                .first { $0.characteristicType == HMCharacteristicTypeHue }
        case .power:
            return services.lazy
                .filter { $0.serviceType == HMServiceTypeLightbulb }
                .flatMap { $0.characteristics }
                .first { $0.metadata?.format == HMCharacteristicMetadataFormatBool }
        case .brightness:
            return services.lazy
                .filter { $0.serviceType == HMServiceTypeLightbulb }
                .flatMap { $0.characteristics }
                .first { $0.characteristicType == HMCharacteristicTypeBrightness }
        case .saturation:
            return services.lazy
                .filter { $0.serviceType == HMServiceTypeLightbulb }
                .flatMap { $0.characteristics }
                .first { $0.characteristicType == HMCharacteristicTypeSaturation }
        case .temperature:
            return services.lazy
                .filter { $0.serviceType == HMServiceTypeLightbulb }
                .flatMap { $0.characteristics }
                .first { $0.characteristicType == HMCharacteristicTypeColorTemperature }
        }
    }
    

    enum CharacteristicType {
        case hue
        case power
        case brightness
        case saturation
        case temperature
    }
    
}
