library http_rest;

import 'dart:io' show HttpStatus, HttpRequest, HttpHeaders;
import 'rest.dart' show
  Rest, RestRoute, RestRequest, RestResponse, Verb,
  NoSuchVerbException, VerbNotImplementedException;

part 'src/router.dart';
part 'http_rest_route.dart';
part 'http_rest_request.dart';
part 'http_rest_response.dart';


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
    new HttpRestResponse(HttpStatus.OK);

  /**
   *  Returns HTTP 201 Created
   */
  static HttpRestResponse CREATED() =>
    new HttpRestResponse(HttpStatus.CREATED);

  /**
   *  Returns HTTP 204 No Content
   */
  static HttpRestResponse NO_CONTENT() =>
    new HttpRestResponse(HttpStatus.NO_CONTENT);

  /* 400's */

  /**
   *  Returns HTTP 400 Bad Request
   */
  static HttpRestResponse BAD_REQUEST() =>
    new HttpRestResponse(HttpStatus.BAD_REQUEST);

  /**
   *  Returns HTTP 401 Unauthorized
   */
  static HttpRestResponse UNAUTHORIZED() =>
    new HttpRestResponse(HttpStatus.UNAUTHORIZED);

  /**
   *  Returns HTTP 405 Method Not Allowed
   */
  static HttpRestResponse METHOD_NOT_ALLOWED() =>
    new HttpRestResponse(HttpStatus.METHOD_NOT_ALLOWED);

  /**
   *  Returns HTTP 404 Not Found
   */
  static HttpRestResponse NOT_FOUND() =>
    new HttpRestResponse(HttpStatus.NOT_FOUND);

  /* 500's */

  /**
   *  Returns HTTP 501 Not Implemented
   */
  static HttpRestResponse NOT_IMPLEMENTED() =>
    new HttpRestResponse(HttpStatus.NOT_IMPLEMENTED);

  /**
   *  Constructs an HttpRest object from provided routes.
   */
  HttpRest(routes) {
    this.rest_router = new Router(routes);
  }

  /**
   *  Resolves an HTTP REST request from a client.
   */
  HttpRestResponse resolve(HttpRequest request) {
    /// the actual response object retrieved from the endpoint
    var _endpoint_response = null;
    /// the response object to build the actual response
    var _live_response = null;

    try {
      // resolve the endpoint
      Function _endpoint = this.rest_router.resolve(request.uri.path);

      // perform the endpoint and generate the response
      _endpoint_response = this.act(_endpoint, request);

      // interpret and generate the endpoint response
      _live_response = new HttpRestResponse.build(_endpoint_response);

    } on RouteNotFoundException {
      // we could not find a route based on the request
      _live_response = HttpRest.NOT_FOUND();
    } on NoSuchVerbException {
      // the request tried to use an unknown method
      _live_response = HttpRest.BAD_REQUEST();
    } on VerbNotImplementedException {
      // the request tried to use a known but undefined method
      _live_response = HttpRest.METHOD_NOT_ALLOWED();
    }

    // populate the request response object with data

    _live_response.headers.forEach((k, v) {
      request.response.headers.add(k, v);
    });

    request.response
      ..statusCode = _live_response.code
      ..write(_live_response.body != null ? _live_response.body : '')
      ..close();
  }

  /**
   * Wraps endpoint calls.
   */
  dynamic act(Function endpoint, HttpRequest request) {
    /// response retrieved from the endpoint
    var _response = null;

    // build a request object
    final HttpRestRequest _request =
      new HttpRestRequest.fromHttpRequest(request);

    // attempt to give the request to the endpoint and differentiate between a
    // NoSuchMethodError thrown by passing the request, and one that may come
    // from the endpoint itself
    try {
      _response = endpoint(_request);
    } on NoSuchMethodError {
      try {
        _response = endpoint();
      } on NoSuchMethodError {
        // the endpoint is throwing NoSuchMethodError, let it go
        _response = endpoint(_request);
      }
    }

    return _response;
  }
}


/**
 * An HTTP REST verb handler for a request route.
 */
typedef Verb HttpVerb();
