part of rest;

class Rest {

  Map<String,Verb> verbs;

  RestResponse verb(method) {
    if(!verbs.containsKey(method))
      throw new NoSuchVerbException(method);
    return verbs[method]();
  }

  RestResponse call(request);
}

abstract class RestResponse {
  void build();
}

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

class NoSuchVerbException implements Exception {
  NoSuchVerbException(verb) {
    print('No such verb: $verb');
  }
}
