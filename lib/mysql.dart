import 'package:mysql1/mysql1.dart';

class Mysql{
  static String host = 'komori-db-new.ccwjoplbkphp.us-east-1.rds.amazonaws.com',
                user = 'admin',
                password = 'guidancesystem',
                db = 'Guidance_system';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
      host: host,
      port: port,
      user: user,
      password: password,
      db: db,
    );
    return await MySqlConnection.connect(settings);
  }
}

