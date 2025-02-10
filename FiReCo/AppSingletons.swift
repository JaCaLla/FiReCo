//
//  AppSingletons.swift
//  LocationSampleApp
//
//  Created by Javier Calatrava on 1/12/24.
//

import Foundation

@MainActor
struct AppSingletons {
    var remoteConfigManager: RemoteConfigManager
    
    init(remoteConfigManager: RemoteConfigManager? = nil) {
        self.remoteConfigManager = RemoteConfigManager()
    }
}

@MainActor var appSingletons = AppSingletons()
