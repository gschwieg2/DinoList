//
//  DinoListApp.swift
//  DinoList
//
//  Created by student on 3/16/22.
//

import SwiftUI

@main
struct DinoListApp: App {
    @StateObject private var toDoListStore: ToDoListStore
    
    
    init() {
        let toDoListStore: ToDoListStore
        do {
          toDoListStore = try ToDoListStore(withChecking: true)
        } catch {
            print("Could not load history data/no history data saved yet")
            toDoListStore = ToDoListStore()
            
        }
        _toDoListStore = StateObject(wrappedValue: toDoListStore)
      }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(toDoListStore)
            .onAppear {
                  print(FileManager.default.urls(
                    for: .documentDirectory,
                    in: .userDomainMask))
            }
            
                
            }
                            
        }
    
}
