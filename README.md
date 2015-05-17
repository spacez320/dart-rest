rest
====

A Dart library for creating REST applications.

Example
-------

```dart
      // import the library
      import 'rest:rest/http_rest.dart' show
        HttpRest, HttpRestResponse, HttpRestRoute;

      // make a function that will return some REST response
      getFooBar() {
        return new HttpRestResponse(204, 'found a fooBar!\n');
      }

      // create a map to define your API -- here we define a path that would
      // respond to something like;
      // GET /foo/bar/20 HTTP/1.1
      var routes = {
        r"^foo": {
          r"^bar$": {
            r"\d+": new HttpRestRoute({
              'GET': getFooBar
            }),
          }),
        }
      };

      // this will resolve your HTTP requests
      HttpRest rest = new HttpRest(routes);

      // build a server as normal, pass requests to the resolver
      HttpServer.bind('0.0.0.0', 8000),then((server) {
        server.listen((HttpRequest request)
          rest.resolve(request);
        });
      });
```

Documentation
-------------

See `doc/rest.md`.

API docs are generated and available on pub.dartlang.org.

[http://pub.dartlang.org/packages/rest](http://pub.dartlang.org/packages/rest)

Copyright/Licensing
-------------------

See LICENSE
