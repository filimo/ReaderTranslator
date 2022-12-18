//
//  Task.swift
//  ReaderTranslatorMac
//
//  Created by Viktor Kushnerov on 18.12.22.
//  Copyright © 2022 Viktor Kushnerov. All rights reserved.
//

import Foundation

extension Task where Failure == Error {
    static func delayed(
        byTimeInterval delayInterval: TimeInterval,
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable () async throws -> Success
    ) -> Task {
        Task(priority: priority) {
            let delay = UInt64(delayInterval * 1_000_000_000)
            try await Task<Never, Never>.sleep(nanoseconds: delay)
            return try await operation()
        }
    }
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds duration: Double) async throws {
        try await sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
}
