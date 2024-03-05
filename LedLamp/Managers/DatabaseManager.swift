//
//  DatabaseManager.swift
//  LedLamp
//
//  Created by Kyrylo Chernov on 04.03.2024.
//

import UIKit
import CoreData
import HomeKit

struct RoomModel {
    var name: String
    var background: Data?
    var lamps: String
    var status: Bool
    var room: HMRoom?
}

struct LampModel {
    var name: String
    let deviceId: String
    var room: String?
    var accessory: HMAccessory?
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
            
            var models: [LampModel] = []
            for item in fetchedItems {
                models.append(LampModel(name: item.name ?? "", deviceId: item.deviceId ?? "", room: item.room))
            }

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
            
            var models: [RoomModel] = []
            for item in fetchedItems {
                models.append(RoomModel(name: item.name ?? "",
                                        background: item.background,
                                        lamps: item.lamps ?? "",
                                        status: item.status))
            }

            return models
        } catch let error {
            print("Error fetching rooms \(error)")
            return []
        }
    }
    
}
