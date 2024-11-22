import SwiftUI
import WhatsNewKit

// MARK: - ExamplesView

/// The ExamplesView
struct ExamplesView {
    
    /// The Examples
    private let examples = WhatsNew.Example.allCases
    
    /// The currently presented WhatsNew object
    @State
    private var whatsNew: WhatsNew?
    
}

// MARK: - View

extension ExamplesView: View {
    
    /// The content and behavior of the view
    var body: some View {
        List {
            Section(
                header: Text(
                    verbatim: "Examples"
                ),
                footer: Text(
                    verbatim: "Tap on an example to manually present a WhatsNewView"
                )
            ) {
                ForEach(
                    self.examples,
                    id: \.rawValue
                ) { example in
                    Button(
                        action: {
                            withAnimation(.default) {
//                                self.whatsNew = nil
                                self.whatsNew = example.whatsNew
                            }
                        }
                    ) {
                        Text(
                            verbatim: example.displayName
                        )
                    }
                }
            }
            Section {
                NavigationLink {
                    ZStack {
                        Text("Feature Tour Root")
                    }
                    .whatsNewSheet(
                        namespaces: [
                            "feature-tour"
                        ],
                        includeGlobal: false
                    )
                    
                } label: {
                    Text("Feature Tour View")
                }
                
                NavigationLink {
                    ZStack {
                        Text("Global View Root")
                    }
                    .whatsNewSheet(
                        namespaces: [],
                        includeGlobal: true
                    )
                    
                } label: {
                    Text("Another Global View")
                }
            } header: {
                Text("Secondary Namespace")
            }
            
        }
        .navigationTitle("WhatsNewKit")
        .sheet(
            whatsNew: self.$whatsNew
        )
    }
    
    
}

// MARK: - WhatsNew+Example

private extension WhatsNew {
    
    /// A WhatsNew Example
    enum Example: String, Codable, Hashable, CaseIterable {
        /// Calendar
        case calendar
        /// Maps
        case maps
        /// Translate
        case translate
        /// Onboarding
        case onboarding
        /// Feature Tour
        case featureTour
    }
    
}

// MARK: - WhatsNew+Example+displayName

private extension WhatsNew.Example {
    
    /// The user friendly display name
    var displayName: String {
        self.rawValue.prefix(1).capitalized + self.rawValue.dropFirst()
    }
    
}

// MARK: - WhatsNew+Example+whatsNew

private extension WhatsNew.Example {
    
    /// The WhatsNew
    var whatsNew: WhatsNew {
        switch self {
        case .calendar:
            return .init(
                version: .init(major: 1, minor: 0, patch: 0, namespace: "calendar"),
                title: "What's New in Calendar",
                features: [
                    .init(
                        image: .init(
                            systemName: "envelope",
                            foregroundColor: .red
                        ),
                        title: "Found Events",
                        subtitle: "Siri suggests events found in Mail, Messages, and Safari, so you can add them easily."
                    )
                ]
            )
            
        case .maps:
            return .init(
                version: .init(major: 1, minor: 0, patch: 0, namespace: "maps"),
                title: "Discover Maps",
                features: [
                    .init(
                        image: .init(
                            systemName: "map",
                            foregroundColor: .green
                        ),
                        title: "Enhanced Navigation",
                        subtitle: "New turn-by-turn directions with improved accuracy."
                    )
                ]
            )
            
        case .translate:
            return .init(
                version: .init(major: 1, minor: 0, patch: 0, namespace: "translate"),
                title: "Translation Features",
                features: [
                    .init(
                        image: .init(
                            systemName: "globe",
                            foregroundColor: .blue
                        ),
                        title: "Real-time Translation",
                        subtitle: "Instantly translate conversations in multiple languages."
                    )
                ]
            )
            
        case .onboarding:
            return .init(
                version: .init(major: 1, minor: 0, patch: 0, namespace: "onboarding"),
                title: "Welcome to Our App",
                features: [
                    .init(
                        image: .init(
                            systemName: "star.fill",
                            foregroundColor: .yellow
                        ),
                        title: "Getting Started",
                        subtitle: "Learn the basics of using our app with this quick tour."
                    ),
                    .init(
                        image: .init(
                            systemName: "person.fill",
                            foregroundColor: .blue
                        ),
                        title: "Profile Setup",
                        subtitle: "Customize your profile to get the most out of your experience."
                    )
                ]
            )
            
        case .featureTour:
            return .init(
                version: .init(major: 1, minor: 0, patch: 0, namespace: "feature-tour"),
                title: "New Features Tour",
                features: [
                    .init(
                        image: .init(
                            systemName: "wand.and.stars",
                            foregroundColor: .purple
                        ),
                        title: "Advanced Features",
                        subtitle: "Discover powerful tools and features to enhance your workflow."
                    ),
                    .init(
                        image: .init(
                            systemName: "gear",
                            foregroundColor: .gray
                        ),
                        title: "Custom Settings",
                        subtitle: "Configure the app to work exactly how you want it."
                    )
                ]
            )
        }
    }
    
}

// MARK: - AttributeContainer+foregroundColor

private extension AttributeContainer {
    
    /// A AttributeContainer with a given foreground color
    /// - Parameter color: The foreground color
    static func foregroundColor(
        _ color: Color
    ) -> Self {
        var container = Self()
        container.foregroundColor = color
        return container
    }
    
}
