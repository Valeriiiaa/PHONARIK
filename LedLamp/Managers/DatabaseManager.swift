//
//  DatabaseManager.swift
//  LedLamp
//
//  Created by Kyrylo Chernov on 04.03.2024.
//

import UIKit
import CoreData
import HomeKit

class RoomModel {
    let roomId: String
    var name: String
    var background: Data?
    var lamps: String
    var status: Bool
    var room: HMRoom?
    
    var titel: String {
        name
    }
    
    init(roomId: String, name: String, background: Data? = nil, lamps: String, status: Bool, room: HMRoom? = nil) {
        self.roomId = roomId
        self.name = name
        self.background = background
        self.lamps = lamps
        self.status = status
        self.room = room
    }
}

class LampModel {
    var name: String
    let deviceId: String
    var room: String?
    var isEnabled: Bool
    var color: Int
    var accessory: HMAccessory?
    
    init(name: String, deviceId: String, room: String? = nil, color: Int, isEnabled: Bool, accessory: HMAccessory?) {
        self.name = name
        self.deviceId = deviceId
        self.room = room
        self.color = color
        self.isEnabled = isEnabled
        self.accessory = accessory
    }
}


protocol DatabaseManagerProtocol {
    func save(_ model: LampModel)
    func save(_ model: RoomModel)
    
    func update(_ model: RoomModel, oldName: String)
    func update(_ model: LampModel, oldName: String, roomUpdate: Bool)
    
    func remove(_ name: String)
    func removeRoom(_ name: String)
    
    func load() -> [LampModel]
    func loadRooms() -> [RoomModel]
}


class DatabaseManager: DatabaseManagerProtocol {
    
    static let shared = DatabaseManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LEDapp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    private func saveContext() {
        DispatchQueue.main.async {
            let context = self.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func save(_ model: LampModel) {
        let item = LightLamp(context: persistentContainer.viewContext)
        item.name = model.name
        item.deviceId = model.deviceId
        item.room = model.room
        item.isEnabled = model.isEnabled
        item.color = Int32(model.color)
        saveContext()
    }
    
    
    func save(_ model: RoomModel) {
        let item = MyRoom(context: persistentContainer.viewContext)
        item.name = model.name
        item.background = model.background
        item.lamps = model.lamps
        item.status = model.status
        saveContext()
    }
    
    
    func update(_ model: RoomModel, oldName: String) {
        removeRoom(oldName)
        save(model)
    }
    
    func update(_ model: LampModel) {
        let request: NSFetchRequest<LightLamp> = LightLamp.fetchRequest()
        do {
            let fetchedItems = try persistentContainer.viewContext.fetch(request)
            if let item = fetchedItems.first(where: { $0.deviceId == model.deviceId }) {
                persistentContainer.viewContext.delete(item)
                saveContext()
                
                save(model)
            }
        } catch let error {
            print("Lamp delete error: \(error)")
        }
    }
    
    func update(_ model: LampModel, oldName: String, roomUpdate: Bool = false) {
        let request: NSFetchRequest<LightLamp> = LightLamp.fetchRequest()
        do {
            let fetchedItems = try persistentContainer.viewContext.fetch(request)
            if let item = fetchedItems.first(where: {
                if roomUpdate {
                    $0.room == oldName
                } else {
                    $0.name == oldName
                }
            }) {
                persistentContainer.viewContext.delete(item)
                saveContext()
                
                save(model)
            }
        } catch let error {
            print("Lamp delete error: \(error)")
        }
    }
    
    
    func remove(_ name: String) {
        let request: NSFetchRequest<LightLamp> = LightLamp.fetchRequest()
        do {
            let fetchedItems = try persistentContainer.viewContext.fetch(request)
            if let item = fetchedItems.first(where: { $0.name == name }) {
                persistentContainer.viewContext.delete(item)
                saveContext()
            }
        } catch let error {
            print("Lamp delete error: \(error)")
        }
    }
    
    
    func removeRoom(_ name: String) {
        let request: NSFetchRequest<MyRoom> = MyRoom.fetchRequest()
        do {
            let fetchedItems = try persistentContainer.viewContext.fetch(request)
            if let item = fetchedItems.first(where: { $0.name == name }) {
                persistentContainer.viewContext.delete(item)
                saveContext()
            }
        } catch let error {
            print("Room delete error: \(error)")
        }
    }
    
    
    
    func load() -> [LampModel] {
        let request: NSFetchRequest<LightLamp> = LightLamp.fetchRequest()
        do {
            let fetchedItems = try persistentContainer.viewContext.fetch(request)
            let devices = HomeManager.shared.loadConnectedDevices()
            var models: [LampModel] = []
            print(devices.count)
            print(fetchedItems.count)
            print(devices.first?.uniqueIdentifier.uuidString)
            print(fetchedItems.first?.deviceId)
            for item in fetchedItems {
                print(devices.first(where: { $0.uniqueIdentifier.uuidString == item.deviceId }))
                models.append(LampModel(name: item.name ?? "", deviceId: item.deviceId ?? "", room: item.room, color: Int(item.color), isEnabled: item.isEnabled, accessory: devices.first(where: { $0.uniqueIdentifier.uuidString == item.deviceId })!))
            }
            models.forEach({ item in
                print(item.accessory!)
            })
            return models
        } catch let error {
            print("Error fetching history \(error)")
            return []
        }
    }
    
    
    func loadRooms() -> [RoomModel] {
        let request: NSFetchRequest<MyRoom> = MyRoom.fetchRequest()
        do {
            let fetchedItems = try persistentContainer.viewContext.fetch(request)
            let rooms = HomeManager.shared.loadRooms()
            var models: [RoomModel] = []
            for item in fetchedItems {
                models.append(RoomModel(roomId: item.roomId ?? "",
                                        name: item.name ?? "",
                                        background: item.background,
                                        lamps: item.lamps ?? "",
                                        status: item.status,
                                        room: rooms.first(where: { $0.uniqueIdentifier.uuidString == item.roomId })))
            }

            return models
        } catch let error {
            print("Error fetching rooms \(error)")
            return []
        }
    }
    
}
