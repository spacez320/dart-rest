library rest_test;

import 'package:rest/rest.dart' as rest;
import 'package:rest/http_rest.dart';
import 'package:unittest/unittest.dart';
import 'src/rest_test_util.dart';

void main() {

    group('Router test', () {
      var test_routes = {};
      var test_router = null;

      setUp(() {
        test_routes = {
          r'^foo': RestTestUtil.returnTrue,
          r'^bar': RestTestUtil.returnFalse,
        };
        test_router = new Router(test_routes);
      });
      tearDown(() {

      });

      test('constructor produces instance', () {
        expect(test_router, new isInstanceOf<Router>('Router'));
      });
    });

}
