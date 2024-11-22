import SwiftUI
import WhatsNewKit

// MARK: - App

/// The App
@main
struct App {}

// MARK: - SwiftUI.App

extension App: SwiftUI.App {
    
    /// The content and behavior of the app.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.whatsNew,
                     .init(
                        versionStore: InMemoryWhatsNewVersionStore(),
                        whatsNewCollection: self
                     )
                )
        }
    }
    
}

// MARK: - App+WhatsNewCollectionProvider

extension App: WhatsNewCollectionProvider {
    
    /// A WhatsNewCollection
    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(
            version: "1.0.0",
            title: "WhatsNewKit",
            features: [
                .init(
                    image: .init(
                        systemName: "star.fill",
                        foregroundColor: .orange
                    ),
                    title: "Showcase your new App Features",
                    subtitle: "Present your new app features just like a native app from Apple."
                ),
                .init(
                    image: .init(
                        systemName: "wand.and.stars",
                        foregroundColor: .cyan
                    ),
                    title: "Automatic Presentation",
                    subtitle: .init(
                        try! AttributedString(
                            markdown: "Simply declare a WhatsNew per Version and present it automatically by using the `.whatsNewSheet()` modifier."
                        )
                    )
                ),
                .init(
                    image: .init(
                        systemName: "gear.circle.fill",
                        foregroundColor: .gray
                    ),
                    title: "Configuration",
                    subtitle: "Easily adjust colors, strings, haptic feedback, behaviours and the layout of the presented WhatsNewView to your needs."
                ),
                .init(
                    image: .init(
                        systemName: "swift",
                        foregroundColor: .init(.init(red: 240.0 / 255, green: 81.0 / 255, blue: 56.0 / 255, alpha: 1))
                    ),
                    title: "Swift Package Manager",
                    subtitle: "WhatsNewKit can be easily integrated via the Swift Package Manager."
                )
            ],
            primaryAction: .init(
                hapticFeedback: {
                    #if os(iOS)
                    .notification(.success)
                    #else
                    nil
                    #endif
                }()
            ),
            secondaryAction: .init(
                title: "Learn more",
                action: .openURL(.init(string: "https://github.com/SvenTiigi/WhatsNewKit"))
            ),
            headerBuilder: {
                Circle()
                .fill(Color.green.gradient)
                .overlay { 
                    Image(systemName: "star.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(width: 80, height: 80)
                .padding(.bottom, 10)
            }
        )
        
        WhatsNew(
            version: .init(major: 0, minor: 1, patch: 0),
            title: "What's New in 0.0",
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
        
        
        WhatsNew(
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
        
        WhatsNew(
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
