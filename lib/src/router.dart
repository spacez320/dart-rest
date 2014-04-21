part of rest;

class Router {

  // a routing map
  Map routes = {};

  // constructor, accepts an uncompiled routing map
  Router(routes) {
    this.routes = this.compile(routes);
  }

  // compiles a routing map
  Map compile(route_map) {

    var compiled_routes = {};

    var next_route_regexp = null;
    var next_route_val = null;

    for(var route in route_map.keys) {
      next_route_regexp = new RegExp(route);
      next_route_val = route_map[route] is Map ?
        compile(route_map[route]) :
        route_map[route];

      compiled_routes[next_route_regexp] =
        next_route_val;
    }

    return compiled_routes;
  }

  // resolves a request_uri against a route map
  Function resolve(request_uri) {

    dynamic resolveRoutes(routes, request_uri) {

      request_uri = request_uri.replaceFirst(new RegExp(r'/'), '');
      for(var route in routes.keys) {
        if(route.hasMatch(request_uri)) {
          if(routes[route] is Function) {
            return routes[route];
          } else {
            return resolveRoutes(routes[route],
                request_uri.substring(route.firstMatch(request_uri).end));
          }
        }
      }

      return false;
    }

    var route_action = resolveRoutes(this.routes, request_uri);
    if(route_action is Function) {
      return route_action;
    } else throw new RouteNotFoundException(request_uri);
  }

  // main routing function, returns response data
  Map<String,dynamic> route(request) {

    var action = resolve(request.uri.path);
    var output = action();

    return output;
  }
}

class RouteNotFoundException implements Exception {
  RouteNotFoundException(route) {
    print('Could not find route: $route');
  }
}
