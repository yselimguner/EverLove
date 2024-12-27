import SwiftUI

struct SpecialEventAddView: View {
    @State private var eventName: String = ""
    @State private var eventDate: Date = Date()
    @State private var addToCalendar: Bool = false
    @State private var showAlert: Bool = false
    @State private var selectedEventType: EventType = .birthday
    @State private var periodDuration: Int = 1

    @AppStorage("specialEvents") private var specialEventsData: Data = Data()

    enum EventType: String, CaseIterable, Codable {
        case birthday = "Birthday 🎂"
        case wedding = "Wedding Anniversary 💍"
        case period = "Period 📅"
        case special = "Special Day ✨"
    }

    var body: some View {
        ZStack {
            // Background with gradient and stars
            LinearGradient(
                gradient: Gradient(colors: [.mint, .blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .overlay(
                Image(systemName: "sparkles")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .opacity(0.1)
                    .offset(x: -50, y: -50)
            )

            VStack(spacing: 20) {
                Text("Özel Gün Ekle")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                // Event Type Picker
                HStack {
                    Text("Etkinlik Türü:")
                        .fontWeight(.semibold)
                    Spacer()
                    Picker("Seçin", selection: $selectedEventType) {
                        ForEach(EventType.allCases, id: \.self) { event in
                            Text(event.rawValue).tag(event)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()

                // Show TextField only for Special Day
                if selectedEventType == .special {
                    TextField("Özel Gün Detayı", text: $eventName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }

                // Show Period Duration for Period Type
                if selectedEventType == .period {
                    HStack {
                        Text("Kaç Gün Sürer?")
                        Spacer()
                        Stepper("\(periodDuration) Gün", value: $periodDuration, in: 1...10)
                            .padding()
                    }
                }

                // Date Picker
                DatePicker("Tarih", selection: $eventDate, displayedComponents: .date)
                    .padding()

                // Toggle for adding to the calendar (no extra date picker)
                Toggle("Takvime Ekle", isOn: $addToCalendar)
                    .padding()

                // Save Button
                Button(action: saveSpecialEvent) {
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Başarılı"),
                message: Text("Etkinlik başarıyla eklendi!"),
                dismissButton: .default(Text("Tamam"))
            )
        }
    }

    private func saveSpecialEvent() {
        // Handle saving logic
        var events = loadSpecialEvents()

        if selectedEventType == .period {
            // Create events for the duration of the period
            for day in 0..<periodDuration {
                let periodDate = Calendar.current.date(byAdding: .day, value: day, to: eventDate) ?? eventDate
                events.append(SpecialEvent(
                    name: "Period Day \(day + 1)",
                    date: periodDate,
                    eventType: .period
                ))
            }
        } else {
            // Create a single event
            let event = SpecialEvent(
                name: selectedEventType == .special ? eventName : "",
                date: eventDate,
                eventType: selectedEventType
            )
            events.append(event)
        }

        if let encoded = try? JSONEncoder().encode(events) {
            specialEventsData = encoded
            showAlert = true
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
    var eventType: SpecialEventAddView.EventType
}

struct SpecialEventAddView_Previews: PreviewProvider {
    static var previews: some View {
        SpecialEventAddView()
    }
}
