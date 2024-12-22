//
//  SettingsView.swift
//  EverLove
//
//  Created by Yavuz Selim Güner on 21.12.2024.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("backgroundColor") private var backgroundColorHex: String = "#FFFFFF"
    @AppStorage("fontSize") var fontSize: Double = 20
    @AppStorage("fontType") var fontType: String = "System"

    var backgroundColor: Color {
        get {
            Color(hex: backgroundColorHex)
        }
        set {
            backgroundColorHex = newValue.toHex() ?? "#FFFFFF"
        }
    }
}

struct SettingsView: View {
    @ObservedObject var viewModel = SettingsViewModel()
    
    let fonts = ["System", "Helvetica", "Courier", "Georgia"]
    
    var body: some View {
        Form {
            Section(header: Text("Arka Plan Rengi")) {
                ColorPicker("Renk Seç", selection: Binding(
                    get: { viewModel.backgroundColor },
                    set: { viewModel.backgroundColor = $0 }
                ))
            }
            
            Section(header: Text("Yazı Tipi Boyutu")) {
                Slider(value: $viewModel.fontSize, in: 12...36, step: 1) {
                    Text("Font Size")
                }
                Text("Boyut: \(Int(viewModel.fontSize))")
                    .font(.system(size: viewModel.fontSize))
            }
            
            Section(header: Text("Yazı Tipi")) {
                Picker("Font Seç", selection: $viewModel.fontType) {
                    ForEach(fonts, id: \.self) { font in
                        Text(font).tag(font)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
        }
        .navigationTitle("Ayarlar")
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}



import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = Double((rgbValue >> 16) & 0xFF) / 255.0
        let green = Double((rgbValue >> 8) & 0xFF) / 255.0
        let blue = Double(rgbValue & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}
