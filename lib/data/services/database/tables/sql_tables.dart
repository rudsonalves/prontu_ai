class SqlTables {
  SqlTables._();

  static const users = '''
  CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    sex TEXT NOT NULL
  )
  ''';

  static const sessions = '''
  CREATE TABLE IF NOT EXISTS sessions (
    id TEXT PRIMARY KEY,
    episode_id TEXT NOT NULL,
    doctor TEXT NOT NULL,
    phone TEXT NOT NULL,
    notes TEXT NOT NULL,
    created_at TEXT NOT NULL
  )
  ''';

  static const episodes = '''
  CREATE TABLE IF NOT EXISTS episodes (
    id TEXT PRIMARY KEY,
    user_id TEXT NOT NULL,
    title TEXT NOT NULL,
    weight INTEGER NOT NULL,
    height INTEGER NOT NULL,
    main_complaint TEXT NOT NULL,
    history TEXT NOT NULL,
    anamnesis TEXT NOT NULL,
    created_at TEXT NOT NULL,
    updated_at TEXT NOT NULL
  )
  ''';

  static const attachments = '''
  CREATE TABLE IF NOT EXISTS attachments (
    id TEXT PRIMARY KEY,
    session_id TEXT NOT NULL,
    path TEXT NOT NULL,
    type TEXT NOT NULL,
    created_at TEXT NOT NULL
  )
  ''';

  static const aiSummaries = '''
  CREATE TABLE IF NOT EXISTS ai_summaries (
    id TEXT PRIMARY KEY,
    episode_id TEXT NOT NULL,
    summary TEXT NOT NULL,
    created_at TEXT NOT NULL
  )
  ''';
}

class TableSessions {
  TableSessions._();

  static const id = 'id';
  static const episodeId = 'episode_id';
  static const doctor = 'doctor';
  static const phone = 'phone';
  static const notes = 'notes';
  static const createdAt = 'created_at';
}

class TableEpisodes {
  TableEpisodes._();

  static const id = 'id';
  static const userId = 'user_id';
  static const title = 'title';
  static const weight = 'weight';
  static const height = 'height';
  static const mainComplaint = 'main_complaint';
  static const history = 'history';
  static const anamnesis = 'anamnesis';
  static const createdAt = 'created_at';
  static const updatedAt = 'updated_at';
}

class TableAttachments {
  TableAttachments._();

  static const id = 'id';
  static const sessionId = 'session_id';
  static const path = 'path';
  static const type = 'type';
  static const createdAt = 'created_at';
}

class TableAiSummaries {
  TableAiSummaries._();

  static const id = 'id';
  static const episodeId = 'episode_id';
  static const summary = 'summary';
  static const createdAt = 'created_at';
}

class TableUsers {
  TableUsers._();

  static const id = 'id';
  static const name = 'name';
  static const birthDate = 'birth_date';
  static const sex = 'sex';
}
