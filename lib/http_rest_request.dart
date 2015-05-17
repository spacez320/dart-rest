part of http_rest;


/**
 * An HTTP REST request.
 */
class HttpRestRequest implements RestRequest {
  /// request uri
  final String path;
  /// request method
  final String verb;
  /// request headers
  final HttpHeaders headers;

  /**
   * Generates an HTTP REST request.
   */
  const HttpRestRequest(this.path, this.verb, this.headers);

  /**
   * Generates an HTTP REST request from an HttpRequest.
   */
  const HttpRestRequest.fromHttpRequest(HttpRequest request) :
    this(request.uri.toString(), request.method, request.headers);
}

