//
//  ContentView.swift
//  MacStat
//
//  Created by alex haidar on 8/9/24.
//

import SwiftUI
import AppKit

struct ContentView: View {
    
    @ObservedObject var statsController = StatsController.shared
    
    let systemModelAndChip = SystemInfo.displayModelAndChip()
    let totalCores = SystemInfo.getTotalCores()
    let totalMemory = SystemInfo.getTotalMemory()
    
    var body: some View {
        VStack {
            Text("MacStat")
                .font(.system(size: 17.7, weight: .semibold, design: .default))
                .foregroundColor(Color.primary.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .opacity(2.0)
            
            Text(systemModelAndChip)
                .padding(.top, 3)
                .font(.system(size: 17.7, weight: .semibold, design: .default))
                .foregroundColor(Color.primary.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack {
                Image(systemName: "gauge.with.dots.needle.67percent")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .opacity(0.7)
                    .frame(width: 60)
                
                Text("CPU Usage :")
                    .font(.system(size: 15.17, weight: .regular, design: .default ))
                    .opacity(0.8)
                
                Spacer()
                
                Text("\(statsController.cpuUsage)")
                    .font(.system(size: 17, weight: .semibold, design: .default))
                Text("%")
                    .font(.system(size: 15.17, weight: .light, design: .default))
                    .opacity(0.7)
            }
            
            Divider()
                .opacity(2.0)
                .padding(.vertical, 4)
            
            HStack {
                Image(systemName: "cpu.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .opacity(0.7)
                    .frame(width: 60)
                
                Text("Memory Usage :")
                    .font(.system(size: 15.17, weight: .regular, design: .default))
                    .opacity(0.7)
                
                Spacer()
                
                Text(String(format: "%.2f", statsController.memoryUsage))
                    .font(.system(size: 17, weight: .semibold, design: .default))
                Text("/ \(totalMemory) GB")
                    .font(.system(size: 15.17, weight: .light, design: .default))
                    .opacity(0.7)
            }
                        
            TemperatureChartView()
                .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}

