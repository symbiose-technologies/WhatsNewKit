import SwiftUI

// MARK: - View+sheet(whatsNew:)

public extension View {

    /// Presents a WhatsNewView using the given WhatsNew object as a data source for the sheet’s content.
    /// - Parameters:
    ///   - whatsNew: A Binding to an optional WhatsNew object
    ///   - versionStore: The optional WhatsNewVersionStore. Default value `nil`
    ///   - layout: The WhatsNew Layout. Default value `.default`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
    func sheet(
        whatsNew: Binding<WhatsNew?>,
        versionStore: WhatsNewVersionStore? = nil,
        layout: WhatsNew.Layout = .default,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            ManualWhatsNewSheetViewModifier(
                whatsNew: whatsNew,
                versionStore: versionStore,
                layout: layout,
                onDismiss: onDismiss
            )
        )
    }
    
}

// MARK: - ManualWhatsNewSheetViewModifier

/// A Manual WhatsNew Sheet ViewModifier
private struct ManualWhatsNewSheetViewModifier: ViewModifier {
    
    // MARK: Properties
    
    /// A Binding to an optional WhatsNew object
    let whatsNew: Binding<WhatsNew?>
    
    /// The optional WhatsNewVersionStore
    let versionStore: WhatsNewVersionStore?
    
    /// The WhatsNew Layout
    let layout: WhatsNew.Layout
    
    /// The closure to execute when dismissing the sheet
    let onDismiss: (() -> Void)?
    
    // MARK: ViewModifier
    
    /// Gets the current body of the caller.
    /// - Parameter content: The Content
    func body(
        content: Content
    ) -> some View {
        // Check if a WhatsNew object is available
        if let whatsNew = self.whatsNew.wrappedValue {
            // Check if the WhatsNew Version has already been presented
            if self.versionStore?.hasPresented(whatsNew.version) == true {
                // Show content
                content
            } else {
                // Show WhatsNew Sheet
                content.sheet(
                    item: self.whatsNew,
                    onDismiss: self.onDismiss
                ) { whatsNew in
                    WhatsNewView(
                        whatsNew: whatsNew,
                        versionStore: self.versionStore,
                        layout: self.layout
                    )
                }
            }
        } else {
            // Otherwise show content
            content
        }
    }
    
}

// MARK: - View+whatsNewSheet()

public extension View {
    
    /// Auto-Presents a WhatsNewView to the user if needed based on the `WhatsNewEnvironment`
    /// - Parameters:
    ///   - namespaces: Array of namespaces to present WhatsNew for. Default value `[]` (global namespace)
    ///   - layout: The optional custom WhatsNew Layout. Default value `nil`
    ///   - onDismiss: The closure to execute when dismissing the sheet. Default value `nil`
    func whatsNewSheet(
        namespaces: [String] = [],
        includeGlobal: Bool = true,
        layout: WhatsNew.Layout? = nil,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        self.modifier(
            AutomaticWhatsNewSheetViewModifier(
                namespaces: namespaces,
                includeGlobal: includeGlobal,
                layout: layout,
                onDismiss: onDismiss
            )
        )
    }
    
}

// MARK: - WhatsNewSheetViewModifier

/// A Automatic WhatsNew Sheet ViewModifier
private struct AutomaticWhatsNewSheetViewModifier: ViewModifier {
    
    // MARK: Properties
    
    /// The namespaces to present WhatsNew for
    let namespaces: [String]
    
    let includeGlobal: Bool
    
    /// The optional WhatsNew Layout
    let layout: WhatsNew.Layout?
    
    /// The optional closure to execute when dismissing the sheet
    let onDismiss: (() -> Void)?
    
    /// Bool value if sheet is dismissed
    @State
    private var isDismissed: Bool?
    
    /// The WhatsNewEnvironment
    @Environment(\.whatsNew)
    private var whatsNewEnvironment
    
    
    var itemBinding: Binding<WhatsNew?> {
        .init(
            get: {
                if self.isDismissed == true {
                    return nil
                }
                
                return self.whatsNewEnvironment.whatsNew(forNamespaces: self.namespaces, includeGlobal: self.includeGlobal)
                
            },
            set: { value, transaction in
                self.isDismissed = value == nil
            }
        )
    }
    
    // MARK: ViewModifier
    
    /// Gets the current body of the caller.
    /// - Parameter content: The Content
    func body(
        content: Content
    ) -> some View {
        content
            .sheet(item: Binding <WhatsNew?>.init(
                get: {
                    if self.isDismissed == true {
                        return nil
                    }
                    
                    return self.whatsNewEnvironment.whatsNew(forNamespaces: self.namespaces, includeGlobal: self.includeGlobal)
                    
                },
                set: { value, transaction in
                    self.isDismissed = value == nil
                }
            )) {
                self.onDismiss?()
            } content: { whatsNew in
                WhatsNewView(
                    whatsNew: whatsNew,
                    versionStore: self.whatsNewEnvironment.whatsNewVersionStore,
                    layout: self.layout ?? self.whatsNewEnvironment.defaultLayout
                )
            }
            .onChange(of: self.isDismissed, initial: false) { old, new in
                if new == true {
                    //after 0.2 second -- check if there is another
                    self.showNextIfAvailable()
                }
            }
            
    }
    
    func showNextIfAvailable() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            if let whatsNew = self.whatsNewEnvironment.whatsNew(forNamespaces: self.namespaces) {
//                self.isDismissed = nil
//            }
//        }
    }
    
}
