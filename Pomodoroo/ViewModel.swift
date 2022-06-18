//
//  ViewModel.swift
//  Pomodoroo
//
//  Created by Fatih Kilit on 12.06.2022.
//

import SwiftUI

enum Status: String {
    case pomodoro = "Pomodoro"
    case `break` = "Break"
}

class ViewModel: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    var status: Status = Status.pomodoro
    @Published var model: Model = Model()
    @Published var isTimerRunning: Bool = false
    @Published var isSessionActive: Bool = false
    @Published var setNewPomodoro: Bool = false
    
    @Published var progress: CGFloat = 1

    @Published var pomodoroCount: Int = 0
    @Published var pomodorLengthInSeconds: Int = 0
    @Published var breakLengthInSeconds: Int = 0
    
    @Published var timerString: String = "00:00"
    
    @Published var completedPomodoro: Int = 0
    
    @Published var isSmallerDevice: Bool = false
    
    override init() {
        super.init()
        self.authorizeNotification()
    }
    
    func authorizeNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in
        }
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    func pushNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoroo"
        content.subtitle = "Congratulations 🥳 Time to rest 😌"
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false))
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func prepareTimerString() {
        let hours = Int(model.pomodoroLengthInSeconds / 3600)
        let minutes = Int(model.pomodoroLengthInSeconds / 60) % 60
        let seconds = model.pomodoroLengthInSeconds % 60

        timerString = ""
        timerString += hours == 0 ? "" : "0\(hours):"
        timerString += minutes >= 10 ? "\(minutes):" : "0\(minutes):"
        timerString += seconds >= 10 ? "\(seconds)" : "0\(seconds)"
    }
    
    func startTimer() {
        withAnimation(.easeInOut) {
            isTimerRunning = true
        }
        
        if !isSessionActive {
            pomodoroCount = Int(model.pomodoroCount)
            pomodorLengthInSeconds = model.pomodoroLengthInSeconds
            breakLengthInSeconds = model.breakLengthInSeconds
            
            prepareTimerString()
        }
        isSessionActive = true
    }
    
    func stopTimer() {
        withAnimation {
            isTimerRunning = false
        }
    }
    
    func resetTimer() {
        withAnimation {
            isTimerRunning = false
            progress = 1
            completedPomodoro = 0
            isSessionActive = false
        }
        status = .pomodoro
        
        pomodoroCount = Int(model.pomodoroCount)
        pomodorLengthInSeconds = model.pomodoroLengthInSeconds
        breakLengthInSeconds = model.breakLengthInSeconds
        
        prepareTimerString()
    }
    
    func pomodoroRunning() {
        if pomodorLengthInSeconds > 0 {
            pomodorLengthInSeconds -= 1
            
            let hours = Int(pomodorLengthInSeconds / 3600)
            let minutes = Int(pomodorLengthInSeconds / 60) % 60
            let seconds = pomodorLengthInSeconds % 60
            
            timerString = ""
            timerString += hours == 0 ? "" : "0\(hours):"
            timerString += minutes >= 10 ? "\(minutes):" : "0\(minutes):"
            timerString += seconds >= 10 ? "\(seconds)" : "0\(seconds)"
            
            withAnimation {
                progress = CGFloat(pomodorLengthInSeconds) / CGFloat(model.pomodoroLengthInSeconds)
            }
            
        } else {
            pomodoroCount -= 1
            completedPomodoro += 1
            
            if pomodoroCount > 0 {
                status = .break
                pomodorLengthInSeconds = model.pomodoroLengthInSeconds
                
                withAnimation {
                    progress = 1
                }
            } else {
                status = .pomodoro
                
                withAnimation {
                    progress = 1
                }
                
                resetTimer()
                
                pushNotification()
            }
        }
    }
    
    func breakRunning() {
        if breakLengthInSeconds > 0 {
            breakLengthInSeconds -= 1
            
            let hours = Int(breakLengthInSeconds / 3600)
            let minutes = Int(breakLengthInSeconds / 60) % 60
            let seconds = breakLengthInSeconds % 60
            
            timerString = ""
            timerString += hours == 0 ? "" : "0\(hours):"
            timerString += minutes >= 10 ? "\(minutes):" : "0\(minutes):"
            timerString += seconds >= 10 ? "\(seconds)" : "0\(seconds)"
            
            withAnimation {
                progress = CGFloat(breakLengthInSeconds) / CGFloat(model.breakLengthInSeconds)
            }
        } else {
            status = .pomodoro
            withAnimation {
                progress = 1
            }
            
            breakLengthInSeconds = model.breakLengthInSeconds
        }
    }
    
    func updateTimer() {
        switch status {
        case .pomodoro:
            pomodoroRunning()
        case .break:
            breakRunning()
        }
    }
}
