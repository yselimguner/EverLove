import SwiftUI

struct SpecialEventAddView: View {
    @State private var eventName: String = ""
    @State private var eventDate: Date = Date()
    @State private var addToCalendar: Bool = false // Hatırlatma yerine Takvime Ekle
    @State private var reminderDate: Date? = nil
    @State private var showAlert: Bool = false
    
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
            
            Toggle("Takvime Ekle", isOn: $addToCalendar) // "Hatırlatma Ekle" yerine "Takvime Ekle"
                .padding()
            
            if addToCalendar {
                DatePicker("Takvim Tarihi", selection: Binding(
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
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Başarılı"),
                message: Text("Etkinlik başarıyla eklendi!"),
                dismissButton: .default(Text("Tamam"))
            )
        }
    }
    
    private func saveSpecialEvent() {
        let event = SpecialEvent(name: eventName, date: eventDate, reminderDate: reminderDate)
        
        var events = loadSpecialEvents()
        events.append(event)
        
        if let encoded = try? JSONEncoder().encode(events) {
            specialEventsData = encoded
            showAlert = true // Gösterilecek popup'ı tetikle
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
