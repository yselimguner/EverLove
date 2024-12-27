import SwiftUI

struct SpecialEventListView: View {
    @AppStorage("specialEvents") private var specialEventsData: Data = Data()
    @State private var specialEvents: [SpecialEvent] = []

    var body: some View {
        NavigationView {
            List {
                if specialEvents.isEmpty {
                    VStack(alignment: .center) { // VStack içindeki elemanları ortalar
                        Text("Kayıtlı özel gün bulunamadı.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                } else {
                    ForEach(specialEvents) { event in
                        EventRow(event: event) // Use EventRow for formatted display
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteEvent(event: event)
                                } label: {
                                    Label("Sil", systemImage: "trash")
                                }
                        }
                        .listRowInsets(.init(top: 0, leading: 16, bottom: 0, trailing: 16)) // Adjust insets for better visuals
                    }
                }
            }
            .navigationTitle("Özel Günler")
            .onAppear {
                self.specialEvents = loadSpecialEvents()
            }
        }
    }

    private func loadSpecialEvents() -> [SpecialEvent] {
        if let decoded = try? JSONDecoder().decode([SpecialEvent].self, from: specialEventsData) {
            return decoded
        }
        return []
    }

    private func deleteEvent(event: SpecialEvent) {
        specialEvents.removeAll(where: { $0.id == event.id })

        if let encoded = try? JSONEncoder().encode(specialEvents) {
            specialEventsData = encoded
        }
    }
}

struct EventRow: View {
    let event: SpecialEvent

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(formattedDate(event.date)) // Call formattedDate function
                    .font(.headline)
                    .foregroundColor(.black)
                if !event.name.isEmpty {
                    Text(event.name)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                if event.eventType == .period {
                    Text("(\(event.eventType.rawValue))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Image(systemName: eventTypeIcon(event.eventType))
                .foregroundColor(eventTypeColor(event.eventType))
                .font(.system(size: 24))
                .padding()
                .background(Color(eventTypeColor(event.eventType)).opacity(0.2))
                .clipShape(Circle())
        }
        .padding(.vertical, 8)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func eventTypeIcon(_ eventType: SpecialEventAddView.EventType) -> String {
           switch eventType {
           case .birthday:
               return "birthday.cake.fill" // More specific SF Symbol
           case .wedding:
               return "rings"
           case .period:
               return "calendar"
           case .special:
               return "star.fill"
           }
       }

    private func eventTypeColor(_ eventType: SpecialEventAddView.EventType) -> Color {
        switch eventType {
        case .birthday:
            return .pink
        case .wedding:
            return .purple
        case .period:
            return .orange
        case .special:
            return .blue
        }
    }
}

struct SpecialEventListView_Previews: PreviewProvider {
    static var previews: some View {
        SpecialEventListView()
    }
}
