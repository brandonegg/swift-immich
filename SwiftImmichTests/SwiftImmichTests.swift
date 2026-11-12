import SwiftUI
import Testing

@testable import SwiftImmich

@MainActor
struct SwiftImmichTests {
    @Test func contentViewBuilds() {
        let view = ContentView()
        #expect(type(of: view.body) != Never.self)
    }
}
