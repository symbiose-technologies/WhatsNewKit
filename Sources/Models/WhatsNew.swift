import Foundation

// MARK: - WhatsNew

import SwiftUI

public enum WNew { }

public extension WNew {
    
}

/// A WhatsNew object
public struct WhatsNew {
    
    // MARK: Properties
    
    /// The Version
    public var version: WNew.Version
    
    /// The Title
    public var title: Title
    
    /// The Features
    public var features: [Feature]
    
    /// The PrimaryAction
    public var primaryAction: PrimaryAction
    
    /// The optional SecondaryAction
    public var secondaryAction: SecondaryAction?
    
    // MARK: Initializer
    public var headerBuilder: () -> AnyView


    /// Creates a new instance of `WhatsNew`
    /// - Parameters:
    ///   - version: The Version. Default value `.current()`
    ///   - title: The Title
    ///   - items: The Features
    ///   - primaryAction: The PrimaryAction. Default value `.init()`
    ///   - secondaryAction: The optional SecondaryAction. Default value `nil`
    public init<H: View>(
        version: WNew.Version = .current(),
        title: Title,
        features: [Feature],
        primaryAction: PrimaryAction = .init(),
        secondaryAction: SecondaryAction? = nil,
        @ViewBuilder headerBuilder: @escaping () -> H = { EmptyView() }
    ) {
        self.version = version
        self.title = title
        self.features = features
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
        self.headerBuilder = { AnyView(headerBuilder()) }
    }
    
}

// MARK: - Identifiable

extension WhatsNew: Identifiable {
    
    /// The stable identity of the entity associated with this instance.
    public var id: WNew.Version {
        self.version
    }
    
}
