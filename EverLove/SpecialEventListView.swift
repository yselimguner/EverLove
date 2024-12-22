//
//  SpecialEventListView.swift
//  EverLove
//
//  Created by Yavuz Selim Güner on 21.12.2024.
//

import SwiftUI

struct SpecialEventListView: View {
    @AppStorage("specialEvents") private var specialEventsData: Data = Data()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(loadSpecialEvents()) { event in
                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                        Text("Tarih: \(formattedDate(event.date))")
                            .font(.subheadline)
                        
                        if let reminder = event.reminderDate {
                            Text("Hatırlatma: \(formattedDate(reminder))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteEvent(event)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Özel Günler")
        }
    }
    
    private func loadSpecialEvents() -> [SpecialEvent] {
        if let decoded = try? JSONDecoder().decode([SpecialEvent].self, from: specialEventsData) {
            return decoded
        }
        return []
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func deleteEvent(_ event: SpecialEvent) {
        var events = loadSpecialEvents()
        events.removeAll { $0.id == event.id }
        
        if let encoded = try? JSONEncoder().encode(events) {
            specialEventsData = encoded
        }
    }
}

struct SpecialEventListView_Previews: PreviewProvider {
    static var previews: some View {
        SpecialEventListView()
    }
}
