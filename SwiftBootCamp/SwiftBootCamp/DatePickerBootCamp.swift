//
//  DatePickerBootCamp.swift
//  SwiftBootCamp
//
//  Created by arpit verma on 30/10/24.
//

import SwiftUI

struct DatePickerBootCamp: View {
    @State var currentDate : Date = Date()
    let startDate : Date = Calendar.current.date(from: DateComponents(year: 2019)) ?? Date()
    let endDate : Date = Date()
    
    var dateFormatter : DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    var body: some View {
        Text(currentDate.description)
        Text(dateFormatter.string(from: currentDate))
        DatePicker("this is date picker", selection: $currentDate)
        
        DatePicker("date picker", selection: $currentDate, displayedComponents: [
            .date,.hourAndMinute
        ])
        
        DatePicker(selection: $currentDate, in: startDate...endDate, displayedComponents: [.date], label: {Text("date picker")})
    }
}

#Preview {
    DatePickerBootCamp()
}
