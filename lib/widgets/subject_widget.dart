import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import './button_widget.dart';
import './snackbar_widget.dart';
import './textfield_widget.dart';

class SubjectWidget extends StatefulWidget {
  String _id, email, subjectName;
  int attendedClass, totalClass, __v;
  Function editSubject, attendedClassFun, notAttendedClassFun, deleteSubject;

  SubjectWidget(
    this._id,
    this.email,
    this.subjectName,
    this.attendedClass,
    this.totalClass,
    this.__v,
    this.editSubject,
    this.attendedClassFun,
    this.notAttendedClassFun,
    this.deleteSubject,
  );

  @override
  State<SubjectWidget> createState() => _SubjectWidgetState();
}

class _SubjectWidgetState extends State<SubjectWidget> {
  TextEditingController _subjectName = TextEditingController();
  TextEditingController _attended = TextEditingController();
  TextEditingController _total = TextEditingController();

  void showEditBox() {
    _subjectName.text = widget.subjectName;
    _attended.text = widget.attendedClass.toString();
    _total.text = widget.totalClass.toString();
    showDialog(
      context: context,
      builder: (context) {
        return Card(
          margin: EdgeInsets.fromLTRB(
              0,
              MediaQuery.of(context).viewInsets.bottom > 0
                  ? MediaQuery.of(context).viewInsets.bottom - 60
                  : MediaQuery.of(context).size.height * 0.55,
              0,
              0),
          color: Colors.blueGrey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                textfieldWidget(
                    "Enter subject name", Icons.subject, false, _subjectName),
                SizedBox(height: 10),
                textfieldWidget("Enter no of classes attended", Icons.school,
                    false, _attended),
                SizedBox(height: 10),
                textfieldWidget(
                    "Enter total no of classes", Icons.schema, false, _total),
                buttonWidget(
                  context,
                  "Edit Subject",
                  () {
                    editSubject();
                    Navigator.of(context).pop();
                  },
                  false,
                  16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void editSubject() {
    if (_subjectName.text.isEmpty ||
        _total.text.isEmpty ||
        _attended.text.isEmpty) {
      snackbarWidget(context, "All the fields must be field", Colors.red);
      return;
    }
    if (int.parse(_attended.text) > int.parse(_total.text)) {
      snackbarWidget(context,
          "Attended classes cannot be greater than total classes.", Colors.red);
      return;
    }
    widget.editSubject(widget._id, _subjectName.text, int.parse(_attended.text),
        int.parse(_total.text));
  }

  void attendedClass() {
    setState(() {
      widget.totalClass++;
      widget.attendedClass++;
    });
    widget.attendedClassFun(widget._id);
  }

  void notAttendedClass() {
    setState(() {
      widget.totalClass++;
    });
    widget.notAttendedClassFun(widget._id);
  }

  get status {
    if (widget.attendedClass == 0 && widget.totalClass == 0) {
      return "NA";
    }
    if ((widget.attendedClass / widget.totalClass) * 100 >= 75) {
      var x = (4 * widget.attendedClass - 3 * widget.totalClass) / 3;
      x = x < 1 ? 0 : x;
      if (x == 0) {
        return "You can't miss any class.";
      }
      if (int.parse(x.toStringAsFixed(0)) == 1) {
        return "You can miss next class.";
      }
      return "You can miss next ${x.toStringAsFixed(0)} classes.";
    }
    var x =
        (3 * widget.totalClass - 4 * widget.attendedClass).toStringAsFixed(0);
    if (int.parse(x) == 1) {
      return "Please attend the next class.";
    }
    return "Please attend next ${x} classes.";
  }

  void showDeleteBox() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Are you sure?',
      desc: 'This action cannot be undone.',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        widget.deleteSubject(widget._id);
      },
      btnCancelText: "CANCEL",
      btnOkText: "OK",
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.white54,
              blurStyle: BlurStyle.outer,
              blurRadius: 4.0,
              offset: Offset(0.0, 0.0),
            )
          ]
          // color: Colors.red
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.55,
                child: Text(
                  widget.subjectName,
                  style: textStyle,
                ),
              ),
              Text(
                "Attendance ${widget.attendedClass}/${widget.totalClass}",
                style: textStyle,
              ),
              Text(
                "Status: ${status}",
                style: TextStyle(
                  fontSize: 15.1,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                      onPressed: () {
                        showEditBox();
                      },
                      icon: const Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.black38,
                    child: IconButton(
                        onPressed: () {
                          showDeleteBox();
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                        )),
                  ),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularPercentIndicator(
                radius: 35.0,
                lineWidth: 7.0,
                percent: widget.attendedClass == 0 && widget.totalClass == 0
                    ? 0
                    : (widget.attendedClass / widget.totalClass),
                center: widget.attendedClass == 0 && widget.totalClass == 0
                    ? Text(
                        "0%",
                        style: textStyle,
                      )
                    : Text(
                        "${(widget.attendedClass / widget.totalClass * 100).toStringAsFixed(0)}%",
                        style: textStyle,
                      ),
                progressColor:
                    (widget.attendedClass / widget.totalClass * 100) >= 75
                        ? Colors.green
                        : Colors.red,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        attendedClass();
                      },
                      icon: const Icon(
                        Icons.check,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    child: IconButton(
                      color: Colors.black,
                      onPressed: () {
                        notAttendedClass();
                      },
                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
