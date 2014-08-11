part of rest;

/**
 * A route manager for resolving URLs to functional endpoints.
 */
class Router {

  /// routing map
  Map routes = {};

  /**
   * Constructs a route handler from a routing map.
   */
  Router(routes) {
    this.routes = this.compile(routes);
  }

  /**
   * Compiles a given routing map.
   */
  Map compile(route_map) {

    // resultant compiled route object
    var _compiled_routes = {};

    // loop over given routes in map and compile them
    var _next_route_regexp = null;
    var _next_route_val = null;
    for(var route in route_map.keys) {
      _next_route_regexp = new RegExp(route);

      // recurse if child is also a route map, or provide the value as
      // the route endpoint
      _next_route_val = route_map[route] is Map ?
        compile(route_map[route]) : route_map[route];

      // set the next compiled route
      _compiled_routes[_next_route_regexp] = _next_route_val;
    }

    return _compiled_routes;
  }

  /**
   * Given a request URI, resolve the REST endpoint from current routes.
   */
  Function resolve(request_uri) {

    /**
     * Depth-first search for resolve path.
     */
    dynamic resolveRoutes(routes, request_uri) {

      // remove the leading slash
      var _request_uri = request_uri.replaceFirst(new RegExp(r'/'), '');

      for(var route in routes.keys) {

        // find a match in the given routes
        if(route.hasMatch(_request_uri)) {

          // return discovered endpoints, else continue to search
          if(routes[route] is Function) {
            return routes[route];
          } else {
            return resolveRoutes(routes[route],
              _request_uri.substring(route.firstMatch(_request_uri).end));
          }
        }
      }

      // false if no endpoint was ever returned
      return false;
    }

    // resolve the route
    var _route_action = resolveRoutes(this.routes, request_uri);

    // determine if the endpoint is actionable
    if(_route_action is Function) {
      return _route_action;
    } else throw new RouteNotFoundException(request_uri);
  }

  /**
   * Route action that returns a response.
   */
  Map<String,dynamic> route(request) => resolve(request.uri.path)();
}

/**
 * Exception when no route is found.
 */
class RouteNotFoundException implements Exception {
  RouteNotFoundException(route) {
    print('Could not find route: $route');
  }
}
