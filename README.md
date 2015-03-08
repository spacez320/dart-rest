rest
====

A Dart library for creating REST applications.

Example
-------

```dart
      import 'rest:rest/http_rest.dart' show HttpRest, HttpRestRoute;

      var routes = {
        r"^foo": {
          r"^bar$": {
            r"\d+": new HttpRestRoute({
              'GET': getFooBar
            }),
          }),
        }
      };

      HttpRest rest = new HttpRest(routes);

      HttpServer.bind('0.0.0.0', 8000),then((server) {
        server.listen((HttpRequest request)
          rest.resolve(request);
        });
      });

      getFooBar() {
        return new HttpRestResponse().build(204, 'found a fooBar!\n');
      }
```

Documentation
-------------

See `doc/rest.md`.

API docs are generated and available on pub.dartlang.org.

[http://pub.dartlang.org/packages/rest](http://pub.dartlang.org/packages/rest)

Copyright/Licensing
-------------------

See LICENSE
