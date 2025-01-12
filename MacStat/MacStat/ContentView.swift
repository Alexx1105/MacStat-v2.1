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
        VStack(alignment: .leading) {
         
            HStack {
                Button( action: {                    //In 3.0, this will be modded later on to trigger a popover window prompt with a quit app option, version option, and change icon option
                    
                    closeWindow()
                }) {
                    Image("MacStat - classic")
                        .resizable()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(width: 34, height: 34)
                        .padding(.leading, -2)
                    
                    
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("⌘ Q")
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .opacity(0.2)
                    .padding(.top, 1)
                
              
            }
            
                Divider()
                    .opacity(2.0)
                    .padding(.bottom, 2)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, -15)
                   
            
            Text(systemModelAndChip)
                .padding(.top, 3)
                .font(.system(size: 17.7, weight: .semibold, design: .default))
                .foregroundColor(Color.primary.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack {
                Rectangle()
                    .frame(width: 32, height: 32)
                    .cornerRadius(5)
                    .opacity(0.1)
                 
                    .overlay {
                        Image(systemName: "gauge.with.dots.needle.67percent")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 21, height: 21)
                            .opacity(0.8)
                            .frame(width: 60)
                    }
                Text("CPU Usage ")
                    .font(.system(size: 15.17, weight: .semibold, design: .default ))
                    .opacity(0.5)
                    .padding(.horizontal)
                
                Spacer()
                
                Text("\(statsController.cpuUsage)")
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .opacity(0.8)
                Text("%")
                    .font(.system(size: 15.17, weight: .regular, design: .default))
                    .opacity(0.5)
            }
            
            Divider()
                .opacity(2.0)
                .padding(.vertical, 8)
            
            HStack {
                Rectangle()
                    .frame(width: 32, height: 32)
                    .cornerRadius(5)
                    .opacity(0.1)
                
                    .overlay {
                        Image(systemName: "cpu.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 21, height: 21)
                            .opacity(0.8)
                            .frame(width: 60)
                    }
                
                Text("Memory Usage ")
                    .font(.system(size: 15.17, weight: .semibold, design: .default))
                    .opacity(0.5)
                    .padding(.horizontal)
                Spacer()
                
                Text(String(format: "%.2f", statsController.memoryUsage))
                    .font(.system(size: 17, weight: .semibold, design: .default))
                    .opacity(0.8)
                Text("/ \(totalMemory) GB")
                    .font(.system(size: 15.17, weight: .regular, design: .default))
                    .opacity(0.5)
            }
                        
            TemperatureChartView()
                .padding(.top, 20)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    ContentView()
}

