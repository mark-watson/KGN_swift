//
//  KGNApp.swift
//  KGN
//
//  Created by Mark L. Watson on 6/20/21.
//

import SwiftUI

@main
struct KGNApp: App {
    var body: some Scene {
        WindowGroup {
          MainView()
            .frame(width: 1200, height: 770)    // << here for macOS !!
            //.frame(width: 660, height: 770)    // << here for iPadOS and iPhone iOS !!
        }
    }
}
