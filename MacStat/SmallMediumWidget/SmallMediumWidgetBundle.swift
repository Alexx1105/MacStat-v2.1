//
//  smallMediumWidgetBundle.swift
//  smallMediumWidget
//
//  Created by alex haidar on 8/27/24.
//

import WidgetKit
import SwiftUI

@main
struct smallMediumWidgetBundle: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "display CPU temp and memory usage", provider: Provider()) { entry in
            smallMediumWidgetEntryView(entry: entry)
        }
       
        .configurationDisplayName("MacStat")
        .description("display CPU temp and memory usage")
        .supportedFamilies([ .systemMedium])    //add small widget later
        
       
    }
}
