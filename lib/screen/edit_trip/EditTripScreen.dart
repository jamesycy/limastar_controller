import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTripScreen extends StatefulWidget {
  final String tripid;

  EditTripScreen({ Key key, @required this.tripid }) : super(key:key);

  @override
    _EditTripState createState() => _EditTripState();
}

class _EditTripState extends State<EditTripScreen> {
  final _fs = Firestore.instance;
  var _title;
  var _createdAt;
  var _active;

  Widget _datePicker() {
    return RaisedButton(
      child: Text(_createdAt),
      color: Colors.yellow,
      textColor: Colors.black,
      onPressed: () async {
        final today = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(today.year - 2, today.month, today.day),
          lastDate: DateTime(today.year + 2, today.month, today.day)
        );
        setState(() {
          _createdAt = '${date.year}/${date.month}/${date.day}';
        });
      }
    );
  }

  _saveChanges() {
    _fs.collection("trips").document(widget.tripid).updateData({
      "title": _title.text,
      "created_at": _createdAt,
      "active": _active
    }).then((_) {
      Navigator.of(context).pop();
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(error.toString()),
            actions: <Widget>[
              FlatButton(child: Text("Dismiss"), onPressed:() {
                Navigator.of(context).pop();
              })
            ],
          );
        }
      );
    });
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Edit Trip")
        ),
        body: StreamBuilder(
          stream: _fs.collection("trips").document(widget.tripid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.data == null) {
              return Center(child: Text("Trip Not Found"));
            }

            if (snapshot.data.data == null) {
              return Center(child: Text("Trip No Detail"));
            }

            _title == null ? _title = TextEditingController(text: snapshot.data.data['title']) : null;
            _createdAt == null ? _createdAt = snapshot.data.data['created_at'] : null;
            _active == null ? _active = snapshot.data.data['active'] : null;

            return Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 5.0,
                    margin: EdgeInsets.all(12.0),
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
                        ],
                      )
                    )
                  ),

                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                    child: RaisedButton(
                      color: Colors.blueAccent,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      textColor: Colors.white,
                      child: Text("Save Changes", style: TextStyle(fontSize: 16.0)),
                      onPressed: () {
                        _saveChanges();
                      }
                    )
                  )
                ],
              )
            );

          }
        )
      );
    }
}