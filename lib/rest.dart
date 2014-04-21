part of rest;

// top level rest object
abstract class Rest {
  RestResponse resolve(HttpRequest request);
}

// represents an endpoint in a rest request hierarchy
abstract class RestRoute {

  Map<String,Verb> verbs;

  RestResponse verb(method) {
    if(!verbs.containsKey(method))
      throw new NoSuchVerbException(method);
    return verbs[method]();
  }

  RestResponse call(request);
}

// response data from a rest request
abstract class RestResponse {
  void build(dynamic response);
}

// represents a rest verb that provides data for a valid request
abstract class Verb {

  Function callback;

  Verb(callback) {
    this.callback = callback is Function ?
      callback : () { return callback; };
  };

  String call() {
    return this.callback();
  }
}

// called when attempting to map an undefined verb
class NoSuchVerbException implements Exception {
  NoSuchVerbException(verb) {
    print('No such verb: $verb');
  }
}
