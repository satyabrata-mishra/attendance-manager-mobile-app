import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/capitalize_string.dart';

import '../widgets/button_widget.dart';
import '../widgets/snackbar_widget.dart';
import '../widgets/textfield_widget.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/subject_widget.dart';

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
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.50,
      ),
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

  void fetchAllSubjects() {
    //API call for fetching subjects for the current user.

    allUsers = [
      {
        "_id": "645e5709ae8bc06b42df05c4",
        "email": "dug7904@gmail.com",
        "subjectName": "Computer Networking",
        "attended": 0,
        "classes": 0,
        "__v": 0
      },
      {
        "_id": "645e80f3e3f65209d90d8c97",
        "email": "dug7904@gmail.com",
        "subjectName": "Operating System Workshop",
        "attended": 0,
        "classes": 0,
        "__v": 0
      }
    ];
  }

  void addSubject() {
    //Add subject API call here

    if (subjectName.text.isEmpty) {
      snackbarWidget(context, "Subject name cannot be empty.", Colors.red);
      return;
    }
    setState(() {
      allUsers.add({
        "_id": "1234",
        "email": user?.email as String,
        "subjectName": subjectName.text,
        "attended": 0,
        "classes": 0,
        "__v": 0
      });
    });
    snackbarWidget(
        context, "${subjectName.text} added successfully.", Colors.green);
  }

  int findIndex(String id) {
    int index = 0;
    for (; index < allUsers.length; index++)
      if (allUsers[index]["_id"] == id) break;
    return index;
  }

  void editSubject(
      String id, String subjectName, int attendclass, int totalClass) {
    //Edit subject API call here

    setState(() {
      allUsers[findIndex(id)]["subjectName"] = capitalize(subjectName);
      allUsers[findIndex(id)]["attended"] = attendclass;
      allUsers[findIndex(id)]["classes"] = totalClass;
    });
    snackbarWidget(context, "Subject edited successfully.", Colors.green);
  }

  void attendedClass(String id) {
    //Attended class API call here

    setState(() {
      allUsers[findIndex(id)]["attended"] =
          int.parse(allUsers[findIndex(id)]["attended"].toString()) + 1;
      allUsers[findIndex(id)]["classes"] =
          int.parse(allUsers[findIndex(id)]["classes"].toString()) + 1;
    });
  }

  void notAttendedClass(String id) {
    //Not attended class API call here

    setState(() {
      allUsers[findIndex(id)]["classes"] =
          int.parse(allUsers[findIndex(id)]["classes"].toString()) + 1;
    });
  }

  void deleteSubject(String id) {
    //Delete subject API call here

    String temp = allUsers[findIndex(id)]["subjectName"].toString();
    setState(() {
      allUsers.removeAt(findIndex(id));
    });
    snackbarWidget(context, "${temp} deleted successfully.", Colors.green);
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
        child: Container(
          margin: EdgeInsets.fromLTRB(
              0, MediaQuery.of(context).size.height * 0.12, 0, 0),
          child: SingleChildScrollView(
            child: allUsers.length == 0
                ? Container(
                    margin: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height * 0.2, 0, 0),
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
          child: Row(
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
                  fontSize: 17,
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
