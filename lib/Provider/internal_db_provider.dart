import 'package:flutter/cupertino.dart';
import 'package:game_trophy_manager/Model/game_guide_model.dart';
import 'package:game_trophy_manager/Model/game_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class InternalDbProvider extends ChangeNotifier {
  static Database _db;
  final String dbName = 'Games.db';
  final String myGamesTable = 'MyGames';
  final String myTrophyTable = 'MyTrophy';
  final String gameNameColumn = 'GameName';
  final String gameImgUrlColumn = 'GameImgUrl';
  final String trophyNameColumn = 'TrophyName';
  final String trophyImageUrlColumn = 'TrophyImgUrl';
  final String trophyTypeColumn = 'TrophyType';
  final String trophyDescriptionColumn = 'TrophyDescription';
  final String trophyGuideColumn = 'TrophyGuide';
  final String trophyActionColumn = 'TrophyAction'; //Starred or Completed
  final String dateTimeColumn = 'DateTime';
  final String goldColumn = 'GOLD';
  final String silverColumn = 'SILVER';
  final String bronzeColumn = 'BRONZE';

  List<GameModel> myGames = <GameModel>[];
  List<GuideModel> myCompletedTrophy = <GuideModel>[];
  List<GuideModel> myStarredTrophy = <GuideModel>[];

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $myGamesTable($gameNameColumn TEXT PRIMARY KEY UNIQUE, $gameImgUrlColumn TEXT,$dateTimeColumn DATETIME,$goldColumn TEXT, $silverColumn TEXT, $bronzeColumn TEXT)');
    await db.execute(
        'CREATE TABLE $myTrophyTable($gameNameColumn TEXT, $gameImgUrlColumn TEXT,$trophyNameColumn TEXT,$trophyImageUrlColumn TEXT,$trophyTypeColumn TEXT,$trophyDescriptionColumn TEXT,$trophyGuideColumn TEXT,$trophyActionColumn TEXT,$dateTimeColumn DATETIME)');
  }

  void addGameToDb(GameModel game, BuildContext context) async {
    try {
      String gameName = game.gameName;
      String gameImgUrl = game.gameImageUrl;
      DateTime now = DateTime.tryParse(DateTime.now().toString());
      String gold = game.gold;
      String silver = game.silver;
      String bronze = game.bronze;
      var dbClient = await db; //This calls the getter function
      var result = await dbClient.rawInsert(
          'INSERT INTO $myGamesTable($gameNameColumn, $gameImgUrlColumn,$dateTimeColumn,$goldColumn,$silverColumn,$bronzeColumn) '
          'VALUES("$gameName","$gameImgUrl","$now","$gold","$silver","$bronze")');
      myGames.add(game);
      notifyListeners();
      print(result);
    } catch (e) {
      print(e);
    }
  }

  void removeGameFromDb(GameModel game, BuildContext context) async {
    try {
      String gameName = game.gameName;
      var dbClient = await db;
      var result = await dbClient.rawDelete(
          'DELETE FROM $myGamesTable WHERE $gameNameColumn = "${game.gameName}"');
      myGames.removeWhere((element) {
        if (element.gameName == gameName) {
          return true;
        }
        return false;
      });
      notifyListeners();
      print(result);
    } catch (e) {
      print(e);
    }
  }

  void getAllGamesFromDb() async {
    try {
      var dbClient = await db;
      List<Map> result = await dbClient.rawQuery('SELECT * FROM $myGamesTable');
      if (result.length > 0) {
        for (var i in result) {
          GameModel game = new GameModel(
              gameName: i['$gameNameColumn'],
              gameImageUrl: i['$gameImgUrlColumn'],
              gold: i['$goldColumn'] != null ? i['$goldColumn'] : '3',
              bronze: i['$bronzeColumn'] != null ? i['$bronzeColumn'] : '3',
              silver: i['$silverColumn'] != null ? i['$silverColumn'] : '3');
          myGames.add(game);
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  void addTrophyToComplete(GuideModel guide) async {
    try {
      String gameName = guide.gameName;
      String gameImgUrl = guide.gameImgUrl;
      String trophyName = guide.trophyName;
      String trophyImgUrl = guide.trophyImage;
      String trophyType = guide.trophyType;
      String trophyDescription = guide.trophyDescription;
      String trophyGuide = guide.trophyGuide;
      DateTime now = DateTime.tryParse(DateTime.now().toString());
      var dbClient = await db; //This calls the getter function
      var result = await dbClient.rawInsert(
          'INSERT INTO $myTrophyTable($gameNameColumn, $gameImgUrlColumn,$trophyNameColumn,$trophyImageUrlColumn,$trophyTypeColumn,$trophyDescriptionColumn,$trophyGuideColumn,$trophyActionColumn,$dateTimeColumn) '
          'VALUES("$gameName","$gameImgUrl","$trophyName","$trophyImgUrl","$trophyType","$trophyDescription","$trophyGuide","COMPLETED","$now")');
      myCompletedTrophy.add(guide);
      notifyListeners();
      print(result);
    } catch (e) {
      print(e);
    }
  }

  void addTrophyToStarred(GuideModel guide) async {
    try {
      String gameName = guide.gameName;
      String gameImgUrl = guide.gameImgUrl;
      String trophyName = guide.trophyName;
      String trophyImgUrl = guide.trophyImage;
      String trophyType = guide.trophyType;
      String trophyDescription = guide.trophyDescription;
      String trophyGuide = guide.trophyGuide;
      DateTime now = DateTime.tryParse(DateTime.now().toString());
      var dbClient = await db; //This calls the getter function
      var result = await dbClient.rawInsert(
          'INSERT INTO $myTrophyTable($gameNameColumn, $gameImgUrlColumn,$trophyNameColumn,$trophyImageUrlColumn,$trophyTypeColumn,$trophyDescriptionColumn,$trophyGuideColumn,$trophyActionColumn,$dateTimeColumn) '
          'VALUES("$gameName","$gameImgUrl","$trophyName","$trophyImgUrl","$trophyType","$trophyDescription","$trophyGuide","STARRED","$now")');
      myStarredTrophy.add(guide);
      notifyListeners();
      print(result);
    } catch (e) {
      print(e);
    }
  }

  void removeTrophyFromComplete(GuideModel guide) async {
    try {
      String trophyName = guide.trophyName;
      var dbClient = await db; //This calls the getter function
      var result = await dbClient.rawDelete(
          'DELETE FROM $myTrophyTable WHERE $trophyNameColumn = "${guide.trophyName}" AND $trophyActionColumn = "COMPLETED"');
      myCompletedTrophy.removeWhere((element) {
        if (element.trophyName == trophyName) {
          return true;
        }
        return false;
      });
      notifyListeners();
      print(result);
    } catch (e) {
      print(e);
    }
  }

  void removeTrophyFromStarred(GuideModel guide) async {
    try {
      String trophyName = guide.trophyName;
      var dbClient = await db; //This calls the getter function
      var result = await dbClient.rawDelete(
          'DELETE FROM $myTrophyTable WHERE $trophyNameColumn = "${guide.trophyName}" AND $trophyActionColumn = "STARRED"');
      myStarredTrophy.removeWhere((element) {
        if (element.trophyName == trophyName) {
          return true;
        }
        return false;
      });
      notifyListeners();
      print(result);
    } catch (e) {
      print(e);
    }
  }

  void getAllTrophiesFromDb() async {
    try {
      var dbClient = await db;
      List<Map> result = await dbClient.rawQuery(
          'SELECT * FROM $myTrophyTable ORDER BY $dateTimeColumn DESC');
      if (result.length > 0) {
        for (var i in result) {
          GuideModel guide = new GuideModel(
              trophyDescription: i['$trophyDescriptionColumn'],
              trophyGuide: i['$trophyGuideColumn'],
              trophyImage: i['$trophyImageUrlColumn'],
              trophyName: i['$trophyNameColumn'],
              trophyType: i['$trophyTypeColumn'],
              gameImgUrl: i['$gameImgUrlColumn'],
              gameName: i['$gameNameColumn'],
              isCompleted: i['$trophyActionColumn'] == 'COMPLETED',
              isStarred: i['$trophyActionColumn'] == 'STARRED');
          if (guide.isCompleted) {
            myCompletedTrophy.add(guide);
          } else {
            myStarredTrophy.add(guide);
          }
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
