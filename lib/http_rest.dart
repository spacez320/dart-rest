library http_rest;

import 'dart:io' show HttpStatus, HttpRequest;
import 'rest.dart' show
  Rest, RestRoute, RestResponse, Verb, NoSuchVerbException;

part 'src/router.dart';

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
    new HttpRestResponse().build(HttpStatus.OK);

  /**
   *  Returns HTTP 201 Created
   */
  static HttpRestResponse CREATED() =>
    new HttpRestResponse().build(HttpStatus.CREATED);

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

    /// the response object to be returned
    var _live_response = null;
    /// the actual response object retrieved
    var _response = null;

    /// default response data
    var _response_data = {
      'code'    : 200,
      'body'    : null,
      'headers' : null,
    };

    // resolve the action
    var _route_action = this.rest_router.resolve(request.uri.path);

    // perform the action and generate the response
    if(_route_action is HttpRestRoute) {
      _response = _route_action(request);
    } else {
      _response = _route_action();
    }

    if(_response is HttpRestResponse) {
      // looks like the response is already prepared
      _live_response = _response;
    } else {
      // response is some other type of value
      if(_response is Map) {
        _response_data.addAll(_response);
      } else {
        _response_data['body'] = _response.toString();
      }

      _live_response = new HttpRestResponse().build(
        _response_data['code'],
        _response_data['body'],
        _response_data['headers']
      );
    }

    // populate the request response object with data
    request.response
      ..statusCode = _live_response.code
      ..write(_live_response.body != null ? _live_response.body : '')
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
   *  Constructs an HTTP REST route from a given endpoint.
   */
  HttpRestRoute.fromEndpoint(Function endpoint) : this({ 'GET': endpoint });

  /**
   * Provides a response, given an HTTP REST request.
   */
  HttpRestResponse call(request) {

    var _response = null;

    // attempt to execute the verb, given the request method
    try {

      // populate the response from the verb callback
      _response = verb(request.method);

    } on NoSuchVerbException {

      // respond to an unimplemented verb
      _response = HttpRest.METHOD_NOT_ALLOWED();

    }

    return _response;
  }
}

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

/**
 * An HTTP REST verb handler for a request route.
 */
typedef Verb HttpVerb();
