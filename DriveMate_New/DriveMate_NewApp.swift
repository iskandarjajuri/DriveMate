//
//  DriveMate_NewApp.swift
//  DriveMate_New
//
//  Created by iskandar jajuri on 16/12/24.
//

import SwiftUI

@main
struct DriveMate_NewApp: App {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel) // Pastikan ini ada
        }
    }
}
