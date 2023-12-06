import 'package:attendance/dataBase/dataBase.dart';
import 'package:attendance/homePage.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  var adminName = '';
  var passWord = '';
  var editingController = TextEditingController();
  var editingControllerPassword = TextEditingController();
  @override
  Widget build(context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Center(
                child: Container(
              width: MediaQuery.of(context).size.width - 50.0,
              height: MediaQuery.of(context).size.height,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 110,
                  ),
                 const Text(
                    'Sign up as Admin',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  TextField(//keyboardType: ,
                    controller: editingController,
                    decoration: InputDecoration(hintText: 'Admin name'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    controller: editingControllerPassword,
                    decoration: InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      width: 250,
                      height: 30,
                    ),
                    onTap: () async {
                      var adminName = editingController.text;
                      var passWord = editingControllerPassword.text;
                      var db = await DataBaseHelpler().createDataBase();

                      if (adminName.isNotEmpty && passWord.isNotEmpty) {
                        await db.insert('Admin', {
                          'name': adminName.toString(),
                          'password': passWord.toString()
                        });

                        Navigator.popAndPushNamed(context, '/HomePage');
                      } else {
                        //const SnackBar(content: Text('Fill up details'),duration: Duration(seconds: 2),);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Fill up details'),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.blue,
                        ));
                      }
                    },
                  )
                ],
              )),
            ))));
  }
}
