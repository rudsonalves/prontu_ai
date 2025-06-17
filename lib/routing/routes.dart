class Route {
  final String name;
  final String path;

  const Route(this.name, this.path);
}

abstract final class Routes {
  static const home = Route('home', '/');
}
