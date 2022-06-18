//
//  Model.swift
//  Pomodoroo
//
//  Created by Fatih Kilit on 12.06.2022.
//

import Foundation

struct Model: Codable, Equatable {
    var pomodoroCount: Double = 3
    var pomodoroLengthInMinutes: Double = 20
    var breakLengthInMinutes: Double = 5
    
    var pomodoroLengthInSeconds: Int {
        Int(pomodoroLengthInMinutes * 60)
    }
    
    var breakLengthInSeconds: Int {
        Int(breakLengthInMinutes * 60)
    }
}
