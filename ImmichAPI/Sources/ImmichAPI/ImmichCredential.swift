/// How requests to an Immich server are authenticated.
public enum ImmichCredential: Sendable, Hashable {
    /// An API key created in the Immich web UI, sent in the `x-api-key` header.
    case apiKey(String)
    /// A session access token returned by `login`, sent as a bearer token.
    case accessToken(String)
}
