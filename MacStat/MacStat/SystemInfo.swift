//
//  SystemInfo.swift
//  MacStat
//
//  Created by alex haidar on 8/15/24.
//

import Foundation
import MachO

class SystemInfo {
    
    static func getTotalCores() -> Int {
        return ProcessInfo.processInfo.activeProcessorCount
    }
    
    static func getTotalMemory() -> UInt64 {
        return ProcessInfo.processInfo.physicalMemory / UInt64(1024 * 1024 * 1024)    //mathmatical op to convert raw data to GB
    }
    
    static func getCPUUsage() -> Int {
        func fetchCPUTicks() -> (totalTicks: UInt64, idleTicks: UInt64)? {
            var size: mach_msg_type_number_t = 0
            var cpuInfo: processor_info_array_t?
            var cpuCount: mach_msg_type_number_t = 0
            let hostPort: host_t = mach_host_self()
            
            let result = host_processor_info(hostPort, PROCESSOR_CPU_LOAD_INFO, &cpuCount, &cpuInfo, &size)
            
            if result != KERN_SUCCESS {
                print("Error fetching CPU info")
                return nil
            }
            
            var totalTicks: UInt64 = 0
            var totalIdleTicks: UInt64 = 0
            
            if let cpuInfo = cpuInfo {
                let cpuLoadArray = UnsafeBufferPointer(start: cpuInfo, count: Int(cpuCount) * Int(CPU_STATE_MAX))
                
                for i in 0..<Int(cpuCount) {
                    let userTicks = cpuLoadArray[i * Int(CPU_STATE_MAX) + Int(CPU_STATE_USER)]
                    let systemTicks = cpuLoadArray[i * Int(CPU_STATE_MAX) + Int(CPU_STATE_SYSTEM)]
                    let idleTicks = cpuLoadArray[i * Int(CPU_STATE_MAX) + Int(CPU_STATE_IDLE)]
                    let niceTicks = cpuLoadArray[i * Int(CPU_STATE_MAX) + Int(CPU_STATE_NICE)]
                    
                    let activeTicks = UInt64(userTicks + systemTicks + niceTicks)
                    let totalCoreTicks = activeTicks + UInt64(idleTicks)
                    
                    totalTicks += totalCoreTicks
                    totalIdleTicks += UInt64(idleTicks)
                }
            }
            return (totalTicks: totalTicks, idleTicks: totalIdleTicks)
        }
        
        guard let firstSnapshot = fetchCPUTicks() else { return 0 }
        usleep(100_000)
        guard let secondSnapshot = fetchCPUTicks() else { return 0 }
        
        let totalTicksDiff = secondSnapshot.totalTicks - firstSnapshot.totalTicks
        let idleTicksDiff = secondSnapshot.idleTicks - firstSnapshot.idleTicks
        
        if totalTicksDiff == 0 {
            return 0
        }
        
        let idlePercentage = Double(idleTicksDiff) / Double(totalTicksDiff) * 100
        return Int(100 - idlePercentage)
    }
    
    static func getActiveMemory() -> Double {
        let HOST_VM_INFO64_COUNT = MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size
        var counter = mach_msg_type_number_t(HOST_VM_INFO64_COUNT)
        var sysWideMemory = vm_statistics64()
        
        let kernReturn = withUnsafeMutablePointer(to: &sysWideMemory) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(counter)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &counter)
            }
        }
        
        if kernReturn == KERN_SUCCESS {
            let pageSize = vm_kernel_page_size
            let activeMemory = (UInt64(sysWideMemory.active_count) + UInt64(sysWideMemory.wire_count)) * UInt64(pageSize)
            let passiveMemory = UInt64(sysWideMemory.inactive_count) * UInt64(pageSize)
            let totalMemory = activeMemory + passiveMemory
            return Double(totalMemory) / (1024 * 1024 * 1024)
        }
        return 0.0
    }
    
    static func displayModelAndChip() -> String {
        var byteSize: Int = 0
        sysctlbyname("hw.model", nil, &byteSize, nil, 0)
        var StoreResult = [CChar](repeating: 0, count: byteSize )
        sysctlbyname("hw.model", &StoreResult, &byteSize,nil, 0)
        
        let convertToString = String(cString: StoreResult)
        
        switch convertToString {
        case "Mac15,6":
            return "Macbook Pro - Apple M3 Pro '14"
        case "Mac15,7":
            return "Macbook Pro - Apple M3 Pro '16"
        case "Mac15,9":
            return "MacBook Pro - Apple M3 Max"
        case "Mac14,2":
            return "MacBook Air - Apple M2"
        case "Mac15,3":
            return "MacBook Pro - Apple M3"
        case "Mac15,12":
            return "MacBook Air - Apple M3"
        case "Mac14,9":
            return "MacBook Pro - Apple M2 Pro"
        case "Mac14,5":
            return "MacBook Pro - Apple M2 Max"
        case "MacBookPro18,1":
            return "MacBook Pro - Apple M1 Pro"
        case "MacBookAir10,1":
            return "MacBook Air - Apple M1"
        case "MacBookPro17,1":
            return "MacBook Pro (TouchBar) - Apple M1"
        case "Mac14,7":
            return "MacBook Pro (TouchBar) - Apple M2"
        case "MacBookPro18,2":
            return "MacBook Pro - Apple M1 Max"
        case "Macmini9,1":
            return "Mac Mini - Apple M1"
        case "Mac14,3":
            return "Mac Mini - Apple M2"
        case "Mac14,12":
            return "Mac Mini - Apple M2 Pro"
            
            // Intel Macs
        case "MacBookPro14,2", "MacBookPro15,3", "MacBookPro15,4":
            return "Intel Mac"
            
            // Default case
        default:
            return "-- --"
        }
    }
}
