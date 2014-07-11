rest
====

This Dart library provides two things:

- an HTTP REST server implementation
- extensible, generic REST implementation for building REST-ful applications

Installing
----------

Add "rest" as a dependency in your **pubspec.yaml** file, and run `pub
install`.

More information: https://www.dartlang.org/tools/pub/get-started.html#installing-packages

Usage
-----

Within `dart:io HttpServer`, instantiate and resolve REST-ful requests by
creating an `HttpRest` handler. The `HttpRest` handler itself is instantiated
by a route map that you generate and provide, with endpoints that you generate
and provide.

Generally, this involves four steps.

- Firstly; importing the library.

```dart
        import 'rest:rest/http_rest.dart' show
          HttpRest, HttpRestRoute, HttpRestResponse, RouteNotFoundException;
```

- Secondly; building the routes.

```dart
      // keys are regular expressions

      var routes = {
        r"^foo": {
          r"^bar$": new HttpRestRoute({
            'GET': fooBar   // a function called fooBar
          }),
          r"^bat$": new HttpRestRoute({
            'POST': fooBat  // a function called fooBat
          })
        }
      }

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

            // rest.resolve through an exception because it couldn't find
            // and endpoint with the url

            request.response.close();

          }
        });
      });
```

- Fourthly; defining your end-point functions.

```dart
      fooBar() {
        return new HttpRestResponse().build(200, 'fooBar!\n');
      }

      fooBat() {
        return new HttpRestResponse().build(502, 'fooBat!\n');
      }
```

See `example/example-rest.dart` for a more in-depth, working example.

### On Endpoint Functions

Notice that the examples above are building `HttpRestResponse` objects.
Your endpoint functions can;

-   also do this,

```dart
        myEndpoint() { return new HttpRestResponse().build(
          200, "stuff and things\n"); }
```

-   return a `Map` with associated fields that will automatically build an
    `HttpRestResponse` object for you,

```dart
        myEndPoint() { return { 'code': 200, 'body': "stuff and things\n" }; }
```

-   or return anything else, in which case the return object's `.toString()`
    method is used to generate the body and the response code is set to `200`

```dart
        myEndPoint() { return "stuff and things\n"; }
```


Extending REST
--------------

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

Documentation
-------------

API docs are generated and available on pub.dartlang.org.

http://pub.dartlang.org/packages/rest

Copyright/Licensing
-------------------

See LICENSE
