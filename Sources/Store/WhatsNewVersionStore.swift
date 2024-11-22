import Foundation

// MARK: - WhatsNewVersionStore

/// A WhatsNewVersionStore
public typealias WhatsNewVersionStore = WriteableWhatsNewVersionStore & ReadableWhatsNewVersionStore

// MARK: - WriteableWhatsNewVersionStore

/// A Writeable WhatsNewVersionStore
public protocol WriteableWhatsNewVersionStore {
    
    /// Save presented WhatsNew Version
    /// - Parameter version: The presented WhatsNew Version that should be saved
    func save(
        presentedVersion version: WNew.Version
    )
    
}

// MARK: - ReadableWhatsNewVersionStore

/// A Readable WhatsNewVersionStore
public protocol ReadableWhatsNewVersionStore {
    
    /// The WhatsNew Versions that have been already been presented
    var presentedVersions: [WNew.Version] { get }
    
    /// Returns a WhatsNew instance for the given namespaces if one should be presented
    /// - Parameters:
    ///   - whatsNewCollection: The collection of WhatsNew instances to choose from
    ///   - namespaces: The namespaces to consider. Empty array means global namespace only.
    /// - Returns: A WhatsNew instance if one should be presented, nil otherwise
    func whatsNewToPresent(
        from whatsNewCollection: [WhatsNew],
        namespaces: [String],
        includeGlobal: Bool
    ) -> WhatsNew?
}

// MARK: - ReadableWhatsNewVersionStore+hasPresented

public extension ReadableWhatsNewVersionStore {
    
    /// Retrieve a bool value if a given WhatsNew Version has already been presented
    /// - Parameter whatsNew: The WhatsNew Version to verify
    /// - Returns: A Bool value if the given WhatsNew Version has already been preseted
    func hasPresented(
        _ version: WNew.Version
    ) -> Bool {
        self.presentedVersions.contains(version)
    }
    
    /// Retrieve a bool value if a given WhatsNew has already been presented
    /// - Parameter whatsNew: The WhatsNew to verify
    /// - Returns: A Bool value if the given WhatsNew has already been preseted
    func hasPresented(
        _ whatsNew: WhatsNew
    ) -> Bool {
        self.hasPresented(whatsNew.version)
    }
    
    /// Returns a WhatsNew instance for the given namespaces if one should be presented
    /// - Parameters:
    ///   - whatsNewCollection: The collection of WhatsNew instances to choose from
    ///   - namespaces: The namespaces to consider. Empty array means global namespace only.
    /// - Returns: A WhatsNew instance if one should be presented, nil otherwise
    func whatsNewToPresent(
        from whatsNewCollection: [WhatsNew],
        namespaces: [String],
        includeGlobal: Bool = true
    ) -> WhatsNew? {
        // If no namespaces specified, look for global WhatsNew
        if namespaces.isEmpty || includeGlobal {
            let globalWhatsNew = whatsNewCollection
                .filter { $0.version.namespace == nil }
            
            // Get the highest version that has been presented
            let highestPresentedVersion = globalWhatsNew
                .filter { self.hasPresented($0) }
                .max(by: { $0.version < $1.version })?
                .version
            
            // Only show versions higher than the highest presented version
            return globalWhatsNew
                .filter { whatsNew in
                    if let highestPresented = highestPresentedVersion {
                        return whatsNew.version > highestPresented
                    }
                    return true
                }
                .max(by: { $0.version < $1.version })
        }
        
        // Look for namespace-specific WhatsNew
        let namespaceWhatsNew = whatsNewCollection
            .filter { whatsNew in
                guard let namespace = whatsNew.version.namespace else {
                    return false
                }
                return namespaces.contains(namespace)
            }
        
        // Get the highest version that has been presented
        let highestPresentedVersion = namespaceWhatsNew
            .filter { self.hasPresented($0) }
            .max(by: { $0.version < $1.version })?
            .version
        
        // Only show versions higher than the highest presented version
        return namespaceWhatsNew
            .filter { whatsNew in
                if let highestPresented = highestPresentedVersion {
                    return whatsNew.version > highestPresented
                }
                return true
            }
            .max(by: { $0.version < $1.version })
    }
}
