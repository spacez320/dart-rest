part of http_rest;


/**
 * A response to an HTTP REST request.
 */
class HttpRestResponse implements RestResponse {
  /// HTTP response code
  final int code;
  /// HTTP response body (optional)
  final String body;
  /// additional HTTP headers (optional)
  final Map headers;

  /**
   * Generates an HTTP REST response.
   */
  const HttpRestResponse(this.code, [this.body = '', this.headers = const {}]);

  /**
   * Generates an HTTP REST response from a Map.
   */
  const HttpRestResponse.fromMap(Map response) :
    this(
      response['code'],
      response['body'] == null ? '' : response['body'],
      response['headers'] == null ? {} : response['headers']);

  /**
   * Generates an HTTP REST response from a generic object's toString().
   */
  const HttpRestResponse.fromGeneric(dynamic response) :
    this(200, response.toString(), {});

  /**
   * Generator designed to interpret endpoint responses.
   */
  factory HttpRestResponse.build(dynamic response) {
    if(response is HttpRestResponse) {
      // looks like the response is already prepared
      return response;
    } else if(response is Map) {
      // response is a Map
      return new HttpRestResponse.fromMap(response);
    } else {
      // response is some other type of value
      return new HttpRestResponse.fromGeneric(response);
    }
  }
}

