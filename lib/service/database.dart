import 'package:sembast_web/sembast_web.dart';

class DatabaseService {
  static Database? _db;
  static final _sessionsStore = intMapStoreFactory.store('sessions');
  static final _messagesStore = intMapStoreFactory.store('messages');

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final factory = databaseFactoryWeb;
    final dbPath = 'ai_companion.db';
    return _db = await factory.openDatabase(dbPath);
  }

  static Future<int> createSession(String? name) async {
    final dbClient = await db;
    name = (name == null || name.isEmpty) ? '@New Conversation' : name;

    final finder = Finder(filter: Filter.equals('name', name));
    final existing = await _sessionsStore.findFirst(dbClient, finder: finder);

    if (name == '@New Conversation' && existing != null) {
      final sessionId = existing.key;
      final messageCount = await _messagesStore.count(
        dbClient,
        filter: Filter.equals('session_id', sessionId),
      );
      if (messageCount == 0) return sessionId;
    }

    return await _sessionsStore.add(dbClient, {
      'name': name,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> renameSession(int sessionId, String newName) async {
    final dbClient = await db;
    await _sessionsStore.record(sessionId).update(dbClient, {'name': newName});
  }

  static Future<void> deleteSession(int sessionId) async {
    final dbClient = await db;

    await _sessionsStore.record(sessionId).delete(dbClient);
    final finder = Finder(filter: Filter.equals('session_id', sessionId));
    await _messagesStore.delete(dbClient, finder: finder);
  }

  static Future<Map<String, dynamic>> getSession(int sessionId) async {
    final dbClient = await db;
    final record = await _sessionsStore.record(sessionId).get(dbClient);
    if (record == null) {
      throw Exception('Session not found');
    }
    return {'id': sessionId, ...record};
  }

  static Future<List<Map<String, dynamic>>> getSessions() async {
    final dbClient = await db;
    final records = await _sessionsStore.find(
      dbClient,
      finder: Finder(sortOrders: [SortOrder('created_at', false)]),
    );
    return records.map((e) => {'id': e.key, ...e.value}).toList();
  }

  static Future<void> saveMessage(
      int sessionId,
      String text,
      bool isUser,
      ) async {
    final dbClient = await db;
    await _messagesStore.add(dbClient, {
      'session_id': sessionId,
      'text': text,
      'is_user': isUser ? 1 : 0,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Map<String, dynamic>>> getMessagesForSession(
      int sessionId,
      ) async {
    final dbClient = await db;
    final finder = Finder(
      filter: Filter.equals('session_id', sessionId),
      sortOrders: [SortOrder('timestamp')],
    );
    final records = await _messagesStore.find(dbClient, finder: finder);
    return records.map((e) => {'id': e.key, ...e.value}).toList();
  }
}
