import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/button_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/snackbar_widget.dart';
import '../widgets/textfield_widget.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/subject_widget.dart';

import '../utils/capitalize_string.dart';
import '../utils/constants.dart';
import '../utils/colors_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "/home-screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  var allUsers = [];
  bool loadingFetch = false, loadingAdd = false;
  double margin = 200;

  final subjectName = TextEditingController();

  @override
  void initState() {
    fetchAllSubjects();
    super.initState();
  }

  void showAddSubjectModal() {
    subjectName.text = "";
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.blueGrey,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              textfieldWidget(
                  "Enter subject name", Icons.subject, false, subjectName),
              buttonWidget(context, "ADD SUBJECT", () {
                Navigator.of(context).pop();
                subjectName.text = capitalize(subjectName.text);
                addSubject();
              }, false, 17),
            ],
          ),
        );
      },
    );
  }

  void fetchAllSubjects() async {
    try {
      setState(() {
        loadingFetch = true;
      });
      var url = Uri.https(host, '/attendance/get/${user?.email}');
      await http.get(url).then((value) {
        setState(() {
          loadingFetch = false;
          allUsers = json.decode(value.body);
        });
      });
    } catch (err) {
      setState(() {
        loadingFetch = false;
      });
      snackbarWidget(
          context, "Some internal error occurred.Try again later.", Colors.red);
    }
  }

  void addSubject() async {
    if (subjectName.text.isEmpty) {
      snackbarWidget(context, "Subject name cannot be empty.", Colors.red);
      return;
    }
    try {
      setState(() {
        loadingAdd = true;
      });
      var url = Uri.https(host, '/attendance/create');
      await http
          .post(url,
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{
                "email": user?.email as String,
                "subjectName": subjectName.text,
              }))
          .then((value) {
        setState(() {
          allUsers.add(json.decode(value.body));
        });
        snackbarWidget(
            context, "${subjectName.text} added successfully.", Colors.green);
        setState(() {
          loadingAdd = false;
        });
      });
    } catch (err) {
      setState(() {
        loadingAdd = false;
      });
      snackbarWidget(
          context, "Some internal error occurred.Try again later.", Colors.red);
    }
  }

  int findIndex(String id) {
    int index = 0;
    for (; index < allUsers.length; index++)
      if (allUsers[index]["_id"] == id) break;
    return index;
  }

  Future<void> editSubject(
      String id, String subjectName, int attendclass, int totalClass) async {
    try {
      var url = Uri.https(host, '/attendance/update');
      await http
          .patch(url,
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{
                "id": id,
                "subjectName": capitalize(subjectName),
                "attended": attendclass.toString(),
                "classes": totalClass.toString()
              }))
          .then((value) {
        int ind = findIndex(id);
        setState(() {
          allUsers[ind] = json.decode(value.body);
        });
        snackbarWidget(context, "Subject edited successfully.", Colors.green);
      });
    } catch (err) {
      snackbarWidget(
          context, "Some internal error occurred.Try again later.", Colors.red);
    }
  }

  Future<void> attendedClass(String id) async {
    try {
      var url = Uri.https(host, '/attendance/attended');
      await http
          .patch(url,
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{
                "id": id,
              }))
          .then((value) {
        int ind = findIndex(id);
        // setState(() {
        //   allUsers[ind] = json.decode(value.body);
        // });
      });
    } catch (err) {
      print(err.toString());
      snackbarWidget(
          context, "Some internal error occurred.Try again later.", Colors.red);
    }
  }

  Future<void> notAttendedClass(String id) async {
    try {
      var url = Uri.https(host, '/attendance/notattended');
      await http
          .patch(url,
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{
                "id": id,
              }))
          .then((value) {
        int ind = findIndex(id);
        // setState(() {
        //   allUsers[ind] = json.decode(value.body);
        // });
      });
    } catch (err) {
      print(err.toString());
      snackbarWidget(
          context, "Some internal error occurred.Try again later.", Colors.red);
    }
  }

  Future<void> deleteSubject(String id) async {
    try {
      var url = Uri.https(host, '/attendance/delete');
      await http
          .delete(url,
              headers: <String, String>{'Content-Type': 'application/json'},
              body: jsonEncode(<String, String>{
                "id": id,
              }))
          .then((value) {
        setState(() {
          allUsers.removeAt(findIndex(id));
        });
        snackbarWidget(
            context,
            "${json.decode(value.body)["subjectName"]} deleted successfully.",
            Colors.green);
      });
    } catch (err) {
      snackbarWidget(
          context, "Some internal error occurred.Try again later.", Colors.red);
    }
  }

  List<Widget> getList() {
    List<Widget> list = [];
    for (var i = 0; i < allUsers.length; i++) {
      list.add(
        new SubjectWidget(
          allUsers[i]["_id"] as String,
          allUsers[i]["email"] as String,
          allUsers[i]["subjectName"] as String,
          allUsers[i]["attended"] as int,
          allUsers[i]["classes"] as int,
          allUsers[i]["__v"] as int,
          editSubject,
          attendedClass,
          notAttendedClass,
          deleteSubject,
        ),
      );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(
            "Welcome ${user?.displayName?.substring(0, user?.displayName?.indexOf(" ") == -1 ? user?.displayName?.length : user?.displayName?.indexOf(" "))}"),
        backgroundColor: Colors.transparent,
      ),
      drawer: drawer_widget(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61f4"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: loadingFetch
            ? Center(
                child: loadingWidget(MediaQuery.of(context).size.height * 0.08),
              )
            : Container(
                margin: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height * 0.12, 0, 0),
                child: SingleChildScrollView(
                  child: allUsers.length == 0
                      ? Container(
                          margin: EdgeInsets.fromLTRB(0,
                              MediaQuery.of(context).size.height * 0.2, 0, 0),
                          child: Image.asset(
                            "lib/assets/pikachu.png",
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: getList(),
                        ),
                ),
              ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          showAddSubjectModal();
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(23),
              color: const Color.fromRGBO(17, 17, 17, 1)),
          child: loadingAdd
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      " Add Subject",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
