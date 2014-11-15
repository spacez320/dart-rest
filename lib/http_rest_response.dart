part of http_rest;


/**
 * A response to an HTTP REST request.
 */
class HttpRestResponse implements RestResponse {

  /// HTTP response code
  int code;
  /// HTTP response body (should be optional)
  String body;
  /// additional HTTP headers (should be optional)
  Map headers;

  /**
   * Generates an HTTP REST response.
   */
  HttpRestResponse build(int code, [String body, Map headers]) {
    this.code = code;
    if(body != null) this.body = body;
    if(headers != null) this.headers = headers;

    return this;
  }
}

