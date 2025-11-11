import 'package:mongo_dart/mongo_dart.dart';

late final Db _db;

Db get database => _db;

Future<void> initDb() async {
  const String mongoUri =
      'mongodb+srv://felipeduarteabc:3wPu9Wmv2KfptcM@cluster0.cthfqpb.mongodb.net/?appName=Cluster0';

  _db = await Db.create(mongoUri);
  await _db.open();
  print('✅ Conectado ao MongoDB');
}
