part of http_rest;


/**
 * An HTTP REST route using available HTTP methods.
 */
class HttpRestRoute extends RestRoute {
  /// known HTTP methods
  final List<String> implemented_verbs = [
    'OPTIONS',
    'GET',
    'HEAD',
    'POST',
    'PUT',
    'DELETE',
    'TRACE',
    'CONNECT'
  ];

  /// map of possible HTTP verbs and verb handlers
  Map<String,HttpVerb> verbs = {};

  /**
   * Constructs an HttpRestRoute given a verb function map.
   */
  HttpRestRoute(this.verbs);

  /**
   *  Constructs an HTTP REST route from a given endpoint.
   */
  HttpRestRoute.fromEndpoint(Function endpoint) : this({ 'GET': endpoint });

  /**
   * Provides a response, given an HTTP REST request.
   */
  dynamic call(HttpRestRequest request) {
    // populate the response from the verb callback
    var _response = verb(request.verb);

    return _response;
  }
}
