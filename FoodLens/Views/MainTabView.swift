//
//  TabView.swift
//  FoodLens
//
//  Created by Harry Ahn on 10/12/2024.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            BarcodeScannerView()
                .tabItem {
                    Image(systemName: "barcode.viewfinder")
                    Text("Scanner")
                }
        }
    }
}

#Preview {
    MainTabView()
}
