import SwiftUI

// MARK: - Text+init(whatsNewText:)

extension Text {
    
    /// Creates a new instance of `Text` from a `WhatsNew.Text` instance
    /// - Parameter whatsNewText: The WhatsNew Text
    init(
        whatsNewText: WhatsNew.Text
    ) {
        // Check if iOS 15 or greater is available
        // Initialize with AttributedString
        self.init(
            AttributedString(
                whatsNewText.attributedString
            )
        )
    }
    
}
