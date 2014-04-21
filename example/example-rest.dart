library http_rest_example;

import 'dart:io' show
  HttpServer, HttpRequest;

import "../lib/http_rest.dart" show
  HttpRest, HttpRestRoute, HttpRestResponse, RouteNotFoundException;

void main() {

  var routes = {
    r"^foo": {
      r"^bar$": new HttpRestRoute({
        'GET': fooBar
      }),
      r"^bat$": new HttpRestRoute({
        'POST': fooBat,
        'GET': HttpRest.NO_CONTENT
      })
    }
  };

  HttpRest rest = new HttpRest(routes);

  HttpServer.bind('127.0.0.1', 8000).then((server) {
    server.listen((HttpRequest request) {
      try {

        // rest will write and close the response to the request if it finds
        // a successful endpoint from routes
        rest.resolve(request);

      } on RouteNotFoundException {

        // the rest route didn't endpoint, so do whatever you like
        // throw a 404, provide other server functionality, whatevs
        // but always remember to
        request.response.close();

      }
    });
  });
}

fooBar() {
  // this is just a test function
  return new HttpRestResponse().build(200, "called fooBar!\n");
}

fooBat() {
  // another test function endpoint
  return new HttpRestResponse().build(201, "called fooBat!\n");
}
