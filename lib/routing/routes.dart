class Route {
  final String name;
  final String path;

  const Route(this.name, this.path);
}

abstract final class Routes {
  static const splash = Route('splash', '/splash');

  static const home = Route('home', '/');
  static const formUser = Route('form_user', '/form_user');

  static const episode = Route('episode', '/episode');
  static const formEpisode = Route('form_episode', '/form_episode');

  static const attachment = Route('attachment', '/attachment');
  static const formAttachment = Route('form_attachment', '/form_attachment');

  static const session = Route('session', '/session');
  static const formSession = Route('form_session', '/form_session');

  static const aiSummary = Route('ai_summary', '/ai_summary');
  // static const formAiSummary = Route('form_ai_summary', '/form_ai_summary');
}
