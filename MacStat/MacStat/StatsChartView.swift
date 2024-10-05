//
//  StatsChartView.swift
//  MacStat
//
//  Created on 10/5/24.
//

import SwiftUI
import Charts

struct TemperatureChartView: View {
    
    @ObservedObject var statsController = StatsController.shared

    var body: some View {
        VStack {
            ZStack {
                VStack {
                    GeometryReader { geometry in
                        ForEach(0..<5) { index in
                            Path { path in
                                let yPos = geometry.size.height / 4 * CGFloat(index)
                                path.move(to: CGPoint(x: 0, y: yPos))
                                path.addLine(to: CGPoint(x: geometry.size.width, y: yPos))
                            }
                            .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                            .blur(radius: 0.1)
                        }
                    }
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 2)
                
                Chart {
                    ForEach(Array(statsController.cpuUsagePercentageHistory.enumerated()), id: \.offset) { index, data in
                        if data > 0 {
                            LineMark(
                                x: .value("Time", index),
                                y: .value("CPU Usage", data)
                            )
                            .foregroundStyle(Color.orange)
                            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        }
                    }
                }
                .chartYScale(domain: 0...100)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                
                Chart {
                    ForEach(Array(statsController.memoryUsagePercentageHistory.enumerated()), id: \.offset) { index, data in
                        if data > 0 {
                            LineMark(
                                x: .value("Time", index),
                                y: .value("Memory Usage", data)
                            )
                            .foregroundStyle(Color.cyan)
                            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        }
                    }
                }
                .chartYScale(domain: 0...100)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
            }
            
            HStack {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 10, height: 10)
                Text("CPU Usage")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.trailing, 15)
                
                Circle()
                    .fill(Color.cyan)
                    .frame(width: 10, height: 10)
                Text("Memory Usage")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.leading, 5)
            .padding(.top, 3)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 90)
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.07))
                .stroke(Color.gray.opacity(0.4), lineWidth: 2.5)
                .blur(radius: 0.2)
        )
        .padding()
    }
}

#Preview {
    TemperatureChartView()
}
