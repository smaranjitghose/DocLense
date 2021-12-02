import 'package:hive/hive.dart';
part 'preferences.g.dart';

@HiveType(typeId: 0)
class UserPreferences {
  @HiveField(0)
  bool firstTime;

  @HiveField(1)
  bool? darkTheme;

  UserPreferences({required this.firstTime, this.darkTheme});
}
