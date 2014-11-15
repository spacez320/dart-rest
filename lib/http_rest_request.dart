part of http_rest;


/**
 * A response to an HTTP REST request.
 */
class HttpRestRequest implements RestRequest {

  /// request uri
  final String path;
  /// request method
  final String verb;
  /// request headers
  final Map headers;

  /**
   * Generates an HTTP REST request.
   */
  const HttpRestRequest(this.path, this.verb, this.headers);

  const HttpRestRequest.fromRequest(HttpRequest request) :
    this(request.uri, request.method, request.headers);
}

