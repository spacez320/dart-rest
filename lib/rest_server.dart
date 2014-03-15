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

        int returnCode;
        String returnBody;
        HttpRestResponse response;
        Function route_action;

        logger.log('[REQUEST]: ${request.uri.path}');

        try {
          route_action = router.resolve(request.uri.path);
          response = route_action(request);
          returnCode = response.code;
          returnBody = response.body;
        } on RouteNotFoundException {
          returnCode = HttpStatus.NOT_FOUND;
        } finally {
          logger.log('[RESPONSE]: $returnCode, $returnBody');

          request.response.statusCode = returnCode;
          if( returnBody != null) request.response.write(returnBody);
          request.response.close();
        }
      });
    });

    void log(String message) {
      logger.log(message);
    }
  }
}
