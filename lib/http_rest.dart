part of rest;


/**
 * An HTTP REST server.
 */
class HttpRest implements Rest {

  /// the routing engine
  Router rest_router;

  /* 200's */

  /**
   *  Returns HTTP 200 OK
   */
  static HttpRestResponse OK() =>
    new HttpRestREsponse().build(HttpStatus.OK);

  /**
   *  Returns HTTP 201 Created
   */
  static HttpRestResponse CREATED() =>
    new HttpRestREsponse().build(HttpStatus.CREATED);

  /**
   *  Returns HTTP 204 No Content
   */
  static HttpRestResponse NO_CONTENT() =>
    new HttpRestResponse().build(HttpStatus.NO_CONTENT);

  /* 400's */

  /**
   *  Returns HTTP 401 Unauthorized
   */
  static HttpRestResponse UNAUTHORIZED() =>
    new HttpRestResponse().build(HttpStatus.UNAUTHORIZED);

  /**
   *  Returns HTTP 405 Method Not Allowed
   */
  static HttpRestResponse METHOD_NOT_ALLOWED() =>
    new HttpRestResponse().build(HttpStatus.METHOD_NOT_ALLOWED);

  /**
   *  Returns HTTP 404 Not Found
   */
  static HttpRestResponse NOT_FOUND() =>
    new HttpRestResponse().build(HttpStatus.NOT_FOUND);

  /* 500's */

  /**
   *  Returns HTTP 501 Not Implemented
   */
  static HttpRestResponse NOT_IMPLEMENTED() =>
    new HttpRestResponse().build(HttpStatus.NOT_IMPLEMENTED);

  /**
   *  Constructs an HttpRest object from provided routes.
   */
  HttpRest(routes) {
    this.rest_router = new Router(routes);
  }

  /**
   *  Resolves an HTTP Rest Request.
   */
  HttpRestResponse resolve(HttpRequest request) {

    // resolve the action
    var route_action = this.rest_router.resolve(request.uri.path);

    // perform the action and generate the response
    var response_data = route_action(request);

    // populate the request response object with data
    request.response
      ..statusCode = response_data.code
      ..write(response_data.body != null ? response_data.body : '')
      ..close();
  }
}

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
   * Constructs an HTTP REST route given a verb function map.
   */
  HttpRestRoute(this.verbs);

  /**
   * Provides a response, given an HTTP REST request.
   */
  HttpRestResponse call(request) {

    var response = null;

    // attempt to execute the verb, given the request method
    try {

      // populate the response from the verb callback
      response = verb(request.method);
    } on NoSuchVerbException {

      // respond to an unimplemented verb
      response = HttpRest.METHOD_NOT_ALLOWED();
    }

    return response;
  }
}

/**
 * A response to an HTTP REST request.
 */
class HttpRestResponse implements RestResponse {

  /// HTTP response code
  final int code;
  /// HTTP response body (should be optional)
  final String body;
  /// additional HTTP headers (should be optional)
  final Map headers;

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

/**
 * An HTTP REST verb handler for a request route.
 */
typedef Verb HttpVerb();
