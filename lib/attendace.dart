import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateAttendance extends StatefulWidget {
  @override
  State<UpdateAttendance> createState() => UpdateAttendaceState();
}

class UpdateAttendaceState extends State<UpdateAttendance> {
  var controllerForDate = TextEditingController();
  var pickedDate;
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Update attendace',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
          const  SizedBox(
              height: 30,
            ),
            TextField(controller: controllerForDate,
              decoration: const InputDecoration(hintText: 'Pick a date'),
              onTap: () async {
                var datePicker = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                                  primary: Colors.blue,
                                  onSurface: Colors.white,
                                  background: Colors.black,
                                  onBackground: Colors.black)),
                          child: child!);
                    });

                    if(datePicker != null){
                       pickedDate = datePicker.toString();
                       controllerForDate.text = pickedDate;
                       print(controllerForDate.text) ;
                    }
              },
            ),
            const SizedBox(
              height: 30,
            ),
           // TimePicker
          ],
        ),
      ),
    );
  }
}
