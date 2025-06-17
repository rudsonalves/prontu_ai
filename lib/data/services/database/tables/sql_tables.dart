class SqlTables {
  SqlTables._();

  static const user = '''
  CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    birth_date TEXT NOT NULL,
    sex TEXT NOT NULL
  )
  ''';

  // static const
}
