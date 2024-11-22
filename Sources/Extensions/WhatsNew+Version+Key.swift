import Foundation

// MARK: - WNew.Version+key

extension WNew.Version {
    
    /// The WhatsNew Version Key prefix
    static let keyPrefix = "WhatsNewKit"
    
    /// A WhatsNew Version Key the can be used to save
    /// a WhatsNew Version to the `UserDefaults` or `NSUbiquitousKeyValueStore`
    var key: String {
        [
            Self.keyPrefix,
            self.namespace ?? "global",
            self.description
        ]
        .joined(separator: ".")
    }
    
}
