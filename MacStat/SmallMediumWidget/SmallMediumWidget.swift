//
//  smallMediumWidget.swift
//  smallMediumWidget
//
//  Created by alex haidar on 8/27/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct smallMediumWidgetEntryView : View {
    var entry: Provider.Entry
    
   
   
   
    let displayModelAndChip = SystemInfo.displayModelAndChip()
    
    @ObservedObject var controller = widgetController()

    class widgetController: ObservableObject {
        
        static let shared = widgetController()
        
        @Published var cpuUsage: Int = SystemInfo.getCPUUsage()
        @Published var memoryUsage: Double = SystemInfo.getActiveMemory()
    }
 
    
    
    var body: some View {
        ZStack {
            Text(displayModelAndChip)
                .font(.system(size: 13, weight: .semibold, design: .default))
                .offset(x: -54, y: -57)
            VStack(alignment: .leading) {
                
                Divider()
                    .overlay(Color.colorThree)
                    .rotationEffect(Angle(degrees: 90))
                    .frame(width: 110)
                    .padding(.top, 60)
                    .offset(y:-15)
            }
            

            
            HStack(alignment: .top) {
                
                
                
                Rectangle()
                    .fill(Color.blueTab)
                    .frame(width: 3)
                    .cornerRadius(3)
                    .frame(height: 23.5)
                    .offset(x: 26)
                  
                   
                    RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(Color.blueMuted)
                    .offset(x: 20)
               
                    .overlay {
                        Image(systemName: "cpu.fill")
                        .frame(width: 3, height: 3)
                        .offset(x: -25)
                        .foregroundStyle(Color.blueTab)
                        
                        Text("Ram Usage")
                            .offset(x: 23)
                            .font(.system(size: 13, weight: .regular ,design: .default))
                            .foregroundStyle(Color.blueTab)
                        
                       
                    
                        Text(String(format: "%.2f", controller.memoryUsage))
                            .offset(x: 11, y:50)
                            .font(.system(size: 36, weight: .semibold ,design: .default))
                         
                        
                        Text("GB")
                            .font(.system(size: 18, weight: .regular ,design: .default))
                            .foregroundColor(Color.colorThree)
                            .offset(x: 67, y:32)
                     
                        
                    }
                      
            
                    
                    .frame(width: 120, height: 24.5)
                    Spacer()
                        .padding(.horizontal, 30)
                        .padding(.vertical, 40)
             
                HStack(alignment: .top) {
                    
                    Rectangle()
                        .fill(Color.redTab)
                        .frame(width: 3)
                        .cornerRadius(3)
                        .frame(height: 23.5)
                        .padding(.trailing, 20)
                        .offset(x: -10)
                  
                
                    RoundedRectangle(cornerRadius: 3)
                        .foregroundColor(Color.redMuted)
                        .frame(width: 120 ,height: 24.5)
                        .offset(x: -36)
                    
                        .overlay {
                            Image(systemName: "gauge.with.dots.needle.67percent")
                                .frame(width: 3, height: 3)
                                .offset(x: -82)
                                .foregroundStyle(Color.redTab)
                            
                            Text("Active CPUs")
                                .offset(x: -33, y:0)
                                .font(.system(size: 13, weight: .regular ,design: .default))
                                .foregroundStyle(Color.redTab)
                            
                           
                            Text("\(controller.cpuUsage)")
                                .position(x: 5, y:60)
                                .font(.system(size: 36, weight: .semibold ,design: .default))
                            
                            Text("%")
                                .font(.system(size: 36, weight: .regular ,design: .default))
                                .foregroundColor(Color.colorThree)
                                .position(x: 45, y: 60)
                        }
                        
                }
                
        
                    
              }
            
        }
        
          
        
          
              .containerBackground(for: .widget) {
                Color.widgetBackground
            }
     
    }
       
}
    
struct smallMediumWidget: Widget {
    let kind: String = "smallMediumWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            smallMediumWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}
