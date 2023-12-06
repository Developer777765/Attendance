import 'package:attendance/dataBase/dataBase.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var switcher = true;
  var tempId = 0;
  late var empInfo;
  var gotData = false;
  var noob = true;
  var editingControllerForName = TextEditingController();
  var editingControllerForId = TextEditingController();
  List<String> options = ['Update', 'Insert', 'Delete'];
  String currOption = 'Update';

  @override
  Widget build(context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              FutureBuilder(
                  future: switcher
                      ? DataBaseHelpler().queryingAdminTable()
                      : DataBaseHelpler().queryingEmployeeInfo(),
                  builder: (context, snapShot) {
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Colors.blue,
                      );
                    } else if (snapShot.hasError) {
                      return const Text('Something went wrong');
                    }

                    var map = snapShot.data as List;
                    empInfo = map;
                    int i = 0;
                    for (int j = 0; j < map.length; j++) {
                      if (map[j]['empNo'] == tempId) {
                        i = j;

                        break;
                      }
                    }

                    return DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.blue),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person_outline_rounded),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                              height: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    switcher
                                        ? map[0]['name']
                                        : map[i]['empName'],
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    switcher ? 'Admin' : map[i]['designation'],
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ))
                        ],
                      ),
                    );
                  }),
              ListTile(
                title: Text(
                  switcher ? 'Switch to employee' : 'Switch to Admin',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onTap: () {
                  //setState(() {
                  //switcher = false;
                  //});
                  print('switcher is $switcher');
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Sign In'),
                          content: Container(
                              height: 200,
                              child: Column(
                                children: [
                                  TextField(
                                    controller: editingControllerForName,
                                    decoration: InputDecoration(
                                        hintText: switcher
                                            ? 'Employee name'
                                            : 'Admin name'),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: editingControllerForId,
                                    decoration: InputDecoration(
                                        hintText: switcher ? 'Id' : 'Password'),
                                  ),
                                ],
                              )),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17))),
                            TextButton(
                                onPressed: () async {
                                  List<Map<dynamic, dynamic>> slaveInfo = [];
                                  bool goAhead = false;
                                  bool switchToAdmin = false;
                                  if (switcher) {
                                    slaveInfo = await DataBaseHelpler()
                                        .queryingEmployeeInfo();
                                  } else {
                                    slaveInfo = await DataBaseHelpler()
                                        .queryingAdminTable();
                                  }

                                  Navigator.of(context).pop();
                                  var name =
                                      editingControllerForName.text.toString();
                                  var id =
                                      editingControllerForId.text.toString();
                                  var no = 0;
                                  // if (!switcher) {
                                  no = int.parse(id);
                                  //   }
                                  for (int i = 0; i < slaveInfo.length; i++) {
                                    if (switcher) {
                                      if (slaveInfo[i]['empNo'] == no) {
                                        goAhead = true;
                                        break;
                                      }
                                    } else {
                                      if (slaveInfo[i]['name'] == name) {
                                        switchToAdmin = true;
                                        break;
                                      }
                                    }
                                  }
                                  if ((name.isNotEmpty && id.isNotEmpty) &&
                                      goAhead) {
                                    //(goAhead){
                                    setState(() {
                                      switcher = !switcher;
                                      tempId = int.parse(id);
                                      Navigator.pop(context);
                                    });
                                  } else if (switchToAdmin) {
                                    setState(() {
                                      switcher = switchToAdmin;
                                      //tempId = int.parse(id);
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'There in no such employee')));
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('Sign in',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17))),
                          ],
                        );
                      });
                },
              ),
              ListTile(
                title: Text(
                  switcher ? 'Create employee' : '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onTap: () {
                  if (switcher) {
                    Navigator.pop(context);
                    Navigator.popAndPushNamed(context, '/EmployeeCreation');
                  }
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: switcher
              ? const Text(
                  'Payroll',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              : const Text(
                  'Employee Data',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
        ),
        body: // dataAvailable
            //  ?
            switcher
                ? FutureBuilder(
                    future: DataBaseHelpler().queryingEmployeeTable(),
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: Colors.blue,
                        ));
                      } else if (snapShot.hasError) {
                        return const Center(
                          child: Text('No data to manipulate'),
                        );
                      }
                      List empInfo = snapShot.data as List;

                      if(empInfo.isEmpty){return Center(child: Text('No data to manipulate',style: TextStyle(fontWeight: FontWeight.bold),),);}

                      return ListView.builder(
                        itemCount: empInfo.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                              onTap: () {
                                print('switcher is over here $switcher');
                                // print(dataAvailable[0]['password']);
                              },
                              title: Container(
                                width: MediaQuery.of(context).size.width - 20.5,
                                child: Row(children: [
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  const CircleAvatar(
                                    child: Icon(Icons.person),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        empInfo[index]['empName'],
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                        maxLines: 1,
                                      ),
                                      const SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        empInfo[index]['designation'],
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        var controllerId =
                                            TextEditingController();
                                        var controllerDate =
                                            TextEditingController();
                                        var controllerInTime =
                                            TextEditingController();
                                        var controllerOutTime =
                                            TextEditingController();
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              var selectedValue;

                                              return AlertDialog(
                                                content: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      100,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      20.5,
                                                  child: SingleChildScrollView(
                                                      child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'ID',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          Container(
                                                              width: 170,
                                                              child: TextField(
                                                                decoration: InputDecoration(
                                                                    hintText: empInfo[index]
                                                                            [
                                                                            'empNo']
                                                                        .toString(),
                                                                    border:
                                                                        OutlineInputBorder()),
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'Date',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          Container(
                                                              width: 170,
                                                              child:
                                                                   TextField(keyboardType: TextInputType.datetime,controller: controllerDate,
                                                                decoration: InputDecoration(
                                                                    hintText:
                                                                        'YYYY/MM/DD',
                                                                    border:
                                                                        OutlineInputBorder()),
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'In time',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          Container(
                                                              width: 170,
                                                              child:
                                                                   TextField(keyboardType: TextInputType.datetime,controller: controllerInTime,
                                                                decoration: InputDecoration(
                                                                    hintText:
                                                                        '00:00:00',
                                                                    border:
                                                                        OutlineInputBorder()),
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Text(
                                                            'Out time',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          Container(
                                                              width: 170,
                                                              child:
                                                                   TextField(keyboardType: TextInputType.datetime, controller: controllerOutTime,
                                                                decoration: InputDecoration(
                                                                    hintText:
                                                                        '00:00:00',
                                                                    border:
                                                                        OutlineInputBorder()),
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      //  Row(
                                                      //    children: [

                                                      StatefulBuilder(builder:
                                                          ((context, setState) {
                                                        return Column(
                                                          children: [
                                                            ListTile(
                                                              title: Text(
                                                                  options[0]),
                                                              leading: Radio(
                                                                  activeColor:
                                                                      Colors
                                                                          .blue,
                                                                  value:
                                                                      options[
                                                                          0],
                                                                  groupValue:
                                                                      currOption,
                                                                  onChanged:
                                                                      (value) {
                                                                    print(
                                                                        'the radio is ${value.toString()}');
                                                                    setState(
                                                                        () {
                                                                      currOption =
                                                                          value
                                                                              .toString();
                                                                    });
                                                                  }),
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                  options[1]),
                                                              leading: Radio(
                                                                  activeColor:
                                                                      Colors
                                                                          .blue,
                                                                  value:
                                                                      options[
                                                                          1],
                                                                  groupValue:
                                                                      currOption,
                                                                  onChanged:
                                                                      (value) {
                                                                    print(
                                                                        'the radio is ${value.toString()}');
                                                                    setState(
                                                                        () {
                                                                      currOption =
                                                                          value
                                                                              .toString();
                                                                    });
                                                                  }),
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                  options[2]),
                                                              leading: Radio(
                                                                  activeColor:
                                                                      Colors
                                                                          .blue,
                                                                  value:
                                                                      options[
                                                                          2],
                                                                  groupValue:
                                                                      currOption,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      currOption =
                                                                          value
                                                                              .toString();
                                                                    });
                                                                  }),
                                                            ),
                                                          ],
                                                        );
                                                      })),

                                                      const SizedBox(
                                                        height: 50,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child:
                                                                  Container()),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              height: 40,
                                                              width: 80,
                                                              child: const Center(
                                                                  child: Text(
                                                                      'Cancel')),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              print('submit works as expected');
                                                              print('date from the field is ${controllerDate.text}');
                                                              bool empTblSts =
                                                                  await DataBaseHelpler()
                                                                      .queryingEmployeeTableStatus();

                                                              var db =
                                                                  await DataBaseHelpler()
                                                                      .initDB();
                                                                      print('currOption is $currOption');
                                                              if (currOption ==
                                                                  'Update') {


                                                                    print('we are inside to update time');

                                                                //to update record
                                                                var attndnce = await DataBaseHelpler()
                                                                    .queryingAttendance(
                                                                        empInfo[index]
                                                                            [
                                                                            'empNo']);
                                                                if (attndnce[
                                                                    'status']) {
                                                                      print('attendance is real');
                                                                  var atndnce =
                                                                      attndnce[
                                                                          'attendance'];
                                                                  print(atndnce);
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          atndnce
                                                                              .length;
                                                                      i++) {
                                                                        print('date in the db is ${atndnce[i]['date']}');
                                                                        
                                                                    if (atndnce[i]['date'] ==
                                                                            controllerDate.text
                                                                                .toString() &&
                                                                        atndnce[i]['outTime'] ==
                                                                            null) {
                                                                      //await db.
                                                                      print('we are inside updation sector');
                                                                      await db
                                                                          .update(
                                                                        'UPDATE Attendance SET outTime = ? WHERE empNo = ? AND date = ? AND outTime IS NULL',
                                                                        [
                                                                          controllerOutTime
                                                                              .text
                                                                              .toString(),
                                                                          empInfo[index]
                                                                              [
                                                                              'empNo'],
                                                                          controllerDate
                                                                              .text
                                                                              .toString()
                                                                        ],
                                                                      );Navigator.pop(context);
                                                                      break;
                                                                    } else if (atndnce[i]
                                                                            [
                                                                            'date'] ==
                                                                        controllerDate
                                                                            .text
                                                                            .toString()) {

                                                                              print('we are updating both in and out times');
                                                                      await db
                                                                          .update(
                                                                              'Attendance',
                                                                              {
                                                                                'outTime': controllerOutTime.text.toString(),
                                                                                'inTime': controllerInTime.text.toString()
                                                                              },
                                                                              where:
                                                                                  'empNo = ? AND date = ?',
                                                                              whereArgs: [
                                                                                empInfo[index]['empNo'],
                                                                                atndnce[i]['date']
                                                                              ]);
                                                                              Navigator.pop(context);
                                                                     var justInfo = await DataBaseHelpler().queryingAttendance(empInfo[index]['empNo']);        
                                                                     print(justInfo);
                                                                      break;
                                                                    }
                                                                  }
                                                                }

                                                                print('');
                                                              } else if (currOption ==
                                                                  'Insert') {
                                                                //to insert record

                                                                var attndnce = await DataBaseHelpler()
                                                                    .queryingAttendance(
                                                                        empInfo[index]
                                                                            [
                                                                            'empNo']);
                                                                if (!attndnce[
                                                                    'status']) {
                                                                  await db.insert(
                                                                      'Attendance',
                                                                      {
                                                                        'empNo':
                                                                            empInfo[index]['empNo'],
                                                                        'date': controllerDate
                                                                            .text
                                                                            ,
                                                                        'inTime': controllerInTime
                                                                            .text
                                                                            ,
                                                                        'outTime': controllerOutTime
                                                                            .text
                                                                            
                                                                      });
                                                                      Navigator.pop(context);
                                                                } else {
                                                                  bool
                                                                      goAhead1 =
                                                                      true;
                                                                  var att =
                                                                      attndnce[
                                                                          'attendance'];
                                                                  for (int i =
                                                                          0;
                                                                      i < att.length;
                                                                      i++) {
                                                                    if (att[i][
                                                                            'date'] ==
                                                                        controllerDate
                                                                            .text
                                                                            ) {
                                                                      goAhead1 =
                                                                          false;
                                                                      break;
                                                                    }
                                                                  }
                                                                  if (goAhead1) {
                                                                    await db.insert(
                                                                        'Attendance',
                                                                        {
                                                                          'empNo':
                                                                              empInfo[index]['empNo'],
                                                                          'date': controllerDate
                                                                              .text
                                                                              ,
                                                                          'inTime': controllerInTime
                                                                              .text
                                                                             ,
                                                                          'outTime': controllerOutTime
                                                                              .text
                                                                              
                                                                        });Navigator.pop(context);
                                                                  }
                                                                }
                                                              } else {
                                                                //To delete record
                                                                var attndnce = await DataBaseHelpler()
                                                                    .queryingAttendance(
                                                                        empInfo[index]
                                                                            [
                                                                            'empNo']);
                                                                if (attndnce[
                                                                    'status']) {
                                                                  await db.delete(
                                                                      'Attendance',
                                                                      where: 'empNo = ? AND date = ?',
                                                                      whereArgs: [
                                                                        empInfo[index]
                                                                            [
                                                                            'empNo'],
                                                                        controllerDate
                                                                            .text
                                                                           
                                                                      ]);
                                                                      Navigator.pop(context);
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .blue,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              height: 40,
                                                              width: 80,
                                                              child: const Center(
                                                                  child: Text(
                                                                      'Submit')),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      //   ],
                                                      //     ),
                                                    ],
                                                  )),
                                                ),
                                              );
                                            });
                                      },
                                      icon: const Icon(Icons.edit))
                                ]),
                              ));
                        },
                      );
                    },
                  )
                : FutureBuilder(
                    future: DataBaseHelpler().queryingEmployeeInfo(),
                    builder: (context, snapShot) {
                      if (snapShot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(
                          color: Colors.blue,
                        );
                      } else if (snapShot.hasError) {}

                      late var idOfEmp;
                      var map = snapShot.data as List;
                      empInfo = map;
                      int i = 0;
                      for (int j = 0; j < map.length; j++) {
                        if (map[j]['empNo'] == tempId) {
                          i = j;
                          break;
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        //    height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            Container(
                                height: 80,
                                child: Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 50,
                                      child: Icon(Icons.person),
                                    ),
                                    //  const SizedBox(
                                    //     width: 10,
                                    //   ),
                                    Container(
                                        // height: 75,
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          empInfo[i]['empName'],
                                          //'Name',
                                          maxLines: 1,
                                          style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          map[i]['designation'],
                                          //'Dept',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        ),
                                      ],
                                    )),
                                    Expanded(child: Container()),
                                  ],
                                )),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FutureBuilder(
                                future: DataBaseHelpler()
                                    .queryingAttendance(map[i]['empNo']),
                                builder: (context, snapShot) {
                                  if (snapShot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Container();
                                  } else if (snapShot.hasError) {
                                    return Container(
                                      child: const Text('Update info'),
                                    );
                                  }
                                  Map<dynamic, dynamic> queriedAttendance =
                                      snapShot.data as Map;
                                  print('map is $queriedAttendance');
                                  
                                  var notInformed;
                                  

                                  //    return Container(
                                  //       child: Text('trial'),
                                  //     );

                                  if (queriedAttendance['status']) {
                                    gotData = true;
                                    var unOfLvs = countAbsents(queriedAttendance);
                                    print('uninformed leaves are $unOfLvs');
                                    var attdnce =
                                        queriedAttendance['attendance'];
                                    dynamic counterForWorkingDays = 0;
                                    dynamic counterForAbsent;
                                    var halfDayLeave = 0.0;
                                    var counterForTardyLogins = 0;
                                    var counterForHalfDays = 0;
                                    dynamic counterForOneDays = 0;
                                    for (int i = 0; i < attdnce.length; i++) {
                                      try{
                                      if (attdnce[i]['outTime'] != null) {
                                        //print('time is ${attdnce[i]['inTime']}');
                                        var inTime = attdnce[i]['inTime']
                                            .substring(0, 2);
                                        var updatedInTime = int.parse(inTime);
                                        var outTime = attdnce[i]['outTime']
                                            .substring(0, 2);
                                        var updatedOutTime = int.parse(outTime);
                                        var workingHour =
                                            updatedOutTime - updatedInTime;
                                        if (workingHour >= 8) {
                                          counterForWorkingDays += 1;
                                        }else if(workingHour >= 4 && workingHour <8 ){
                                          counterForWorkingDays += 0.5;
                                        }
                                        if (attdnce[i]['inTime']
                                                .substring(0, 5) !=
                                            '09:00') {
                                          counterForTardyLogins += 1;
                                        }
                                        if (workingHour >= 4 &&
                                            workingHour < 8) {
                                          counterForHalfDays += 1;
                                          halfDayLeave += 0.5;
                                        }
                                        if (workingHour < 4) {
                                          counterForOneDays += 1;
                                        }



                                       //  counterForAbsent =
                                        //counterForHalfDays + counterForOneDays;
                                      }else{noob = false;}
                                      }
                                      catch(exception){
                                        print('exception is $exception');
                                      }
                                    }
//try{                               
                                    counterForOneDays += unOfLvs['absentCount'] ;
                                     counterForAbsent = halfDayLeave + counterForOneDays;// + unOfLvs['absentCount'];//}
                                    // catch(excep){print('annoying exception is $excep');}
                             //       counterForAbsent =
                             //           counterForHalfDays + counterForOneDays;
                                    return Container(
                                        child: Column(children: [
                                      Row(
                                        children: [
                                          Column(
                                            children: [
                                              GestureDetector(onTap: () {
                                                 var oneDay = [];
                                                if(counterForWorkingDays > 0){
                                                  for(int i = 0; i<queriedAttendance['attendance'].length; i++){
                                                  var inTime = queriedAttendance['attendance'][i]['inTime']
                                            .substring(0, 2);
                                        var updatedInTime = int.parse(inTime);
                                        var outTime = queriedAttendance['attendance'][i]['outTime']
                                            .substring(0, 2);
                                        var updatedOutTime = int.parse(outTime);
                                        var workingHour =
                                            updatedOutTime - updatedInTime;
                                            if(workingHour >= 8){
                                              oneDay.add({'date':queriedAttendance['attendance'][i]['date'],});
                                            }else if(workingHour >= 4 && workingHour < 8){
                                              oneDay.add({'date':queriedAttendance['attendance'][i]['date'],});
                                            }
                                                }
                                                }
                                                if(counterForWorkingDays > 0){
                                                 showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text('Working days'),
                                                            content:
                                                                Container(
                                                                height: 350,
                                                                width: 300,
                                                                child: ListView.builder(itemCount: oneDay.length,itemBuilder: (cont,spot){
                                                                  return Container(
                                                                    padding: const EdgeInsets.only(left: 5,right: 5),
                                                                    height: 50,
                                                                    width: double.infinity,
                                                                    child: Row(children: [Text(oneDay[spot]['date']),],),
                                                                    );
                                                                }),
                                                                ),
                                                          );
                                                        });}
                                              },child:CircleAvatar(
                                                child: Text(gotData
                                                    ? counterForWorkingDays
                                                        .toString()
                                                    : '0'),
                                              )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('Working days')
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Column(
                                            children: [

                                              GestureDetector(onTap: (){

                                                var half = [];
                                                var one = [];
                                                
                                                if(queriedAttendance['status'])
                                                {
                                                   
                                                   //COME OVER HERE YOU DUMB SHIT


                                                  if(counterForHalfDays > 0){
                                                       for(int i = 0; i<queriedAttendance['attendance'].length; i++){
                                                         var inTime = queriedAttendance['attendance'][i]['inTime']
                                            .substring(0, 2);
                                        var updatedInTime = int.parse(inTime);
                                        var outTime = queriedAttendance['attendance'][i]['outTime']
                                            .substring(0, 2);
                                        var updatedOutTime = int.parse(outTime);
                                        var workingHour =
                                            updatedOutTime - updatedInTime;
                                            if(workingHour >= 4 && workingHour < 8){
                                              half.add(queriedAttendance['attendance'][i]['date'],);
                                            }
                                                      }
                                                    }


                                                  if(counterForOneDays > 0){
                                                  for(int i = 0; i<queriedAttendance['attendance'].length; i++){
                                                  var inTime = queriedAttendance['attendance'][i]['inTime']
                                            .substring(0, 2);
                                        var updatedInTime = int.parse(inTime);
                                        var outTime = queriedAttendance['attendance'][i]['outTime']
                                            .substring(0, 2);
                                        var updatedOutTime = int.parse(outTime);
                                        var workingHour =
                                            updatedOutTime - updatedInTime;
                                            if(workingHour < 4){
                                              one.add(queriedAttendance['attendance'][i]['date'],);
                                            }
                                                }
                                                } 

                                               

                                                  var combinedLeaves = [];

                                                  if(one.isNotEmpty){
                                                    combinedLeaves.addAll(one);
                                                  }
                                                  if(half.isNotEmpty){
                                                    combinedLeaves.addAll(half);
                                                  }
                                                  if(unOfLvs['absent'].isNotEmpty){
                                                    combinedLeaves.addAll(unOfLvs['absent']);
                                                  }
                                                  //var leaves = unOfLvs['absent'].addAll(combinedLeaves);
                                                 
                                                // print(  notInformed = unOfLvs['absentCount']);

                                                print('combined leaves are $combinedLeaves');
                                                print('one day leaves are $one');
                                                print('half day leaves are $half');

                                                   if(counterForAbsent > 0){
                                                   showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text('Absent days'),
                                                            content:
                                                                Container(
                                                                height: 350,
                                                                width: 300,
                                                                child: ListView.builder(itemCount: combinedLeaves.length,itemBuilder: (cont,spot){
                                                                  return Container(
                                                                    padding: const EdgeInsets.only(left: 5,right: 5),
                                                                    height: 50,
                                                                    width: double.infinity,
                                                                    child: Row(children: [Text(combinedLeaves[spot]),],),
                                                                    );
                                                                }),
                                                                ),
                                                          );
                                                        });}
                                                }
                                              }, child: CircleAvatar(
                                                child: Text(
                                                 counterForAbsent > 0 ? counterForAbsent.toString():
                                                    '0'),
                                              )),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text('Absent')
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    var tardyLogins = [];
                                                    if(counterForTardyLogins > 0){
                                                      for(int i = 0; i<queriedAttendance['attendance'].length; i++){
                                                        if(queriedAttendance['attendance'][i]['inTime'].substring(0,5) != '09:00'){
                                                          tardyLogins.add({'tardyDate':queriedAttendance['attendance'][i]['date'],'tardyInTime':queriedAttendance['attendance'][i]['inTime']});
                                                        }
                                                      }
                                                    }
                                                    if(counterForTardyLogins > 0){showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text('Tardy logins'),
                                                            content:
                                                                Container(
                                                                height: 350,
                                                                width: 300,
                                                                child: ListView.builder(itemCount: tardyLogins.length,itemBuilder: (cont,spot){
                                                                  return Container(
                                                                    padding: const EdgeInsets.only(left: 5,right: 5),
                                                                    height: 50,
                                                                    width: double.infinity,
                                                                    child: Row(children: [Text(tardyLogins[spot]['tardyDate']),Expanded(child: Container()),Text(tardyLogins[spot]['tardyInTime'])],),
                                                                    );
                                                                }),
                                                                ),
                                                          );
                                                        });}
                                                  },
                                                  child: CircleAvatar(
                                                    child: Text(gotData
                                                        ? counterForTardyLogins
                                                            .toString()
                                                        : '0'),
                                                  )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text('Tardy logins')
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          Column(
                                            children: [
                                              GestureDetector(onTap: (){
                                                 var halfDay = [];
                                                    if(counterForHalfDays > 0){
                                                       for(int i = 0; i<queriedAttendance['attendance'].length; i++){
                                                         var inTime = queriedAttendance['attendance'][i]['inTime']
                                            .substring(0, 2);
                                        var updatedInTime = int.parse(inTime);
                                        var outTime = queriedAttendance['attendance'][i]['outTime']
                                            .substring(0, 2);
                                        var updatedOutTime = int.parse(outTime);
                                        var workingHour =
                                            updatedOutTime - updatedInTime;
                                            if(workingHour >= 4 && workingHour < 8){
                                              halfDay.add({'date':queriedAttendance['attendance'][i]['date'],});
                                            }
                                                      }
                                                    }

                                            if(counterForHalfDays > 0){
                                               showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text('Half day leave'),
                                                            content:
                                                                Container(
                                                                height: 350,
                                                                width: 300,
                                                                child: ListView.builder(itemCount: halfDay.length,itemBuilder: (cont,spot){
                                                                  return Container(
                                                                    padding: const EdgeInsets.only(left: 5,right: 5),
                                                                    height: 50,
                                                                    width: double.infinity,
                                                                    child: Row(children: [Text(halfDay[spot]['date']),],),
                                                                    );
                                                                }),
                                                                ),
                                                          );
                                                        });
                                            }        
                                              },child:CircleAvatar(
                                                child: Text(gotData
                                                    ? counterForHalfDays
                                                        .toString()
                                                    : '0'),
                                              )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text('Half day leave')
                                            ],
                                          ),
                                          /*
                                          Expanded(
                                            child: Container(),
                                          ),*/
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          Column(
                                            children: [
                                              GestureDetector(onTap: () {
                                                var oneDay = [];
                                                if(counterForOneDays > 0){
                                                  for(int i = 0; i<queriedAttendance['attendance'].length; i++){
                                                  var inTime = queriedAttendance['attendance'][i]['inTime']
                                            .substring(0, 2);
                                        var updatedInTime = int.parse(inTime);
                                        var outTime = queriedAttendance['attendance'][i]['outTime']
                                            .substring(0, 2);
                                        var updatedOutTime = int.parse(outTime);
                                        var workingHour =
                                            updatedOutTime - updatedInTime;
                                            if(workingHour < 4){
                                              oneDay.add(queriedAttendance['attendance'][i]['date'],);
                                            }
                                                }
                                                }

                                                if(unOfLvs['absent'].isNotEmpty){
                                                  oneDay.addAll(unOfLvs['absent']);
                                                }

                                              if(counterForOneDays > 0) {
                                                showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text('One day leave'),
                                                            content:
                                                                Container(
                                                                height: 350,
                                                                width: 300,
                                                                child: ListView.builder(itemCount: oneDay.length,itemBuilder: (cont,spot){
                                                                  return Container(
                                                                    padding: const EdgeInsets.only(left: 5,right: 5),
                                                                    height: 50,
                                                                    width: double.infinity,
                                                                    child: Row(children: [Text(oneDay[spot]),],),
                                                                    );
                                                                }),
                                                                ),
                                                          );
                                                        });
                                              } 

                                              },child:CircleAvatar(
                                                child: Text(gotData
                                                    ? counterForOneDays 
                                                        .toString()
                                                    : '0'),
                                              )),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              const Text('One day leave')
                                            ],
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                        ],
                                      )
                                    ]));
                                  } else {
                                    return Container(
                                      child: const Center(
                                        child: Text(''),
                                      ),
                                    );
                                  }
                                }),
                            const SizedBox(
                              height: 150,
                            ),
                            FutureBuilder(
                              future: DataBaseHelpler()
                                  .queryingAttendance(map[i]['empNo']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                } else if (snapshot.hasError) {
                                  return Container();
                                }
                                Map<dynamic, dynamic> attendance =
                                    snapshot.data as Map;
                                return GestureDetector(
                                  onTap: () async {
                                    var db = await DataBaseHelpler()
                                        .createDataBase();

                                    int timestamp =
                                        DateTime.now().millisecondsSinceEpoch;
                                    DateTime tsdate =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            timestamp);
                                    String date = tsdate.year.toString() +
                                        "/" +
                                        tsdate.month.toString() +
                                        "/" +
                                        tsdate.day.toString();
                                    String time = DateTime.now().toString();
                                    var updatedTime = time.substring(11, 19);
                                    print(date);
                                    print(updatedTime);

                                    if (!attendance['status']) {
                                      print('we are inserting data to databse');
                                      await db.insert('Attendance', {
                                        'empNo': map[i]['empNo'],
                                        'date': date,
                                        'inTime': updatedTime
                                        //'outTime': '00:00:00'
                                      });

                                      setState(
                                        () {
                                          empInfo = true;
                                        },
                                      );
                                    } else {
                                      var list = attendance['attendance'];
                                      for (int j = 0; j < list.length; j++) {
                                        if (date == list[j]['date']) {
                                          print(
                                              'Date $date is matching and id is ${map[i]['empNo']}');
                                              if(list[j]['outTime'] == null){
                                          db.rawUpdate(
                                            'UPDATE Attendance SET outTime = ? WHERE empNo = ? AND date = ? AND outTime IS NULL',
                                            [
                                              updatedTime,
                                              map[i]['empNo'],
                                              date
                                            ],
                                          );
                                          //break;
                                          setState(
                                            () {
                                              empInfo = true;
                                            },
                                          );
                                        }} /*else {
                                          print('hell it is the else part here which is the bug');
                                          await db.insert('Attendance', {
                                            'empNo': map[i]['empNo'],
                                            'date': date,
                                            'inTime': updatedTime,
                                          });
                                          setState(
                                            () {
                                              empInfo = true;
                                            },
                                          );
                                        }*/
                                      }
                                    }
                                  },
                                  child: Container(
                                      child: Center(
                                          child: Container(
                                    width: 220,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: const Center(
                                        child: Text(
                                      'Update attendace',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                                  ))),
                                );
                              },
                            ),
                          ],
                        )),
                      );
                      //});
                    }));
  }

  countAbsents(var attendance){
    var counter = 0;
    var nonEntries = [];
    var days = [];
    
    if(attendance['attendance'].length == 1){
      return {'absentCount': 0, 'absent': []};
    }
    
    for(int i = 0; i<attendance['attendance'].length; i++){
      if(attendance['attendance'][i]['date'].length == 9){
        print('checking length ${attendance['attendance'][i]['date'].length}');
        var temp1 = attendance['attendance'][i]['date'].toString();//.substring(8,9);
        String temp2 = temp1.substring(8,9);
        var updatedTemp = int.parse(temp2);
        days.add(updatedTemp);
      }else{
       print('checking length ${attendance['attendance'][i].length}');
        var temp1 = attendance['attendance'][i]['date'].toString();//.substring(8,10);
        String temp2 = temp1.substring(8,10);
        var updatedTemp = int.parse(temp2);
        days.add(updatedTemp);
      }
    }
    days.sort();
    
    for(int i = 0; i<days.length; i++){
      if(i != days.length-1){
        int tempCounter = (days[i+1] - days[i]) -1;
        counter += tempCounter;
        for(int j = 0; j<tempCounter; j++){
          var cntr = j + 1;
          nonEntries.add('2023/12/${(days[i]+ cntr).toString()}');
        }
        
      }
    }
    
    return {'absentCount': counter, 'absent': nonEntries};
    
  }
}
