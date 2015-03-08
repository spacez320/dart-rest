part of http_rest;


/**
 * An HTTP REST route using available HTTP methods.
 */
class HttpRestRoute extends RestRoute {
  /// map of HTTP verbs and verb handlers
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

  /// qualified verbs for this route
  Map<String,Verb> verbs = {};

  /**
   * Constructs an HTTP REST route given a verb function map and optional
   * routes.
   */
  HttpRestRoute(this.verbs, [routes]);

  /**
   *  Constructs an HTTP REST route from a given endpoint.
   */
  HttpRestRoute.fromEndpoint(Function endpoint) : this({ 'GET': endpoint });

  /**
   * Provides a response, given an HTTP REST request.
   */
  HttpRestResponse call(HttpRestRequest request) {
    // populate the response from the verb callback
    var _response = verb(request.verb);

    return _response;
  }
}
