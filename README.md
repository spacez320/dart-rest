rest
====

This Dart library provides two things:

- an HTTP REST server implementation
- extensible, generic REST implementation for building REST-ful applications

Most of this documentation describes how to use the HTTP REST server.

Installing
----------

Add "rest" as a dependency in your **pubspec.yaml** file, and run `pub
install`.

More information:
- https://pub.dartlang.org/packages/rest#installing
- https://www.dartlang.org/tools/pub/get-started.html#installing-packages

Usage
-----

Within `dart:io HttpServer`, instantiate and resolve REST-ful requests by
creating an `HttpRest` handler. The `HttpRest` handler itself is instantiated
by a route map that you generate and provide, with endpoints that you generate
and provide.

Generally, this involves four steps.

- Firstly; importing the library.

```dart
        import 'rest:rest/http_rest.dart' show HttpRest, HttpRestRoute;
```

- Secondly; building the routes.

```dart

      // keys are regular expressions, or null
      var routes = {
        r"^foo": {
          r"^bar$": {

            // the null key will allow a request for 'foo/bar'

            null: new HttpRestRoute({
              'GET': fooBar               // a function called fooBar
            }),

            // this will match PUT requests of form 'foo/bar/\d+'

            r"\d+": new HttpRestRoute({
              'PUT': createFooBar         // a function called createFooBar
            }),

          }),

          // this will match POST requests of form 'bat'

          r"^bat$": new HttpRestRoute({
            'POST': fooBat                // a function called fooBat
          })
        }
      }

      // create the rest object itself
      HttpRest rest = new HttpRest(routes);
```

- Thirdly; creating the server and adding the resolve action.

```dart
      HttpServer.bind('0.0.0.0', 8000),then((server) {
        server.listen((HttpRequest request)
          try {

            // HttpRest will write and close the response to the request
            // if it finds a useable endpoint

            rest.resolve(request);

          } on RouteNotFoundException {

            // an exception is thrown because it couldn't find an endpoint,
            // at which point you can decide what you want to do

            request.response
              ..status = 404
              ..close();

          }
        });
      });
```

- Fourthly; defining your end-point functions.

```dart
      fooBar() {
        return new HttpRestResponse().build(200, 'fooBar!\n');
      }

      createFooBar() {
        return new HttpRestResponse().build(204, 'created a fooBar!\n');
      }

      fooBat() {
        return new HttpRestResponse().build(502, 'fooBat!\n');
      }
```

See `example/example-rest.dart` for a more in-depth, working example.

### On Routing Maps

The routing map is a tree that represents a URI request. Below is my attempt
at EBNF:

    <RoutingMap> ::= Function
                   | HttpRestRoute
                   | { <Route>, <Route>* }

    <Route> ::= <RouteKey>: <RoutingMap>

    <RouteKey> ::= RegExp | null

Some key points:

- Route endpoints can be given Functions directly, in which case they respond
  to `GET` requests
- `HttpRestRoute` objects are required to provide different behaviors per
  HTTP method
- a Route with children can be matched by using a `null` key

### On Endpoint Functions

Notice that the examples above are building `HttpRestResponse` objects.
Your endpoint functions can;

- also do this,

```dart
        myEndpoint() {
          var my_response = "stuff and things\n";

          return new HttpRestResponse().build(200, my_response);
        }
```

- return a `Map` with associated fields that will automatically build an
  `HttpRestResponse` object for you,

```dart
        myEndPoint() {
          var my_response = "stuff and things\n";

          return {
            'code': 200,
            'body': my_response
          };
        }
```

- or return anything else, in which case the return object's `.toString()`
  method is used to generate the body and the response code is set to `200`

```dart
        myEndPoint() { return "stuff and things\n"; }
```


Extending
---------

Extensible classes exist to create your own REST interfaces, HTTP based or
otherwise. Doing so is a matter of defining what verbs you want to use.

```dart
    import "package:rest/rest.dart" show Rest, RestRoute;

    class YodaRest implements Rest {
      // ...
    }

    class YodaRestRoute extends RestRoute {

      Map<String,Verb> verbs = {
        'DO':     null,
        'DO_NOT': null,
        'TRY':    throw new Exception('There is no try!')
      }

      // ...
    }
```

And etcetera.

Development
-----------

This project is currently functional, but in need of heavy development.

https://github.com/spacez320/dart-rest

If you would like to see continued development on this library, have
suggestions, or would like to contribute; please feel free to file pull
requests or contact me directly (through Github).

Tests are in the `/test` folder.

```bash
    dart test/rest_test.dart
```

Documentation
-------------

API docs are generated and available on pub.dartlang.org.

http://pub.dartlang.org/packages/rest

Copyright/Licensing
-------------------

See LICENSE
