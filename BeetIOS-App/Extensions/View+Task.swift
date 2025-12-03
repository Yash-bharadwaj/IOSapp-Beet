import SwiftUI

extension View {
    /// Safely executes an async task with automatic cancellation on view disappearance
    func task(
        priority: TaskPriority = .userInitiated,
        _ action: @escaping () async -> Void
    ) -> some View {
        self.task(id: UUID(), priority: priority, action)
    }
    
    /// Executes an async task with error handling
    func task(
        priority: TaskPriority = .userInitiated,
        _ action: @escaping () async throws -> Void,
        onError: @escaping (Error) -> Void
    ) -> some View {
        self.task(priority: priority) {
            do {
                try await action()
            } catch {
                await MainActor.run {
                    onError(error)
                }
            }
        }
    }
}

