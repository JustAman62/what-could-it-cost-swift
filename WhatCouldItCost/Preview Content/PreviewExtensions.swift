import SwiftUI

extension View {
    func previewEnvironment() -> some View {
        self
            .withNotifierSupport()
    }
}
