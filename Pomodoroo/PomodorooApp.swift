//
//  PomodorooApp.swift
//  Pomodoroo
//
//  Created by Fatih Kilit on 12.06.2022.
//

import SwiftUI

@main
struct PomodorooApp: App {
    @StateObject var vm: ViewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(vm)
                .onAppear {
                    if UIScreen.main.bounds.width <= 380 {
                        vm.isSmallerDevice = true
                    } else {
                        vm.isSmallerDevice = false
                    }
                    
                    vm.prepareTimerString()
                }
        }
    }
}
