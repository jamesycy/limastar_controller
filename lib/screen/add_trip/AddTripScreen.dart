import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTripScreen extends StatefulWidget {
  @override
    _AddTripScreenState createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _fs = Firestore.instance;
  final _title = TextEditingController();
  String _createdAt;
  var _active = true;

  Widget _datePicker() {
    final today = DateTime.now();
    return RaisedButton(
      child: Text(_createdAt == null ? "Please Pick a date" : _createdAt.toString()),
      color: Colors.amberAccent,
      textColor: Colors.black,
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          firstDate: DateTime(today.year - 2, today.month, today.day),
          lastDate: DateTime(today.year + 2, today.month, today.day),
          initialDate: DateTime.now(),
        );
        setState(() {
          _createdAt = '${date.year}/${date.month}/${date.day}';
        });
      }
    );
  }

  void _createTrip() {
    final result = _verifyInput();
    if (result == true) {
      _fs.collection("trips").add({
        "title": _title.text,
        "created_at": _createdAt.toString(),
        "active": _active,
        "helpers": 0
      }).then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        showDialog(context: context, builder: (BuildContext context) => _buildAlert(error.toString()));
      });
    } else {
      showDialog(context: context, builder: (BuildContext context) => _buildAlert("Please enter Trip Title and Trip Date"));
    }
  }

  bool _verifyInput() {
    if (_title.text.isNotEmpty) {
      if (_active != null) {
        if (_createdAt != null) {
          return true;
        } 
      }  
    }
    return false;
  }

  AlertDialog _buildAlert(String content) {
    return AlertDialog(
      title: Text("Error"),
      content: Text(content),
      actions: <Widget>[
        FlatButton(child: Text("Dismiss"), onPressed: () { Navigator.of(context).pop(); })
      ],
    );  
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Add Trip")
        ),
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 5.0,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(controller: _title, decoration: InputDecoration(labelText: "Trip Title")),
                      ListTile(title: Text("Trip Date"), trailing: _datePicker()),
                      ListTile(title: Text("Trip Status"), trailing: Switch(value: _active, onChanged: (value) {
                        setState(() {
                          _active = value;
                        });
                      }))
                    ]
                  )
                )
              )
            ],
          )
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          child: Icon(Icons.save),
          onPressed: () {
            _createTrip();
          }
        ),
      );
    }
}