import Foundation
import OSLog

public extension Logger {
    init<Subject>(_ subject: Subject) {
        self.init(subsystem: Bundle.main.bundleIdentifier ?? "amandhoot.WhatCouldItCost", category: String(describing: subject))
    }
    
    init(_ category: String) {
        self.init(subsystem: Bundle.main.bundleIdentifier ?? "amandhoot.WhatCouldItCost", category: category)
    }
}
