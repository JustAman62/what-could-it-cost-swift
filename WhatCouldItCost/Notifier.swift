import Foundation
import SwiftUI
import OSLog

enum Message {
    case inAppError(error: Error)
    case inApp(title: String, msg: String)
    
    var description: String {
        switch self {
        case .inApp(title: let title, msg: let msg):
            "Message: \(title), \(msg)"
        case .inAppError(error: let error):
            "Error: \(error.localizedDescription)"
        }
    }
}

@Observable
final class Notifier {
    static let shared: Notifier = .init()
        
    private let logger: Logger = .init(Notifier.self)
    private var _message: Message?

    var message: Message? { get { _message } }
    
    func show(msg: Message, duration: DispatchTimeInterval) {
        self.logger.error("Alerting user: \(msg.description)")
        self._message = msg
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: duration)) {
            self._message = nil
        }
    }
    
    func show(msg: Message) {
        self.logger.error("Alerting user: \(msg.description)")
        self._message = msg
    }
    
    func clear() { self._message = nil }
}

extension Notifier {
    func execute(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            self.show(msg: .inAppError(error: error))
        }
    }
    
    func execute(_ action: () async throws -> Void) async {
        do {
            try await action()
        } catch {
            self.show(msg: .inAppError(error: error))
        }
    }
}

struct NotifierKey: EnvironmentKey {
    static let defaultValue = Notifier.shared
}

extension EnvironmentValues {
    var notifier: Notifier {
        get { self[NotifierKey.self] }
        set { self[NotifierKey.self] = newValue }
    }
}

struct NotifierViewModifier: ViewModifier {
    @State private var messageService: Notifier = .shared

    func body(content: Content) -> some View {
        return content
            .environment(\.notifier, messageService)
            .alert(
                "Message",
                isPresented: .init(get: { messageService.message != nil }, set: { _ in messageService.clear() }),
                presenting: messageService.message,
                actions: { _ in Button("OK") { } },
                message: { message in
                    switch message {
                    case .inApp(title: _, msg: let msg):
                        Text(msg)
                    case .inAppError(error: let error):
                        Text(error.localizedDescription)
                    }
                }
            )
    }
}

extension View {
    func withNotifierSupport() -> some View {
        return self.modifier(NotifierViewModifier())
    }
}

#if DEBUG
#Preview {
    Group {
        Button("Raise Error") {
            Notifier.shared
                .show(msg: .inAppError(
                    error: GameActionError.priceBelowMin
                ))
        }
        
        Button("Show Message") {
            Notifier.shared
                .show(msg: .inApp(
                    title: "Example Title",
                    msg: "Example Message"))
        }
    }
}
#endif
