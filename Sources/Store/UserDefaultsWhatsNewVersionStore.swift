import Foundation

// MARK: - UserDefaultsWhatsNewVersionStore

/// A UserDefaults WhatsNewVersionStore
public struct UserDefaultsWhatsNewVersionStore {
    
    // MARK: Properties
    
    /// The UserDefaults
    private let userDefaults: UserDefaults
    
    // MARK: Initializer
    
    /// Creates a new instance of `UserDefaultsWhatsNewVersionStore`
    /// - Parameters:
    ///   - userDefaults: The UserDefaults. Default value `.standard`
    public init(
        userDefaults: UserDefaults = .standard
    ) {
        self.userDefaults = userDefaults
    }
    
}

// MARK: - WriteableWhatsNewVersionStore

extension UserDefaultsWhatsNewVersionStore: WriteableWhatsNewVersionStore {
    
    /// Save presented WhatsNew Version
    /// - Parameter version: The presented WhatsNew Version that should be saved
    public func save(
        presentedVersion version: WNew.Version
    ) {
        self.userDefaults.set(
            version.description,
            forKey: version.key
        )
    }
    
}

// MARK: - ReadableWhatsNewVersionStore

extension UserDefaultsWhatsNewVersionStore: ReadableWhatsNewVersionStore {
    
    /// The WhatsNew Versions that have been already been presented
    public var presentedVersions: [WNew.Version] {
        self.userDefaults
            .dictionaryRepresentation()
            .filter { $0.key.starts(with: WNew.Version.keyPrefix) }
            .compactMap { $0.value as? String }
            .map(WNew.Version.init)
    }
    
}

// MARK: - Remove

public extension UserDefaultsWhatsNewVersionStore {
    
    /// Remove presented WhatsNew Version
    /// - Parameter version: The presented WhatsNew Version that should be removed
    func remove(
        presentedVersion version: WNew.Version
    ) {
        self.userDefaults
            .removeObject(forKey: version.key)
    }
    
}

// MARK: - Remove all

public extension UserDefaultsWhatsNewVersionStore {
    
    /// Remove all presented Versions
    func removeAll() {
        self.presentedVersions
            .map(\.key)
            .forEach(self.userDefaults.removeObject)
    }
    
}
