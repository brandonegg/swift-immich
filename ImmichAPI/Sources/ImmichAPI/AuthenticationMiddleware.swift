import Foundation
import HTTPTypes
import OpenAPIRuntime

/// Adds the credential's header to every outgoing request.
struct AuthenticationMiddleware: ClientMiddleware {
    let credential: ImmichCredential

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        switch credential {
        case .apiKey(let key):
            request.headerFields[Self.apiKeyField] = key
        case .accessToken(let token):
            request.headerFields[.authorization] = "Bearer \(token)"
        }
        return try await next(request, body, baseURL)
    }

    // The name is a compile-time constant that is always a valid field name.
    // swiftlint:disable:next force_unwrapping
    private static let apiKeyField = HTTPField.Name("x-api-key")!
}
