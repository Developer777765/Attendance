import 'package:attendance/dataBase/dataBase.dart';
import 'package:flutter/material.dart';

class EmployeeCreation extends StatefulWidget {
  @override
  State<EmployeeCreation> createState() => EmployeeCreationState();
}

class EmployeeCreationState extends State<EmployeeCreation> {
  var controllerName = TextEditingController();
  var controllerEmpNo = TextEditingController();
  var controllerPassword = TextEditingController();
  var controllerDepartment = TextEditingController();
  var controllerDesignation = TextEditingController();
  @override
  Widget build(context) {
    return WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text(
              'Employee registeration',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
                child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 50.5,
                    child: TextField(
                      controller: controllerName,
                      decoration: const InputDecoration(hintText: 'Name'),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 50.5,
                    child: TextField(
                      controller: controllerPassword,
                      decoration: const InputDecoration(hintText: 'Password'),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 50.5,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: controllerEmpNo,
                      decoration: const InputDecoration(hintText: 'Id'),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 50.5,
                    child: TextField(
                      controller: controllerDepartment,
                      decoration: const InputDecoration(hintText: 'Department'),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    width: MediaQuery.of(context).size.width - 50.5,
                    child: TextField(
                      controller: controllerDesignation,
                      decoration:
                          const InputDecoration(hintText: 'Designation'),
                    )),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                        child: Text(
                      'Create Profile',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
                    height: 35,
                    width: 220,
                  ),
                  onTap: () async {
                    var name = controllerName.text.toString();
                    var password = controllerPassword.text.toString();
                    var id = controllerEmpNo.text.toString();
                    var department = controllerDepartment.text.toString();
                    var designation = controllerDesignation.text.toString();
                    if (name.isNotEmpty) {
                      if (password.isNotEmpty) {
                        if (id.isNotEmpty) {
                          if (department.isNotEmpty) {
                            if (designation.isNotEmpty) {
                              var db = await DataBaseHelpler().createDataBase();
                              await db.insert('Employee', {
                                'empNo': int.parse(id),
                                'empName': name,
                                'passWord': password,
                                'dept': department,
                                'designation': designation
                              });
                              Navigator.popAndPushNamed(context, '/HomePage');
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Please provide designation'),
                              ));
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Please provide department'),
                            ));
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Please provide employee id'),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please provide password'),
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please provide name'),
                      ));
                    }
                  },
                )
              ],
            )),
          ),
        ));
  }
}
