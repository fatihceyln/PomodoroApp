//
//  ContentView.swift
//  Pomodoroo
//
//  Created by Fatih Kilit on 12.06.2022.
//

import SwiftUI

extension HomeView {
    
    private var pomodorTitle: some View {
        Text("Pomodoro 🍅")
            .font(.system(size: vm.isSmallerDevice ? 45 : 50, weight: .bold, design: .rounded))
            .foregroundColor(.white)
    }
    
    private func pomodoroRingView(proxy: GeometryProxy) -> some View {
        ZStack {
            // Outer area
            Circle()
                .trim(from: 0, to: vm.progress)
                .stroke(.gray.opacity(0.2), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .padding(-10)
                .blur(radius: 10)
            
            // Background
            Circle()
                .stroke(.gray.opacity(0.1), lineWidth: 20)
            
            // Main Circle
            Circle()
                .trim(from: 0, to: vm.progress)
                .stroke(.pink, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .shadow(color: .pink.opacity(0.8), radius: 10)
            
            knobView
            
            timerText
                .background {
                    Text(vm.status.rawValue)
                        .rotationEffect(.init(degrees: 90))
                        .offset(x: -50)
                        .font(.headline)
                        .animation(.none, value: vm.status)
                }
        }
        .padding(30)
        .rotationEffect(.degrees(-90))
        .frame(height: proxy.size.width)
    }
    
    private var knobView: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Circle()
                .fill(.pink)
                .frame(width: 30, height: 30)
                .overlay {
                    Circle()
                        .fill(.white)
                        .padding(5)
                }
                .frame(width: size.width, height: size.height, alignment: .center)
                .offset(x: size.height / 2)
                .rotationEffect(.degrees(vm.progress * 360))
                .shadow(color: .pink.opacity(0.8), radius: 10)
        }
    }
    
    private var timerText: some View {
        Text(vm.timerString)
            .font(.system(size: vm.isSmallerDevice ? 40.5 : 45, weight: .bold, design: .rounded))
            .rotationEffect(.degrees(90))
            .animation(.none, value: vm.progress)
    }
    
    private var timerButton: some View {
        Button {
            vm.setNewPomodoro = true
            withAnimation {
                vm.isTimerRunning = false
            }
        } label: {
            Image(systemName: "timer")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width * 0.15, height: UIScreen.main.bounds.width * 0.15)
                .background {
                    Circle()
                        .fill(.pink)
                }
                .shadow(color: .pink, radius: 4)
        }
    }
    
    private func controlButtons(proxy: GeometryProxy) -> some View {
        Button {
            if vm.isTimerRunning {
                vm.stopTimer()
            } else {
                vm.startTimer()
            }
        } label: {
            Text(vm.isTimerRunning ? "Stop" : "Start")
                .foregroundColor(.white)
                .font(.title2.bold())
                .frame(width: proxy.size.width * 0.18, height: proxy.size.height * 0.03)
                .padding()
                .background {
                    Capsule()
                        .fill(.pink)
                        .shadow(color: .pink, radius: 4)
                }
                .animation(.none, value: vm.isTimerRunning)
        }
        .background {
            if vm.isSessionActive {
                Button {
                    vm.resetTimer()
                } label: {
                    Text("Reset")
                }
                .offset(x: !vm.isTimerRunning ? UIScreen.main.bounds.width * 0.25 : 0)
                .opacity(!vm.isTimerRunning ? 1.0 : 0)
                .tint(.white)
            }
        }
    }
    
    private var pomodoroInfo: some View {
        Text(String(format: "%0.0f", vm.model.pomodoroLengthInMinutes) + "/" + String(format: "%0.0f", vm.model.breakLengthInMinutes))
            .underline(true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.body.bold())
            .padding(.horizontal)
    }
    
    private var pomodoroIndicator: some View {
        HStack {
            ForEach(0..<Int(vm.model.pomodoroCount), id: \.self) { index in
                Circle()
                    .frame(width: UIScreen.main.bounds.width * 0.025, height: UIScreen.main.bounds.width * 0.025)
                    .foregroundColor(index < vm.completedPomodoro ? .pink : .secondary)
                    .shadow(color: index < vm.completedPomodoro ? .pink : .clear, radius: 4)
            }
        }
    }
    
    private func newPomodoroView() -> some View {
        VStack {
            Text("New Pomodoro")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 8)
            
            Text("Durations")
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                VStack {
                    Text("Pomodoro Length")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.bottom, -5)
                    HStack {
                        Slider(value: $vm.model.pomodoroLengthInMinutes, in: 20...120, step: 5)
                            .frame(width: UIScreen.main.bounds.width * 0.65)
                            .tint(.pink)
                        
                        Spacer()
                        
                        Text("\(String(format: "%0.0f", vm.model.pomodoroLengthInMinutes)) min")
                            .padding(6)
                            .frame(width: UIScreen.main.bounds.width * 0.2)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.vertical)
                
                VStack {
                    Text("Break Length")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.bottom, -5)
                    HStack {
                        Slider(value: $vm.model.breakLengthInMinutes, in: 5...45, step: 5)
                            .frame(width: UIScreen.main.bounds.width * 0.65)
                            .tint(.pink)
                        
                        Spacer()
                        
                        Text("\(String(format: "%0.0f", vm.model.breakLengthInMinutes)) min")
                            .padding(6)
                            .frame(width: UIScreen.main.bounds.width * 0.2)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.vertical)
                
                VStack {
                    Text("Pomodoro")
                        .font(.callout)
                        .foregroundColor(.secondary)
                        .padding(.bottom, -5)
                    HStack {
                        Slider(value: $vm.model.pomodoroCount, in: 1...12, step: 1)
                            .frame(width: UIScreen.main.bounds.width * 0.65)
                            .tint(.pink)
                        
                        Spacer()
                        
                        Text("\(String(format: "%0.0f", vm.model.pomodoroCount)) times")
                            .padding(6)
                            .frame(width: UIScreen.main.bounds.width * 0.2)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.vertical)
            }
            .padding()
            .onChange(of: vm.model) { _ in
                vm.resetTimer()
            }
            
            Button {
                vm.setNewPomodoro = false
            } label: {
                Text("Save")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background {
                        Capsule()
                            .fill(.pink)
                            .frame(width: UIScreen.main.bounds.width * 0.23, height: UIScreen.main.bounds.height * (vm.isSmallerDevice ? 0.07 : 0.05))
                    }
            }
            .padding(.bottom)
            .padding(.top, -10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("popupBackground"))
                .ignoresSafeArea()
        }
    }
}

struct HomeView: View {
    
    @EnvironmentObject var vm: ViewModel
    
    var body: some View {
        VStack {
            pomodorTitle
                .frame(maxWidth: .infinity)
                .overlay {
                    pomodoroInfo
                        .padding(.top, UIScreen.main.bounds.height * 0.15)
                }
            
            GeometryReader { proxy in
                VStack(spacing: 16) {
                    pomodoroRingView(proxy: proxy)
                    
                    pomodoroIndicator
                    
                    Spacer()
                    
                    controlButtons(proxy: proxy)
                    
                    timerButton
                    
                }
                .frame(maxWidth: .infinity)
            }
        }
        // DELETE THIS LATER ON
        .onAppear(perform: {
            if UIScreen.main.bounds.width <= 380 {
                vm.isSmallerDevice = true
            }
            else {
                vm.isSmallerDevice = false
            }
        })
        .padding()
        .preferredColorScheme(.dark)
        .onReceive(Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()) { _ in
            if vm.isTimerRunning {
                vm.updateTimer()
            }
        }
        .overlay {
            ZStack {
                Color.black
                    .opacity(vm.setNewPomodoro ? 0.5 : 0)
                    .onTapGesture {
                        vm.setNewPomodoro = false
                    }
                
                newPomodoroView()
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .offset(y: vm.setNewPomodoro ? 0 : UIScreen.main.bounds.height)
            }
            .ignoresSafeArea()
            .animation(.easeInOut, value: vm.setNewPomodoro)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environmentObject(ViewModel())
                .previewDevice("iPhone 13 Pro Max")
            
            HomeView()
                .environmentObject(ViewModel())
                .previewDevice("iPhone SE (3rd generation)")
        }
    }
}
