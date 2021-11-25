import 'package:anitrak/src/db/database.dart';

class DbHelper{
  static DataBase? _dataBase;

  static Future<DataBase> get database async{
    if(_dataBase != null){
      return _dataBase!;
    }
    return await $FloorDataBase.databaseBuilder('app_database.db').build();
  }
}