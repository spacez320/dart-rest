library http_rest;

import 'dart:io' show HttpStatus, HttpRequest;
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
   *  Returns HTTP 400 Bad Request
   */
  static HttpRestResponse BAD_REQUEST() =>
    new HttpRestResponse().build(HttpStatus.BAD_REQUEST);

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
    /// the actual response object retrieved
    var _response = null;
    /// the response object to be returned
    var _live_response = null;
    /// default response data
    var _response_data = {
      'code'    : 200,
      'body'    : null,
      'headers' : null,
    };

    // resolve the action
    try {
      var _route_action = this.rest_router.resolve(request.uri.path);

      // perform the action and generate the response
      _response = this.act(_route_action, request);

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
    }on RouteNotFoundException {
      _live_response = HttpRest.NOT_FOUND();
    } on NoSuchVerbException {
      _live_response = HttpRest.BAD_REQUEST();
    } on VerbNotImplementedException {
      _live_response = HttpRest.METHOD_NOT_ALLOWED();
    }

    // add headers to the request response
    _live_response.headers.forEach((k, v) {
      request.response.headers.add(k, v);
    });

    // populate the request response object with data
    request.response
      ..statusCode = _live_response.code
      ..write(_live_response.body != null ? _live_response.body : '')
      ..close();
  }

  /**
   * Wraps route_action calls.
   */
  dynamic act(Function route_action, HttpRequest request) {
    var _response = null;

    // build a request object
    final _request = new HttpRestRequest.fromRequest(request);

    // attempt to give the request to the endpoint and differentiate between a
    // NoSuchMethodError thrown by passing the request, and one that may come
    // from the endpoint itself
    try {
      _response = route_action(_request);
    } on NoSuchMethodError {
      try {
        _response = route_action();
      } on NoSuchMethodError {
        // the endpoint is throwing NoSuchMethodError, let it go
        _response = route_action(_request);
      }
    }

    return _response;
  }
}


/**
 * An HTTP REST verb handler for a request route.
 */
typedef Verb HttpVerb();
