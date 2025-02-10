//
//  RemoteConfigManager.swift
//  FirebaseRemoteConfig
//
//  Created by Javier Calatrava on 9/2/25.
//

import Foundation
import Firebase

@globalActor
actor GlobalManager {
    static var shared = GlobalManager()
}

@GlobalManager
class RemoteConfigManager: ObservableObject {
    @MainActor
    @Published var newTentativeFeatureFlag: Bool = false
    
    private var internalNewTentativeFeatureFlag = false {
        didSet {
            Task { @MainActor [internalNewTentativeFeatureFlag]  in
                newTentativeFeatureFlag = internalNewTentativeFeatureFlag
            }
        }
    }
    
    private var remoteConfig: RemoteConfig =  RemoteConfig.remoteConfig()
    private var configured = false

    @MainActor
    init() {
        Task { @GlobalManager in
            await self.setupRemoteConfig()
        }
    }
    
    private func setupRemoteConfig() async {
        guard !configured else { return }
        
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        fetchConfig { [weak self] result in
            guard let self else { return }
            Task { @GlobalManager [result] in
                configured = result
                self.internalNewTentativeFeatureFlag = self.getBoolValue(forKey: "NewTentativeFeatureFlag")
            }
        }
    }

    private func fetchConfig(completion: @escaping @Sendable (Bool) -> Void) {
        remoteConfig.fetch { status, error in
            if status == .success {
                Task { @GlobalManager in
                    self.remoteConfig.activate { changed, error in
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func getBoolValue(forKey key: String) -> Bool {
        return remoteConfig[key].boolValue
    }
    
    func getStringValue(forKey key: String) -> String {
        return remoteConfig[key].stringValue
    }
}
