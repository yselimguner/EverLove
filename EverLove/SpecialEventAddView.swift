//
//  SpecialDayView.swift
//  EverLove
//
//  Created by Yavuz Selim Güner on 21.12.2024.
//

import SwiftUI


struct SpecialEventAddView: View {
    @State private var eventName: String = ""
    @State private var eventDate: Date = Date()
    @State private var addReminder: Bool = false
    @State private var reminderDate: Date? = nil
    
    @AppStorage("specialEvents") private var specialEventsData: Data = Data()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Özel Gün Ekle")
                .font(.title)
                .padding()
            
            TextField("Etkinlik Adı", text: $eventName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            DatePicker("Tarih", selection: $eventDate, displayedComponents: .date)
                .padding()
            
            Toggle("Hatırlatma Ekle", isOn: $addReminder)
                .padding()
            
            if addReminder {
                DatePicker("Hatırlatma Tarihi", selection: Binding(
                    get: { reminderDate ?? Date() },
                    set: { reminderDate = $0 }
                ), displayedComponents: .date)
                .padding()
            }
            
            Button(action: {
                saveSpecialEvent()
            }) {
                Text("Ekle")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .padding()
    }
    
    private func saveSpecialEvent() {
        let event = SpecialEvent(name: eventName, date: eventDate, reminderDate: reminderDate)
        
        var events = loadSpecialEvents()
        events.append(event)
        
        if let encoded = try? JSONEncoder().encode(events) {
            specialEventsData = encoded
        }
    }
    
    private func loadSpecialEvents() -> [SpecialEvent] {
        if let decoded = try? JSONDecoder().decode([SpecialEvent].self, from: specialEventsData) {
            return decoded
        }
        return []
    }
}

struct SpecialEvent: Identifiable, Codable {
    var id = UUID()
    var name: String
    var date: Date
    var reminderDate: Date?
}

struct SpecialEventAddView_Previews: PreviewProvider {
    static var previews: some View {
        SpecialEventAddView()
    }
}
