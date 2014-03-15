part of rest;

class HttpRest extends Rest {

  Map<String,Verb> verbs = {
    'OPTIONS': null,
    'GET': null,
    'HEAD': null,
    'POST': null,
    'PUT': null,
    'DELETE': null,
    'TRACE': null,
    'CONNECT': null
  };

  HttpRest(this.verbs);

  // 200's

  static HttpRestResponse NO_CONTENT() =>
    new HttpRestResponse().build(HttpStatus.NO_CONTENT);

  // 400's

  static HttpRestResponse METHOD_NOT_ALLOWED() =>
    new HttpRestResponse().build(HttpStatus.METHOD_NOT_ALLOWED);

  HttpRestResponse call(request) {
    HttpRestResponse response = null;

    try {
      response = verb(request.method);
    } on NoSuchVerbException {
      response = HttpRest.METHOD_NOT_ALLOWED();
    }

    return response;
  }
}

class HttpRestResponse implements RestResponse {
  int code;
  String body;
  Map headers;

  void build(int code, [String body, Map headers]) {
    this.code = code;
    if(body != null) this.body = body;
    if(headers != null) this.headers = headers;

    return this;
  }
}

class HttpVerb implements Verb {}
