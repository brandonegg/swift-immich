import Foundation
import HTTPTypes
import ImmichAPI
import OpenAPIRuntime
import Testing

struct ClientTests {
    private let serverURL: URL
    private let apiKeyField: HTTPField.Name

    init() throws {
        serverURL = try #require(URL(string: "https://photos.example.com"))
        apiKeyField = try #require(HTTPField.Name("x-api-key"))
    }

    @Test func sendsRequestsUnderTheAPIPrefix() async throws {
        let transport = StubTransport(json: #"{"res":"pong"}"#)
        let client = Client(serverURL: serverURL, credential: nil, transport: transport)

        _ = try await client.pingServer()

        let request = try #require(await transport.requests.first)
        #expect(request.baseURL.absoluteString == "https://photos.example.com/api")
        #expect(request.request.path == "/server/ping")
        #expect(request.request.method == .get)
    }

    @Test func omitsAuthHeadersWithoutCredential() async throws {
        let transport = StubTransport(json: #"{"res":"pong"}"#)
        let client = Client(serverURL: serverURL, credential: nil, transport: transport)

        _ = try await client.pingServer()

        let headers = try #require(await transport.requests.first).request.headerFields
        #expect(headers[apiKeyField] == nil)
        #expect(headers[.authorization] == nil)
    }

    @Test func sendsAPIKeyHeader() async throws {
        let transport = StubTransport(json: #"{"res":"pong"}"#)
        let client = Client(serverURL: serverURL, credential: .apiKey("secret"), transport: transport)

        _ = try await client.pingServer()

        let headers = try #require(await transport.requests.first).request.headerFields
        #expect(headers[apiKeyField] == "secret")
        #expect(headers[.authorization] == nil)
    }

    @Test func sendsBearerToken() async throws {
        let transport = StubTransport(json: #"{"res":"pong"}"#)
        let client = Client(serverURL: serverURL, credential: .accessToken("token"), transport: transport)

        _ = try await client.pingServer()

        let headers = try #require(await transport.requests.first).request.headerFields
        #expect(headers[.authorization] == "Bearer token")
        #expect(headers[apiKeyField] == nil)
    }

    @Test func decodesTypedResponses() async throws {
        let transport = StubTransport(json: #"{"major":3,"minor":4,"patch":1,"featureLevel":12}"#)
        let client = Client(serverURL: serverURL, credential: .apiKey("secret"), transport: transport)

        let version = try await client.getServerVersion().ok.body.json

        #expect(version.major == 3)
        #expect(version.minor == 4)
        #expect(version.patch == 1)
        #expect(version.prerelease == nil)
    }
}

/// Records each request and answers with a canned JSON body.
private actor StubTransport: ClientTransport {
    struct Recorded {
        let request: HTTPRequest
        let baseURL: URL
    }

    private(set) var requests: [Recorded] = []
    private let json: String

    init(json: String) {
        self.json = json
    }

    func send(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String
    ) async throws -> (HTTPResponse, HTTPBody?) {
        requests.append(Recorded(request: request, baseURL: baseURL))
        let response = HTTPResponse(status: .ok, headerFields: [.contentType: "application/json"])
        return (response, HTTPBody(json))
    }
}
