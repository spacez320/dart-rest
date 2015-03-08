library http_rest_example;

import 'dart:io' show
  HttpServer, HttpRequest;

import "../lib/http_rest.dart" show
  HttpRest, HttpRestRoute, HttpRestResponse, RouteNotFoundException;


void main() {

  var address = '127.0.0.1';
  var port = 8000;

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

  print("Generating REST routes...");
  HttpRest rest = new HttpRest(routes);

  HttpServer.bind(address, port).then((server) {
    print("Starting the REST server on ${address}:${port}.");
    server.listen((HttpRequest request) {
      print("I got a ${request.method} request for ${request.uri.path}!");

      // rest will write and close the response to the request if it finds
      // a successful endpoint from routes
      rest.resolve(request);

      print("I got a response of ${request.response.statusCode}.");
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
