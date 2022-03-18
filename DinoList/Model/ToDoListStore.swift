//
//  ToDoList.swift
//  DinoList
//
//  Created by student on 3/16/22.
//

import Foundation

struct ListElement: Identifiable {
    let id = UUID()
    var isDone: Bool
    var text: String
}

class ToDoListStore: ObservableObject {
    
    @Published var listElements: [ListElement] = []
    
    enum FileError: Error {
        case loadFailure
        case saveFailure
        case urlFailure
    }

    init() {}

    init(withChecking: Bool) throws {
        #if DEBUG
        // createDevData()
        #endif
        do {
          try load()
        } catch {
          throw error
        }
    }
    
    func load() throws {
        // 1
        guard let dataURL = getURL() else {
          throw FileError.urlFailure
        }
        do {
          // 2
          let data = try Data(contentsOf: dataURL)
          // 3
          let plistData = try PropertyListSerialization.propertyList(
            from: data,
            options: [],
            format: nil)
          // 4
          let convertedPlistData = plistData as? [[Any]] ?? []
          // 5
          listElements = convertedPlistData.map {
            ListElement(
                isDone: ($0[1] as? Bool)!,
                text: ($0[2] as? String)!)
          }
        } catch {
          throw FileError.loadFailure
        }
    }
    
    func getURL() -> URL? {
        // 1
        guard let documentsURL = FileManager.default.urls(
          for: .documentDirectory, in: .userDomainMask).first else {
          // 2
          return nil
        }
        // 3
        return documentsURL.appendingPathComponent("history.plist")
    }
    
    func deleteListElement(toDeleteElement: ListElement) {
        
        let indexToDelete = listElements.firstIndex(where: { $0.id == toDeleteElement.id })!
        listElements.remove(at: indexToDelete)
        do {
            try save()
        } catch {
            fatalError(error.localizedDescription)
        }
        
    }
    
    func addListElement(newListText: String) {
        listElements.append(ListElement(isDone: false, text: newListText))
        do {
            try save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func save() throws {
        guard let dataURL = getURL() else {
          throw FileError.urlFailure
        }
        let plistData = listElements.map {
          [$0.id.uuidString, $0.isDone, $0.text]
        }
        do {
          // 1
          let data = try PropertyListSerialization.data(
            fromPropertyList: plistData,
            format: .binary,
            options: .zero)
          // 2
          try data.write(to: dataURL, options: .atomic)
        } catch {
          // 3
          throw FileError.saveFailure
        }
    }
    
    func updateIsDone(toToggleElement: ListElement) {
        let indexToToggle = listElements.firstIndex(where: { $0.id == toToggleElement.id })!
        listElements[indexToToggle].isDone.toggle()
    }
    
    
}
