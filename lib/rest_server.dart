library rest;

import 'dart:io' show HttpServer, HttpStatus;
import 'dart:async' show Future, getFuture;

part 'logger.dart';
part 'router.dart';
part 'rest.dart';
part 'http_rest.dart';

class RestServer {

  Router router;
  Logger logger;

  RestServer(
    Map routes,
    {
      String listen_address: '0.0.0.0',
      int listen_port: 8000
    }
  ){

    router = new Router(routes);
    logger = new Logger();

    HttpServer.bind(listen_address, listen_port).then((server) {
      server.listen((HttpRequest request) {

        logger.log('[REQUEST]: ${request.uri.path}');

        HttpRestResponse response = null;
        var route_action = router.resolve(request.uri.path);

        if(route_action == false) {
          request.response
            ..statusCode = HttpStatus.NOT_FOUND
            ..close();

          logger.log('[RESPONSE]: ${request.response.statusCode}');
          return;
        }

        response = route_action(request);

        request.response.statusCode = response.code;
        if( response.body != null) request.response.write(response.body);
        request.response.close();

        logger.log('[RESPONSE]: ${response.code}, ${response.body}');
      });
    });

    void log(String message) {
      logger.log(message);
    }
  }
}
