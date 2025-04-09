import 'package:objectbox/objectbox.dart';

@Entity()
class CacheRecord {
  @Id()
  int id;

  @Unique(onConflict: ConflictStrategy.replace)
  final String url;
  final DateTime date;

  CacheRecord({this.id = 0, required this.url, required this.date});
}
