//
//  ContentView.swift
//  FiReCo
//
//  Created by Javier Calatrava on 10/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showNewFeature = false
    @StateObject var remoteConfigManager = appSingletons.remoteConfigManager
    var body: some View {
        VStack {
            if remoteConfigManager.newTentativeFeatureFlag {
                Text("New Feature is Enabled!")
                    .font(.largeTitle)
                    .foregroundColor(.green)
            } else {
                Text("New Feature is Disabled.")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    ContentView()
}
