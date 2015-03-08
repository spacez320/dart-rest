part of rest;

/**
 * A route manager for resolving URIs to functional endpoints.
 */
class Router {
  /// routing map
  Map _routes = {};

  /**
   *  Constructs a route handler from a routing map.
   *
   *  @param    Map     routes  A routing map.
   *  @returns  Router  A router object which can route requests using the
   *                    provided map.
   */
  Router(routes) {
    this._routes = this.compile(routes);
  }

  /**
   *  Compiles a given routing map.
   *
   *  Takes as input a tree structure whose internal nodes are String objects
   *  and leaf nodes are endpoints. Returns a modified tree whose internal
   *  nodes are compiled into RegExp objects.
   *
   *  This normally should only be used by the Router constructor to create a
   *  Router object used for resolving URI requests.
   *
   *      // an example routing map
   *      pre_processed_routes = {
   *        r'foo': {
   *          r'bar': () => return "called foo/bar!"
   *          r'biz': () => return "called foo/biz!"
   *        },
   *        r'fiz': {
   *          r'\d+': () => return "called fix/\d+!"
   *        }
   *      }
   *
   *      // create a new Router object
   *      router = new Router(pre_processed_routes);
   *
   *      // resolve URI requests
   *      print(router.resolve('foo/bar'));
   *      print(router.resolve('fiz/20'));
   *
   *  @param    Map   route_map    A routing map.
   *  @returns  Map   A compiled routing map.
   */
  Map compile(route_map) {
    // resultant compiled route object
    var _compiled_routes = {};

    // loop over given routes in map and compile them
    var _next_route_regexp = null;
    var _next_route_val = null;
    for(var route in route_map.keys) {
      _next_route_regexp = route == null ? null : new RegExp(route);

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
   *  Resolve a given URI path from the current route map.
   *
   *  Takes as input a URI path and provides the endpoint generated by
   *  traversing the compiled routing map.
   *
   *  Endpoints must be Functions. If no endpoint is reached, an exception is
   *  thrown.
   *
   *  @param    String    request_uri  A request URI path.
   *  @returns  Function  An associated endpoint.
   *  @throws   RouteNotFoundException
   */
  Function resolve(request_uri) {
    /**
     *  Depth-first search.
     */
    dynamic resolveRoutes(routes, request_uri) {
      // remove the leading slash
      var _request_uri = request_uri.replaceFirst(new RegExp(r'/'), '');
      var _modified_request = '';

      for(var route in routes.keys) {
        // find a match in the given routes
        if(route != null && route.hasMatch(_request_uri)) {
          // process request substring
          _modified_request =
            _request_uri.substring(route.firstMatch(_request_uri).end);

          if(routes[route] is Function) {
            // return the endpoint if the full URI portion is matched
            if(_modified_request.isEmpty) return routes[route];
          } else {
            // continue searching
            return resolveRoutes(routes[route], _modified_request);
          }
        } else if(route == null && _request_uri.isEmpty) {
          return routes[null];
        }
      }

      // false if no endpoint was ever returned
      return false;
    }

    // resolve the route
    var _route_action = resolveRoutes(this._routes, request_uri);

    // determine if the endpoint is actionable
    if(_route_action is Function) {
      return _route_action;
    } else throw new RouteNotFoundException(request_uri);
  }
}

/**
 *  Thrown when a requested route is not found within a routing map.
 */
class RouteNotFoundException implements Exception {
  final String msg;
  const RouteNotFoundException([this.msg]);
  String toString() => "Could not find route: ${route}";
}
