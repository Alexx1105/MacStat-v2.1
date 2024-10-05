//
//  StatsController.swift
//  MacStat
//
//  Created on 10/5/24.
//

import Foundation

class StatsController: ObservableObject {
    
    static let shared = StatsController()
    
    private let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
    private let dataCount = 20
    private let totalCores = SystemInfo.getTotalCores()
    private let totalSystemRam = SystemInfo.getTotalMemory()
    
    @Published var memoryUsage: Double = SystemInfo.getActiveMemory()
    @Published var cpuUsage: Int = SystemInfo.getCPUUsage()
    @Published var memoryUsagePercentageHistory: [Int] = .init(repeating: 0, count: 20)
    @Published var cpuUsagePercentageHistory: [Int] = .init(repeating: 0, count: 20)

    private init() {
        self.updateHistories()
        
        timer.schedule(deadline: .now(), repeating: 3)
        timer.setEventHandler {
            let memoryUsage = SystemInfo.getActiveMemory()
            let cpuUsage = SystemInfo.getCPUUsage()
            DispatchQueue.main.async {
                self.memoryUsage = memoryUsage
                self.cpuUsage = cpuUsage
                self.updateHistories()
            }
        }
        timer.resume()
    }
    
    private func updateHistories() {
        let currentMemoryUsagePercentage = Int(Double(self.memoryUsage) / Double(self.totalSystemRam) * 100)
        self.memoryUsagePercentageHistory.append(currentMemoryUsagePercentage)
        self.memoryUsagePercentageHistory = Array(self.memoryUsagePercentageHistory.dropFirst())
        
        self.cpuUsagePercentageHistory.append(self.cpuUsage)
        self.cpuUsagePercentageHistory = Array(self.cpuUsagePercentageHistory.dropFirst())
    }
}
