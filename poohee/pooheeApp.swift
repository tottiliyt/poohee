//
//  pooheeApp.swift
//  poohee
//
//  Created by Yuntao Li on 3/27/22.
//

import SwiftUI

@main
struct pooheeApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

extension Color {
    static let primaryColor = Color(red: 246/255, green: 199/255, blue: 77/255)
    static let secondaryColor = Color(red: 121/255, green: 131/255, blue: 221/255)
    static let chatPink = Color(red: 254/255, green: 156/255, blue: 163/255)
}
