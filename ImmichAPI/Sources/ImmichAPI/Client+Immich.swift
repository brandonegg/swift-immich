import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

extension Client {
    /// Creates a client for the Immich server at `serverURL`.
    ///
    /// - Parameters:
    ///   - serverURL: The server's root URL as a user would type it, such as
    ///     `https://photos.example.com`. The REST API's `/api` prefix is added for you.
    ///   - credential: How to authenticate. Pass `nil` for public endpoints such as
    ///     `pingServer` or `login`.
    ///   - transport: The HTTP transport. Defaults to `URLSession.shared`; tests can
    ///     inject a stub.
    ///   - middlewares: Extra middlewares, run after authentication is added.
    public init(
        serverURL: URL,
        credential: ImmichCredential?,
        transport: any ClientTransport = URLSessionTransport(),
        middlewares: [any ClientMiddleware] = []
    ) {
        let auth = credential.map { [AuthenticationMiddleware(credential: $0)] } ?? []
        self.init(
            serverURL: serverURL.appending(path: "api"),
            transport: transport,
            middlewares: auth + middlewares
        )
    }
}
