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

Generally, this involves three steps.

- Firstly; building the routes.

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

- Secondly; creating the server and adding the resolve action.

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

- Thirdly; defining your end-point functions.

```dart
      fooBar() {
        return new HttpResponse().build(200, 'fooBar!\n");
      }

      fooBat() {
        return new HttpResponse().build(502, 'fooBat!\n");
      }
```

See `example/example-rest.dart` for a more in-depth, working example.

Extending REST
--------------

Extensible classes exist to create your own REST interfaces, HTTP based or
otherwise. Doing so is a matter of defining what verbs you want to use.

```dart
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
