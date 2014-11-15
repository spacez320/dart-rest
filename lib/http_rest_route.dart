part of http_rest;


/**
 * An HTTP REST route using available HTTP methods.
 */
class HttpRestRoute extends RestRoute {

  /// map of HTTP verbs and verb handlers
  Map<String,Verb> verbs = {
    'OPTIONS':  null,
    'GET':      null,
    'HEAD':     null,
    'POST':     null,
    'PUT':      null,
    'DELETE':   null,
    'TRACE':    null,
    'CONNECT':  null
  };

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

    var _response = null;

    // attempt to execute the verb, given the request method
    try {

      // populate the response from the verb callback
      _response = verb(request.verb);

    } on NoSuchVerbException {

      // respond to an unimplemented verb
      _response = HttpRest.METHOD_NOT_ALLOWED();

    }

    return _response;
  }
}
