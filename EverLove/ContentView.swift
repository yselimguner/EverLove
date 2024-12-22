//
//  ContentView.swift
//  EverLove
//
//  Created by Yavuz Selim Güner on 21.12.2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    init() {
        // TabBar'ı özelleştir
        UITabBar.appearance().backgroundColor = .white // Arka plan beyaz
        UITabBar.appearance().shadowImage = UIImage() // Gölgeyi kaldır
        UITabBar.appearance().barTintColor = .white // Arka plan rengi beyaz
    }
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "house.fill") // Seçili ikon
                    Text("Ana Sayfa")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "square.and.pencil") // Seçili olmayan ikon
                    Text("Ekran 2")
                }
                .tag(2)
            
            PremiumView()
                .tabItem {
                    Image(systemName: "gearshape.fill") // Seçili ikon
                    Text("Ekran 3")
                }
                .tag(3)
            
            SpecialEventAddView()
                .tabItem {
                    Label("Özel Gün Ekle", systemImage: "calendar.badge.plus")
                }
                .tag(4)
            
            SpecialEventListView()
                .tabItem {
                    Label("Özel Günler", systemImage: "list.dash")
                }
                .tag(5)
            
        }
        .accentColor(.black) // Seçili öğedeki ikonun rengini ayarlama
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .gray // Seçili olmayan ikon gri olacak
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
