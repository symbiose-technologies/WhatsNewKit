import Foundation

// MARK: - WhatsNew+Version

public extension WNew {
    
    /// A WhatsNew Version
    struct Version: Hashable {
        
        // MARK: Properties
        
        /// The major version
        public var major: Int
        
        /// The minor version
        public var minor: Int
        
        /// The patch version
        public var patch: Int

        /// The namespace
        public var namespace: String? = nil
        // MARK: Initializer
        
        /// Creates a new instance of `WNew.Version`
        /// - Parameters:
        ///   - major: The major version
        ///   - minor: The minor version
        ///   - patch: The patch version
        public init(
            major: Int,
            minor: Int,
            patch: Int,
            namespace: String? = nil
        ) {
            self.major = major
            self.minor = minor
            self.patch = patch
            self.namespace = namespace
        }
        
    }
    
}

// MARK: - Comparable

extension WNew.Version: Comparable {
    
    /// Returns a Boolean value indicating whether the value of the first
    /// argument is less than that of the second argument.
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func < (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.description.compare(rhs.description, options: .numeric) == .orderedAscending
    }
    
}

// MARK: - CustomStringConvertible

extension WNew.Version: CustomStringConvertible {
    
    /// A textual representation of this instance.
    public var description: String {
        let versionString = [
            self.major,
            self.minor,
            self.patch
        ]
        .map(String.init)
        .joined(separator: ".")
        
        if let namespace = self.namespace {
            return "\(namespace)@\(versionString)"
        }
        return versionString
    }
    
}

// MARK: - ExpressibleByStringLiteral

extension WNew.Version: ExpressibleByStringLiteral {
    
    /// Creates an instance initialized to the given string value.
    /// - Parameter value: The value of the new instance.
    public init(
        stringLiteral value: String
    ) {
        // Split namespace and version if present
        let parts = value.split(separator: "@", maxSplits: 1)
        if parts.count > 1 {
            self.namespace = String(parts[0])
            let versionString = String(parts[1])
            let components = versionString.components(separatedBy: ".").compactMap(Int.init)
            self.major = components.indices.contains(0) ? components[0] : 0
            self.minor = components.indices.contains(1) ? components[1] : 0
            self.patch = components.indices.contains(2) ? components[2] : 0
        } else {
            let components = value.components(separatedBy: ".").compactMap(Int.init)
            self.namespace = nil
            self.major = components.indices.contains(0) ? components[0] : 0
            self.minor = components.indices.contains(1) ? components[1] : 0
            self.patch = components.indices.contains(2) ? components[2] : 0
        }
    }
    
}

// MARK: - Current

public extension WNew.Version {
    
    /// Retrieve current WhatsNew Version based on the current Version String in the Bundle
    /// - Parameter bundle: The Bundle. Default value `.main`
    /// - Returns: WNew.Version
    static func current(
        in bundle: Bundle = .main
    ) -> WNew.Version {
        // Retrieve Bundle short Version String
        let shortVersionString = bundle.infoDictionary?["CFBundleShortVersionString"] as? String
        // Return initialized Version via String Literal
        return .init(
            stringLiteral: shortVersionString ?? ""
        )
    }
    
}

