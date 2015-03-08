library rest;

import 'dart:async' show Future, getFuture;

part 'src/router.dart';


/**
 * A REST server.
 */
abstract class Rest {
  /**
   *  Resolves a REST request.
   */
  RestResponse resolve(request);
}

/**
 * A REST route using available methods.
 */
abstract class RestRoute {
  /// list of possible verbs
  List<String> implemented_verbs;
  /// map of verbs and verb handlers
  Map<String,Verb> verbs;

  /**
   * Gets a verb from current verbs given a method name.
   */
  RestResponse verb(method) {
    if(!verbs.containsKey(method)) {
      if(!implemented_verbs.contains(method))
        throw new NoSuchVerbException(method);
      else
        throw new VerbNotImplementedException(method);
    }
    return verbs[method]();
  }

  /**
   * Provides a response, given an REST request.
   */
  RestResponse call(request);
}

/**
 *  A REST request.
 */
abstract class RestRequest {
  final String path;
  final String verb;
}

/**
 * A response to a REST request.
 */
abstract class RestResponse {
  /**
   * Generates a REST response.
   */
  void build(dynamic response);
}

/**
 * A REST verb handler for a request route.
 */
abstract class Verb {
  /// Response handler for this verb.
  final Function callback;

  /// Constructor that produces the verb action.
  Verb(callback) {
    this.callback = callback is Function ?
      callback : () { return callback; };
  }

  /**
   * Calls the response handler.
   */
  String call() => this.callback();
}

/**
 * Exception when defining verb mappings for nonexistent methods.
 */
class NoSuchVerbException implements Exception {
  final String msg;
  const NoSuchVerbException ([this.msg]);
  String toString() => "No such method ${msg}";
}

/**
 * Exception when defining verb mappings for nonexistent methods.
 */
class VerbNotImplementedException implements Exception {
  final String msg;
  const VerbNotImplementedException ([this.msg]);
  String toString() => "No implemented method ${msg}";
}
