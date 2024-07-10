import "package:hive/hive.dart";
part "preferences.g.dart";

@HiveType(typeId: 0)
class UserPreferences {

  UserPreferences({required this.firstTime, this.darkTheme});
  @HiveField(0)
  bool firstTime;

  @HiveField(1)
  bool? darkTheme;
}
