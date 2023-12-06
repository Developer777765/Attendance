import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelpler {
  createDataBase() async {
    Database db = await initDB();
    //db.close();
    return db;
  }

  initDB() async {
    var dataBasePath = await getDatabasesPath();
    var path = join(dataBasePath, 'attendance.db');
    var theDataBase = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Admin(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, password TEXT)');
      await db.execute(
          'CREATE TABLE Employee(id INTEGER PRIMARY KEY AUTOINCREMENT, empNo INTEGER, empName TEXT, password TEXT, dept TEXT, designation TEXT)');
      await db.execute(
          'CREATE TABLE Attendance(id INTEGER PRIMARY KEY AUTOINCREMENT, empNo INTEGER, date TEXT, inTime TEXT, outTime TEXT)');
    });

    return theDataBase;
  }

  queryingAdminTable() async {
    var db = await createDataBase();
    List<Map<dynamic, dynamic>> table = await db.query('Admin');
    return table;
  }

  queryingEmployeeTable() async {
    var db = await createDataBase();
    List<Map<dynamic, dynamic>> table = await db.query('Employee');
    return table;
  }

  queryingEmployeeInfo() async {
    var db = await createDataBase();
    List<Map<dynamic, dynamic>> table = await db.query('Employee');
    return table;
  }

  queryingAdminTableStatus() async {
    bool tableStatus = false;
    var db = await createDataBase();
    var table = await db.rawQuery('Select count(*) from Admin');
    int? count = Sqflite.firstIntValue(table);
    //print('number of rows is $count');
    if (count != null && count > 0) {
      //print('number of rows in databse is $count');
      return true;
    }

    return tableStatus;
  }

  queryingEmployeeTableStatus() async {
    bool tableStatus = false;
    var db = await createDataBase();
    var table = await db.rawQuery('Select count(*) from Employee');
    int? count = Sqflite.firstIntValue(table);
    //print('number of rows is $count');
    if (count != null && count > 0) {
      //print('number of rows in databse is $count');
      return true;
    }

    return tableStatus;
  }

  insertIntoAttendance(id, date, inTime, [outTime]) async {
    var db = await createDataBase();
    if (date.isNotEmpty) {
      await db
          .insert('Attendance', {'empNo': id, 'date': date, 'inTime': inTime});
    } else {
      await db.insert('Attendance',
          {'empNo': id, 'inTime': inTime}); // use date for where clause
    }
  }

  queryingAttendance(id) async {
    try {
      var db = await createDataBase();

      var count = await db
          .rawQuery('select count(*) from Attendance where empNo=?', [id]);

      int? updatedCount = Sqflite.firstIntValue(count);

      if (updatedCount != null && updatedCount > 0) {
        List<Map<dynamic, dynamic>> attendance = await db.rawQuery(
            'SELECT empNo, date, inTime, outTime FROM Attendance WHERE empNo = ?',
            [id]);

        return {'status': true, 'attendance': attendance};
      } else {
        var map = {'status': false, 'attendance': null};

        return map;
      }
    } catch (exception) {
      print(exception);
    }
  }
}
