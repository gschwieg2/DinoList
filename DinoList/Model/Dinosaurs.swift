//
//  Dinosaurs.swift
//  DinoList
//
//  Created by student on 3/18/22.
//

import Foundation

func getRandomDinosaur() -> String {
    let randomInt = Int.random(in: 1..<10)
    return "dinoImage\(randomInt)"
}
