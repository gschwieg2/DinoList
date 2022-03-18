//
//  ToDoListView.swift
//  DinoList
//
//  Created by student on 3/16/22.
//

import SwiftUI

struct ToDoListView: View {
    @EnvironmentObject var listStore: ToDoListStore
    @State private var newListElement: String = ""
    @State private var randomDino = getRandomDinosaur()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Dino-List")
                    .font(.largeTitle)
                    .foregroundColor(.green)
                List {
                    ForEach (listStore.listElements) { currentElement in
                        HStack {
                            if currentElement.isDone {
                                Image(systemName: "checkmark.circle")
                                    .onTapGesture {
                                        listStore.updateIsDone(toToggleElement: currentElement)
                                    }
                            } else {
                                Image(systemName: "circle")
                                    .onTapGesture {
                                        listStore.updateIsDone(toToggleElement: currentElement)
                                    }
                            }
                            Text(currentElement.text)
                                .foregroundColor(.green)
                            Image(systemName: "x.circle")
                                .foregroundColor(.red)
                                .onTapGesture {
                                    listStore.deleteListElement(toDeleteElement: currentElement)
                                }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                
                Form {
                    TextField("Enter new item name here", text: $newListElement)
                            Button(action: {
                                listStore.addListElement(newListText: newListElement)
                                
                                randomDino = getRandomDinosaur()
                            }) {
                              HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add new item")
                                  
                              }
                    }
                }
                .frame(height: geometry.size.height * 0.20 ,alignment: .bottom)
                .onAppear {
                  UITableView.appearance().backgroundColor = .clear
                }
                .onDisappear {
                  UITableView.appearance().backgroundColor = .systemGroupedBackground
                }
                
                .foregroundColor(.green)
            }
            .background(Image(randomDino)
                            .resizable()
                            .aspectRatio(contentMode: .fill))
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
        .environmentObject(ToDoListStore())
    }
}



