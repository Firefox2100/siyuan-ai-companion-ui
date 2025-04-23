import 'package:web/web.dart' as web;

final ORIGIN = web.window.location.origin;
final HOST = web.window.location.hostname;
final PORT = int.tryParse(web.window.location.port);
final PROTOCOL = web.window.location.protocol.replaceAll(':', '');
