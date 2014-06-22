library rest;

import 'dart:io' show HttpStatus, HttpRequest;
import 'dart:async' show Future, getFuture;

part 'src/router.dart';
part 'rest.dart';

// http rest server
class HttpRest implements Rest {

  Router rest_router;

  /* response constants */

  // 200's

  static HttpRestResponse OK() =>
    new HttpRestREsponse().build(HttpStatus.OK);

  static HttpRestResponse CREATED() =>
    new HttpRestREsponse().build(HttpStatus.CREATED);

  static HttpRestResponse NO_CONTENT() =>
    new HttpRestResponse().build(HttpStatus.NO_CONTENT);

  // 400's

  static HttpRestResponse UNAUTHORIZED() =>
    new HttpRestResponse().build(HttpStatus.UNAUTHORIZED);

  static HttpRestResponse METHOD_NOT_ALLOWED() =>
    new HttpRestResponse().build(HttpStatus.METHOD_NOT_ALLOWED);

  static HttpRestResponse NOT_FOUND() =>
    new HttpRestResponse().build(HttpStatus.NOT_FOUND);

  // 500's

  static HttpRestResponse NOT_IMPLEMENTED() =>
    new HttpRestResponse().build(HttpStatus.NOT_IMPLEMENTED);

  /* constructors */

  HttpRest(routes) {
    this.rest_router = new Router(routes);
  }

  /* methods */

  HttpRestResponse resolve(HttpRequest request) {

    Function route_action;
    HttpRestResponse response_data;

    route_action = this.rest_router.resolve(request.uri.path);
    response_data = route_action(request);

    request.response
      ..statusCode = response_data.code
      ..write(response_data.body != null ? response_data.body : '')
      ..close();
  }
}

// http rest verb definitions and responses
class HttpRestRoute extends RestRoute {

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

  HttpRestRoute(this.verbs);

  HttpRestResponse call(request) {
    HttpRestResponse response = null;

    try {
      response = verb(request.method);
    } on NoSuchVerbException {
      response = HttpRest.METHOD_NOT_ALLOWED();
    }

    return response;
  }
}

// http rest response
class HttpRestResponse implements RestResponse {
  int code;
  String body;
  Map headers;

  HttpRestResponse build(int code, [String body, Map headers]) {
    this.code = code;
    if(body != null) this.body = body;
    if(headers != null) this.headers = headers;

    return this;
  }
}

// http verb
class HttpVerb implements Verb {

  Function callback;

  String call() => this.callback();
}

