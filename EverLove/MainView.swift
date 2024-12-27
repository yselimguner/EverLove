//
//  MainView.swift
//  EverLove
//
//  Created by Yavuz Selim Güner on 21.12.2024.
//

import SwiftUI

struct MainView: View {
    @State private var firstName: String = UserDefaults.standard.string(forKey: "firstName") ?? "Ad 1"
    @State private var secondName: String = UserDefaults.standard.string(forKey: "secondName") ?? "Ad 2"
    @State private var firstImage: UIImage? = UIImage(named: "placeholder")
    @State private var secondImage: UIImage? = UIImage(named: "placeholder")
    @State private var relationshipStartDate: Date? = UserDefaults.standard.object(forKey: "startDate") as? Date
    
    @State private var showNamePopup: Bool = false
    @State private var isFirstNameEditing: Bool = false
    @State private var showingImagePicker: Bool = false
    @State private var isFirstImagePicker: Bool = true
    @State private var showDatePicker: Bool = false
    
    @AppStorage("backgroundColor") private var backgroundColorHex: String = "#FFFFFF"
    @AppStorage("fontSize") private var fontSize: Double = 20
    @AppStorage("fontType") private var fontType: String = "System"
    
    var backgroundColor: Color {
        Color(hex: backgroundColorHex)
    }
    
    var body: some View {
        ZStack {
            // Arka plan rengi tüm ekranı kaplar
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack(spacing: 40) {
                    imagePickerView(image: $firstImage, name: $firstName, isFirst: true)
                    imagePickerView(image: $secondImage, name: $secondName, isFirst: false)
                }
                .padding(.top, 40)
                
                Text("Kaç Gündür Sevgiliyiz?")
                    .font(.custom(fontType, size: CGFloat(fontSize)))
                    .padding(.top, 20)
                
                Text("\(daysTogetherText())")
                    .font(.custom(fontType, size: CGFloat(fontSize)))
                    .bold()
                    .padding(.bottom, 20)
                    .onTapGesture {
                        showDatePicker.toggle()
                    }
                
                if showDatePicker {
                    VStack {
                        DatePicker(
                            "İlişki Başlangıç Tarihi",
                            selection: Binding(
                                get: { relationshipStartDate ?? Date() },
                                set: { newValue in
                                    if newValue <= Date() {
                                        relationshipStartDate = newValue
                                        UserDefaults.standard.set(newValue, forKey: "startDate")
                                        showDatePicker = false // Close DatePicker after selection
                                    }
                                }
                            ),
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // İçeriği tüm ekran boyutuna yayar
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: isFirstImagePicker ? $firstImage : $secondImage)
        }
        .alert("İsmi Düzenle", isPresented: $showNamePopup) {
            TextField("Yeni İsim", text: isFirstNameEditing ? $firstName : $secondName)
            Button("Kaydet", action: saveNames)
            Button("İptal", role: .cancel, action: {})
        }
        .onAppear {
            saveRelationshipStartDate()
        }
    }
    
    
    private func saveNames() {
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(secondName, forKey: "secondName")
    }
    
    private func saveRelationshipStartDate() {
        if let date = relationshipStartDate {
            UserDefaults.standard.set(date, forKey: "startDate")
        }
    }
    
    private func daysTogetherText() -> String {
        guard let startDate = relationshipStartDate else {
            return "Lütfen tarih seçiniz"
        }
        
        let calendar = Calendar.current
        let today = Date()
        let days = calendar.dateComponents([.day], from: startDate, to: today).day ?? 0
        
        return "\(days) gündür sevgiliyiz"
    }
    
    @ViewBuilder
    private func imagePickerView(image: Binding<UIImage?>, name: Binding<String>, isFirst: Bool) -> some View {
        VStack {
            if let uiImage = image.wrappedValue {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .onTapGesture {
                        isFirstImagePicker = isFirst
                        showingImagePicker = true
                    }
            } else {
                Circle()
                    .fill(Color.gray)
                    .frame(width: 80, height: 80)
                    .onTapGesture {
                        isFirstImagePicker = isFirst
                        showingImagePicker = true
                    }
            }
            
            Text(name.wrappedValue)
                .font(.custom(fontType, size: CGFloat(fontSize)))
                .onTapGesture {
                    isFirstNameEditing = isFirst
                    showNamePopup = true
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}
